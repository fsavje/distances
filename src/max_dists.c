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

#include "max_dists.h"
#include <math.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>
#include <R.h>
#include <Rinternals.h>
#include "error.h"
#include "internal.h"
#include "utils.h"


static const int32_t DIST_MAXDIST_STRUCT_VERSION = 722439001;

struct idist_MaxSearch {
	int32_t max_dist_version;
	SEXP R_distances;
	size_t len_search_indices;
	const int* search_indices;
};


SEXP dist_max_distance_search(const SEXP R_distances,
                              const SEXP R_query_indices,
                              const SEXP R_search_indices)
{
	idist_assert(idist_check_distance_object(R_distances));
	idist_assert(isNull(R_query_indices) || isInteger(R_query_indices));
	idist_assert(isNull(R_search_indices) || isInteger(R_search_indices));

	const int num_data_points = INTEGER(getAttrib(R_distances, R_DimSymbol))[1];

	SEXP R_query_indices_local = PROTECT(translate_R_index_vector(R_query_indices, num_data_points));
	const size_t len_query_indices = isInteger(R_query_indices_local) ? (size_t) xlength(R_query_indices_local) : (size_t) num_data_points;
	const int* const query_indices = isInteger(R_query_indices_local) ? INTEGER(R_query_indices_local) : NULL;

	SEXP R_search_indices_local = PROTECT(translate_R_index_vector(R_search_indices, num_data_points));
	const size_t len_search_indices = isInteger(R_search_indices_local) ? (size_t) xlength(R_search_indices_local) : (size_t) num_data_points;
	const int* const search_indices = isInteger(R_search_indices_local) ? INTEGER(R_search_indices_local) : NULL;

	idist_MaxSearch* max_dist_object;
	idist_init_max_distance_search(R_distances,
	                               len_search_indices,
	                               search_indices,
	                               &max_dist_object);

	SEXP R_out_max_indices = PROTECT(allocVector(INTSXP, (R_xlen_t) len_query_indices));
	int* const out_max_indices = INTEGER(R_out_max_indices);
	SEXP R_out_max_dists = PROTECT(allocVector(REALSXP, (R_xlen_t) len_query_indices));
	double* const out_max_dists = REAL(R_out_max_dists);

	idist_max_distance_search(max_dist_object,
	                          len_query_indices,
	                          query_indices,
	                          out_max_indices,
	                          out_max_dists);

	idist_close_max_distance_search(&max_dist_object);

	const int* const write_stop = out_max_indices + len_query_indices;
	for (int* write = out_max_indices; write != write_stop; ++write) {
		++(*write);
	}

	setAttrib(R_out_max_indices, R_NamesSymbol, get_labels(R_distances, R_query_indices));

	UNPROTECT(4);
	return R_out_max_indices;
}


bool idist_init_max_distance_search(const SEXP R_distances,
                                    const size_t len_search_indices,
                                    const int search_indices[const],
                                    idist_MaxSearch** const out_max_dist_object)
{
	idist_assert(idist_check_distance_object(R_distances));
	idist_assert(out_max_dist_object != NULL);

	*out_max_dist_object = malloc(sizeof(idist_MaxSearch));
	if (*out_max_dist_object == NULL) return false;

	// Register R_distances with R's garbage collector

	**out_max_dist_object = (idist_MaxSearch) {
		.max_dist_version = DIST_MAXDIST_STRUCT_VERSION,
		.R_distances = R_distances,
		.len_search_indices = len_search_indices,
		.search_indices = search_indices,
	};

	return true;
}


bool idist_max_distance_search(idist_MaxSearch* const max_dist_object,
                               const size_t len_query_indices,
                               const int query_indices[const],
                               int out_max_indices[const],
                               double out_max_dists[const])
{
	idist_assert(max_dist_object != NULL);
	idist_assert(max_dist_object->max_dist_version == DIST_MAXDIST_STRUCT_VERSION);
	idist_assert(out_max_indices != NULL);
	idist_assert(out_max_dists != NULL);

	SEXP R_distances = max_dist_object->R_distances;
	idist_assert(idist_check_distance_object(R_distances));

	const double* const raw_data_matrix = REAL(R_distances);
	const int num_dimensions = INTEGER(getAttrib(R_distances, R_DimSymbol))[0];
	const int num_data_points = INTEGER(getAttrib(R_distances, R_DimSymbol))[1];
	const size_t len_search_indices = max_dist_object->len_search_indices;
	const int* const search_indices = max_dist_object->search_indices;

	const int num_queries = (query_indices == NULL) ? num_data_points : (int) len_query_indices;

	double tmp_dist;
	double max_dist;

	if (search_indices == NULL) {
		for (int q = 0; q < num_queries; ++q) {
			const int query = (query_indices == NULL) ? q : query_indices[q];
			max_dist = -1.0;
			for (int s = 0; s < num_data_points; ++s) {
				tmp_dist = sqrt(idist_get_sq_dist(raw_data_matrix, num_dimensions, query, s));
				if (max_dist < tmp_dist) {
					max_dist = tmp_dist;
					out_max_indices[q] = s;
				}
			}
			out_max_dists[q] = sqrt(max_dist);
		}

	} else {
		for (int q = 0; q < num_queries; ++q) {
			const int query = (query_indices == NULL) ? q : query_indices[q];
			max_dist = -1.0;
			for (size_t s = 0; s < len_search_indices; ++s) {
				tmp_dist = sqrt(idist_get_sq_dist(raw_data_matrix, num_dimensions, query, search_indices[s]));
				if (max_dist < tmp_dist) {
					max_dist = tmp_dist;
					out_max_indices[q] = search_indices[s];
				}
			}
			out_max_dists[q] = sqrt(max_dist);
		}
	}

	return true;
}


bool idist_close_max_distance_search(idist_MaxSearch** const out_max_dist_object)
{
	// Release R_distances with R's garbage collector

	if (out_max_dist_object != NULL && *out_max_dist_object != NULL) {
		idist_assert((*out_max_dist_object)->max_dist_version == DIST_MAXDIST_STRUCT_VERSION);
		free(*out_max_dist_object);
		*out_max_dist_object = NULL;
	}
	return true;
}
