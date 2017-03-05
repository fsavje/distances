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
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <R.h>
#include <Rinternals.h>
#include "error.h"
#include "internal.h"
#include "utils.h"


SEXP dist_nearest_neighbor_search(const SEXP R_distances,
                                  const SEXP R_k,
                                  const SEXP R_query_indices,
                                  const SEXP R_search_indices,
                                  const SEXP R_radius)
{
	idist_assert(idist_check_distance_object(R_distances));
	idist_assert(isInteger(R_k));
	idist_assert(isNull(R_query_indices) || isInteger(R_query_indices));
	idist_assert(isNull(R_search_indices) || isInteger(R_search_indices));
	idist_assert(isNull(R_radius) || isReal(R_radius));

	const int num_data_points = INTEGER(getAttrib(R_distances, R_DimSymbol))[1];

	const uint32_t k = (uint32_t) asInteger(R_k);

	SEXP R_query_indices_local = PROTECT(translate_R_index_vector(R_query_indices, num_data_points));
	const size_t len_query_indices = isInteger(R_query_indices_local) ? (size_t) xlength(R_query_indices_local) : (size_t) num_data_points;
	const int* const query_indices = isInteger(R_query_indices_local) ? INTEGER(R_query_indices_local) : NULL;

	SEXP R_search_indices_local = PROTECT(translate_R_index_vector(R_search_indices, num_data_points));
	const size_t len_search_indices = isInteger(R_search_indices_local) ? (size_t) xlength(R_search_indices_local) : (size_t) num_data_points;
	const int* const search_indices = isInteger(R_search_indices_local) ? INTEGER(R_search_indices_local) : NULL;

	const bool radius_search = isReal(R_radius);
	const double radius = radius_search ? asReal(R_radius) : 0.0;
	if (radius_search) idist_assert(radius > 0.0);

	idist_NNSearch* nn_search_object;
	idist_init_nearest_neighbor_search(R_distances,
	                                   len_search_indices,
	                                   search_indices,
	                                   &nn_search_object);

	size_t out_num_ok_queries;
	SEXP R_out_query_indices = PROTECT(allocVector(INTSXP, (R_xlen_t) len_query_indices));
	int* const out_query_indices = INTEGER(R_out_query_indices);
	SEXP R_out_nn_indices = PROTECT(allocMatrix(INTSXP, k, len_query_indices));
	int* const out_nn_indices = INTEGER(R_out_nn_indices);

	idist_nearest_neighbor_search(nn_search_object,
	                              len_query_indices,
	                              query_indices,
	                              k,
	                              radius_search,
	                              radius,
	                              &out_num_ok_queries,
	                              out_query_indices,
	                              out_nn_indices);

	idist_close_nearest_neighbor_search(&nn_search_object);

	if (out_num_ok_queries < len_query_indices) {
		SEXP R_tmp_nn_indices = R_out_nn_indices;
		R_out_nn_indices = PROTECT(allocMatrix(INTSXP, k, len_query_indices));
		const int* ok_query = out_query_indices;
		const int* const ok_query_stop = ok_query + out_num_ok_queries;
		const int* read = INTEGER(R_tmp_nn_indices);
		int* write = INTEGER(R_out_nn_indices);

		for (size_t q = 0; q < len_query_indices; ++q) {
			const int query = (query_indices == NULL) ? (int) q : query_indices[q];
			const int* const write_stop = write + k;
			if ((ok_query != ok_query_stop) && (*ok_query == query)) {
				for (; write != write_stop; ++read, ++write) {
					*write = *read + 1;
				}
				ok_query++;
			} else {
				for (; write != write_stop; ++write) {
					*write = NA_INTEGER;
				}
			}
		}
	} else {
		PROTECT(R_out_nn_indices);
		int* write = INTEGER(R_out_nn_indices);
		const int* const write_stop = write + k * len_query_indices;
		for (; write != write_stop; ++write) {
			*write = *write + 1;
		}
	}

	SEXP dimnames = PROTECT(allocVector(VECSXP, 2));
	SET_VECTOR_ELT(dimnames, 0, R_NilValue);
	SET_VECTOR_ELT(dimnames, 1, get_labels(R_distances, R_query_indices));
	setAttrib(R_out_nn_indices, R_DimNamesSymbol, dimnames);

	UNPROTECT(6);
	return R_out_nn_indices;
}
