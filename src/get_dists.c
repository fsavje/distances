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

#include "get_dists.h"
#include <stdbool.h>
#include <stddef.h>
#include <R.h>
#include <Rinternals.h>
#include "error.h"
#include "internal.h"
#include "utils.h"


SEXP dist_get_dist_matrix(const SEXP R_distances,
                          const SEXP R_point_indices)
{
	idist_assert(idist_check_distance_object(R_distances));
	idist_assert(isNull(R_point_indices) || isInteger(R_point_indices));

	const int num_data_points = INTEGER(getAttrib(R_distances, R_DimSymbol))[1];
	const size_t len_point_indices = isInteger(R_point_indices) ? (size_t) xlength(R_point_indices) : (size_t) num_data_points;
	const int* const point_indices = isInteger(R_point_indices) ? INTEGER(R_point_indices) : NULL;
	const size_t dist_mat_size = ((len_point_indices - 1) * len_point_indices) / 2;

	SEXP R_output_dists = PROTECT(allocVector(REALSXP, (R_xlen_t) dist_mat_size));
	double* const output_dists = REAL(R_output_dists);

	if (!idist_get_dist_matrix(R_distances,
	                           len_point_indices,
	                           point_indices,
	                           output_dists)) {
			idist_error("`idist_get_dist_matrix` failed.");
	}

	UNPROTECT(1);
	return R_output_dists;
}


SEXP dist_get_dist_rows(const SEXP R_distances,
                        const SEXP R_row_indices,
                        const SEXP R_column_indices)
{
	idist_assert(idist_check_distance_object(R_distances));
	idist_assert(isInteger(R_row_indices));
	idist_assert(isNull(R_column_indices) || isInteger(R_column_indices));

	const int num_data_points = INTEGER(getAttrib(R_distances, R_DimSymbol))[1];
	const size_t len_row_indices = (size_t) xlength(R_row_indices);
	const int* const row_indices = INTEGER(R_row_indices);
	const size_t len_column_indices = isInteger(R_column_indices) ? (size_t) xlength(R_column_indices) : (size_t) num_data_points;
	const int* const column_indices = isInteger(R_column_indices) ? INTEGER(R_column_indices) : NULL;
	const size_t dist_mat_size = len_row_indices * len_column_indices;

	SEXP R_output_dists = PROTECT(allocVector(REALSXP, (R_xlen_t) dist_mat_size));
	double* const output_dists = REAL(R_output_dists);

	if (!idist_get_dist_rows(R_distances,
	                         len_row_indices,
	                         row_indices,
	                         len_column_indices,
	                         column_indices,
	                         output_dists)) {
			idist_error("`idist_get_dist_rows` failed.");
	}

	UNPROTECT(1);
	return R_output_dists;
}


// `output_dists` must be of length `(len_point_indices - 1) len_point_indices / 2`
bool idist_get_dist_matrix(const SEXP R_distances,
                           const size_t len_point_indices,
                           const int point_indices[const],
                           double output_dists[])
{
	idist_assert(idist_check_distance_object(R_distances));
	idist_assert(output_dists != NULL);

	const double* const raw_data_matrix = REAL(R_distances);
	const int num_dimensions = INTEGER(getAttrib(R_distances, R_DimSymbol))[0];
	const int num_data_points = INTEGER(getAttrib(R_distances, R_DimSymbol))[1];

	if (point_indices == NULL) {
		for (int p1 = 0; p1 < num_data_points; ++p1) {
			for (int p2 = p1 + 1; p2 < num_data_points; ++p2) {
				*output_dists = sqrt(idist_get_sq_dist(raw_data_matrix, num_dimensions, p1, p2));
				++output_dists;
			}
		}
	} else {
		for (size_t p1 = 0; p1 < len_point_indices; ++p1) {
			for (size_t p2 = p1 + 1; p2 < len_point_indices; ++p2) {
				*output_dists = sqrt(idist_get_sq_dist(raw_data_matrix, num_dimensions, point_indices[p1], point_indices[p2]));
				++output_dists;
			}
		}
	}

	return true;
}


// `output_dists` must be of length `len_query_indices * len_column_indices`
bool idist_get_dist_rows(const SEXP R_distances,
                         const size_t len_row_indices,
                         const int row_indices[const],
                         const size_t len_column_indices,
                         const int column_indices[const],
                         double output_dists[])
{
	idist_assert(idist_check_distance_object(R_distances));
	idist_assert(output_dists != NULL);
	idist_assert(len_row_indices > 0);
	idist_assert(row_indices != NULL);

	const double* const raw_data_matrix = REAL(R_distances);
	const int num_data_points = INTEGER(getAttrib(R_distances, R_DimSymbol))[1];
	const int num_dimensions = INTEGER(getAttrib(R_distances, R_DimSymbol))[0];

	if (column_indices == NULL) {
		for (size_t r = 0; r < len_row_indices; ++r) {
			for (int c = 0; c < num_data_points; ++c) {
				*output_dists = sqrt(idist_get_sq_dist(raw_data_matrix, num_dimensions, row_indices[r], c));
				++output_dists;
			}
		}
	} else {
		for (size_t r = 0; r < len_row_indices; ++r) {
			for (size_t c = 0; c < len_column_indices; ++c) {
				*output_dists = sqrt(idist_get_sq_dist(raw_data_matrix, num_dimensions, row_indices[r], column_indices[c]));
				++output_dists;
			}
		}
	}

	return true;
}
