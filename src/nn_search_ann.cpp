/* =============================================================================
 * distances -- R package with tools for distance metrics
 * https://github.com/fsavje/distances
 *
 * Copyright (C) 2017  Fredrik Savje -- http://fredriksavje.com
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see http://www.gnu.org/licenses/
 * ========================================================================== */

#include "nn_search.h"
#include <cstddef>
#include <R.h>
#include <Rinternals.h>
// R defines `length` which collides with the ANN library
// We don't use it, so we'll remove it
#undef length
#include "libann/include/ANN/ANN.h"
#include "error.h"
#include "utils.h"


#ifdef DIST_ANN_BDTREE
	#define ANNpointSetConstructor ANNbd_tree
#else
	#define ANNpointSetConstructor ANNkd_tree
#endif

#ifndef DIST_ANN_EPS
	#define DIST_ANN_EPS 0.0
#endif


static int idist_ann_open_search_objects = 0;

static const int32_t IDIST_ANN_NN_SEARCH_STRUCT_VERSION = 155294001;

struct idist_NNSearch {
	int32_t nn_search_version;
	SEXP R_distances;
	const int* search_indices;
	ANNpoint* search_points;
	ANNpointSet* search_tree;
};


bool idist_init_nearest_neighbor_search(SEXP R_distances,
                                        const size_t len_search_indices,
                                        const int* const search_indices,
                                        idist_NNSearch** const out_nn_search_object)
{
	idist_assert(idist_ann_open_search_objects >= 0);
	idist_assert(idist_check_distance_object(R_distances));
	idist_assert(out_nn_search_object != NULL);

	double* const raw_data_matrix = REAL(R_distances);
	const int num_dimensions = INTEGER(getAttrib(R_distances, R_DimSymbol))[0];
	const int num_data_points = INTEGER(getAttrib(R_distances, R_DimSymbol))[1];

	const size_t num_search_points = (search_indices == NULL) ? static_cast<size_t>(num_data_points) : len_search_indices;

	ANNpoint* search_points;
	try {
		*out_nn_search_object = new idist_NNSearch;
		search_points = new ANNpoint[num_search_points];
	} catch (...) {
		return false;
	}

	if (search_indices == NULL) {
		double* search_point = raw_data_matrix;
		for (size_t i = 0; i < num_search_points; ++i, search_point += num_dimensions) {
			search_points[i] = search_point;
		}
	} else if (search_indices != NULL) {
		for (size_t i = 0; i < num_search_points; ++i) {
			search_points[i] = raw_data_matrix + search_indices[i] * num_dimensions;
		}
	}

	ANNpointSet* search_tree;
	try {
		search_tree = new ANNpointSetConstructor(search_points,
		                                         static_cast<int>(num_search_points),
		                                         num_dimensions);
	} catch (...) {
		delete[] search_points;
		delete *out_nn_search_object;
		*out_nn_search_object = NULL;
		return false;
	}

	// Register R_distances with R's garbage collector

	(*out_nn_search_object)->nn_search_version = IDIST_ANN_NN_SEARCH_STRUCT_VERSION;
	(*out_nn_search_object)->R_distances = R_distances;
	(*out_nn_search_object)->search_indices = search_indices;
	(*out_nn_search_object)->search_points = search_points;
	(*out_nn_search_object)->search_tree = search_tree;

	++idist_ann_open_search_objects;
	return true;
}


