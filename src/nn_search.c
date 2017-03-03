/* =============================================================================
 * distances -- Distance metric tools for R
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

	const size_t len_query_indices = isInteger(R_query_indices) ? (size_t) xlength(R_query_indices) : (size_t) num_data_points;
	const int* const query_indices = isInteger(R_query_indices) ? INTEGER(R_query_indices) : NULL;
	const size_t len_search_indices = isInteger(R_search_indices) ? (size_t) xlength(R_search_indices) : (size_t) num_data_points;
	const int* const search_indices = isInteger(R_search_indices) ? INTEGER(R_search_indices) : NULL;

	const bool radius_search = isReal(R_radius);
	const double radius = isReal(R_radius) ? asReal(R_radius) : 0.0;

	idist_NNSearch* nn_search_object;
	if (!idist_init_nearest_neighbor_search(R_distances,
	                                        len_search_indices,
	                                        search_indices,
	                                        &nn_search_object)) {
			idist_error("`idist_init_nearest_neighbor_search` failed.");
	}

	size_t out_num_ok_queries;
	SEXP R_out_query_indices = PROTECT(allocVector(INTSXP, (R_xlen_t) len_query_indices));
	int* const out_query_indices = INTEGER(R_out_query_indices);
	SEXP R_out_nn_indices = PROTECT(allocVector(INTSXP, (R_xlen_t) (k * len_query_indices)));
	int* const out_nn_indices = INTEGER(R_out_nn_indices);

	if (!idist_nearest_neighbor_search(nn_search_object,
	                                   len_query_indices,
	                                   query_indices,
	                                   k,
	                                   radius_search,
	                                   radius,
	                                   &out_num_ok_queries,
	                                   out_query_indices,
	                                   out_nn_indices)) {
			idist_close_nearest_neighbor_search(&nn_search_object);
			idist_error("`idist_nearest_neighbor_search` failed.");
	}

	if (!idist_close_nearest_neighbor_search(&nn_search_object)) {
			idist_error("`idist_close_nearest_neighbor_search` failed.");
	}

	const SEXP R_output = PROTECT(allocVector(VECSXP, 3));
	SET_VECTOR_ELT(R_output, 0, ScalarInteger((int) out_num_ok_queries));
	SET_VECTOR_ELT(R_output, 1, R_out_query_indices);
	SET_VECTOR_ELT(R_output, 2, R_out_nn_indices);

	const SEXP R_output_names = PROTECT(allocVector(STRSXP, 3));
	SET_STRING_ELT(R_output_names, 0, mkChar("num_ok_queries"));
	SET_STRING_ELT(R_output_names, 1, mkChar("out_query_indices"));
	SET_STRING_ELT(R_output_names, 2, mkChar("out_nn_indices"));
	setAttrib(R_output, R_NamesSymbol, R_output_names);

	UNPROTECT(4);
	return R_output;
}