bool idist_nearest_neighbor_search(idist_NNSearch* const nn_search_object,
                                   const size_t len_query_indices,
                                   const int* const query_indices,
                                   const uint32_t k,
                                   const bool radius_search,
                                   const double radius,
                                   size_t* const out_num_ok_queries,
                                   int* const out_query_indices,
                                   int* const out_nn_indices)
{
	idist_assert(idist_ann_open_search_objects > 0);
	idist_assert(nn_search_object != NULL);
	idist_assert(nn_search_object->nn_search_version == IDIST_ANN_NN_SEARCH_STRUCT_VERSION);

	SEXP R_distances = nn_search_object->R_distances;
	idist_assert(idist_check_distance_object(R_distances));

	ANNpointSet* const search_tree = nn_search_object->search_tree;
	idist_assert(search_tree != NULL);

	const int* const search_indices = nn_search_object->search_indices;

	idist_assert(k > 0);
	idist_assert(!radius_search || (radius > 0.0));
	idist_assert(out_num_ok_queries != NULL);
	idist_assert(out_nn_indices != NULL);

	const int k_int = static_cast<int>(k);

	double* const raw_data_matrix = REAL(R_distances);
	const int num_dimensions = INTEGER(getAttrib(R_distances, R_DimSymbol))[0];
	const int num_data_points = INTEGER(getAttrib(R_distances, R_DimSymbol))[1];

	const int num_queries = (query_indices == NULL) ? num_data_points : (int) len_query_indices;

	ANNdist* dist_scratch;
	try {
		dist_scratch = new ANNdist[k];
	} catch (...) {
		return false;
	}

	size_t num_ok_queries = 0;

	if (!radius_search) {
		int* write_nnidx = out_nn_indices;
		for (int q = 0; q < num_queries; ++q) {
			const int query = (query_indices == NULL) ? q : query_indices[q];
			const ANNpoint query_point = raw_data_matrix + query * num_dimensions;
			search_tree->annkSearch(query_point,    // pointer to query point
			                        k_int,          // number of neighbors
			                        write_nnidx,    // pointer to start of index result
			                        dist_scratch,   // pointer to start of distance result
			                        DIST_ANN_EPS);  // error margin
			if (search_indices == NULL) {
				// Sequential indices, all done
				write_nnidx += k;
			} else {
				// Not sequential indices, translate to original indices
				const int* const write_nnidx_stop = write_nnidx + k;
				for (; write_nnidx != write_nnidx_stop; ++write_nnidx) {
					*write_nnidx = search_indices[*write_nnidx];
				}
			}
			if (out_query_indices != NULL) {
				out_query_indices[num_ok_queries] = query;
			}
			++num_ok_queries;
		}

	} else {
		// radius_search == TRUE
		const double radius_sq = radius * radius;
		int* write_nnidx = out_nn_indices;
		for (int q = 0; q < num_queries; ++q) {
			const int query = (query_indices == NULL) ? q : query_indices[q];
			const ANNpoint query_point = raw_data_matrix + query * num_dimensions;
			const int num_found = search_tree->annkFRSearch(query_point,              // pointer to query point
			                                                radius_sq,                // squared caliper
			                                                k_int,                    // number of neighbors
			                                                write_nnidx,              // pointer to start of index result
			                                                dist_scratch,             // pointer to start of distance result
			                                                DIST_ANN_EPS);            // error margin
			if (num_found >= k_int) {
				if (search_indices == NULL) {
					// Sequential indices, all done
					write_nnidx += k;
				} else {
					// Not sequential indices, translate to original indices
					const int* const write_nnidx_stop = write_nnidx + k;
					for (; write_nnidx != write_nnidx_stop; ++write_nnidx) {
						*write_nnidx = search_indices[*write_nnidx];
					}
				}
				if (out_query_indices != NULL) {
					out_query_indices[num_ok_queries] = query;
				}
				++num_ok_queries;
			}
		}
	}

	delete[] dist_scratch;

	*out_num_ok_queries = num_ok_queries;
	return true;
}


bool idist_close_nearest_neighbor_search(idist_NNSearch** const out_nn_search_object)
{
	// Release R_distances with R's garbage collector

	idist_assert(idist_ann_open_search_objects >= 0);

	if ((out_nn_search_object != NULL) && (*out_nn_search_object != NULL)) {
		idist_assert((*out_nn_search_object)->nn_search_version == IDIST_ANN_NN_SEARCH_STRUCT_VERSION);
		delete (*out_nn_search_object)->search_tree;
		delete[] (*out_nn_search_object)->search_points;
		delete *out_nn_search_object;
		*out_nn_search_object = NULL;
	}

	if (idist_ann_open_search_objects > 0) {
		--idist_ann_open_search_objects;
	}

	if (idist_ann_open_search_objects == 0) {
		annClose();
	}

	return true;
}
