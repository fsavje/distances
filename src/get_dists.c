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

#include "get_dists.h"
#include <stdbool.h>
#include <stddef.h>
#include <R.h>
#include <Rinternals.h>
#include "error.h"
#include "internal.h"
#include "utils.h"


SEXP dist_get_dist_matrix(const SEXP R_distances,
                          const SEXP R_indices)
{
	idist_assert(idist_check_distance_object(R_distances));
	idist_assert(isNull(R_indices) || isInteger(R_indices));

	const int num_data_points = INTEGER(getAttrib(R_distances, R_DimSymbol))[1];

	SEXP R_indices_local = PROTECT(translate_R_index_vector(R_indices, num_data_points));
	const size_t len_indices = isInteger(R_indices_local) ? (size_t) xlength(R_indices_local) : (size_t) num_data_points;
	int* const indices = isInteger(R_indices_local) ? INTEGER(R_indices_local) : NULL;

	SEXP R_output_dists = PROTECT(allocVector(REALSXP, (R_xlen_t) (((len_indices - 1) * len_indices) / 2)));
	double* const output_dists = REAL(R_output_dists);

	idist_get_dist_matrix(R_distances,
	                      len_indices,
	                      indices,
	                      output_dists);

	setAttrib(R_output_dists, install("Size"), PROTECT(ScalarInteger((int) len_indices)));
	setAttrib(R_output_dists, install("Diag"), PROTECT(ScalarLogical(0)));
	setAttrib(R_output_dists, install("Upper"), PROTECT(ScalarLogical(0)));
	setAttrib(R_output_dists, install("method"), PROTECT(mkString("distances package")));
	classgets(R_output_dists, mkString("dist"));

	SEXP R_ids = getAttrib(R_distances, install("ids"));
	if (isInteger(R_indices) || isString(R_ids)) {
		setAttrib(R_output_dists, install("Labels"), PROTECT(get_labels(R_distances, R_indices)));
		UNPROTECT(1);
	}

	UNPROTECT(6);
	return R_output_dists;
}


SEXP dist_get_dist_columns(const SEXP R_distances,
                           const SEXP R_column_indices,
                           const SEXP R_row_indices)
{
	idist_assert(idist_check_distance_object(R_distances));
	idist_assert(isInteger(R_column_indices));
	idist_assert(isNull(R_row_indices) || isInteger(R_row_indices));

	const int num_data_points = INTEGER(getAttrib(R_distances, R_DimSymbol))[1];

	SEXP R_column_indices_local = PROTECT(translate_R_index_vector(R_column_indices, num_data_points));
	const size_t len_column_indices = (size_t) xlength(R_column_indices_local);
	const int* const column_indices = INTEGER(R_column_indices_local);

	SEXP R_row_indices_local = PROTECT(translate_R_index_vector(R_row_indices, num_data_points));
	const size_t len_row_indices = isInteger(R_row_indices_local) ? (size_t) xlength(R_row_indices_local) : (size_t) num_data_points;
	const int* const row_indices = isInteger(R_row_indices_local) ? INTEGER(R_row_indices_local) : NULL;

	SEXP R_output_dists = PROTECT(allocMatrix(REALSXP, len_row_indices, len_column_indices));
	double* const output_dists = REAL(R_output_dists);

	idist_get_dist_columns(R_distances,
	                       len_column_indices,
	                       column_indices,
	                       len_row_indices,
	                       row_indices,
	                       output_dists);

	SEXP dimnames = PROTECT(allocVector(VECSXP, 2));
	SET_VECTOR_ELT(dimnames, 0, get_labels(R_distances, R_row_indices));
	SET_VECTOR_ELT(dimnames, 1, get_labels(R_distances, R_column_indices));
	setAttrib(R_output_dists, R_DimNamesSymbol, dimnames);

	UNPROTECT(4);
	return R_output_dists;
}


// `output_dists` must be of length `(len_indices - 1) len_indices / 2`
bool idist_get_dist_matrix(const SEXP R_distances,
                           const size_t len_indices,
                           const int indices[const],
                           double output_dists[])
{
	idist_assert(idist_check_distance_object(R_distances));
	idist_assert(output_dists != NULL);

	const double* const raw_data_matrix = REAL(R_distances);
	const int num_dimensions = INTEGER(getAttrib(R_distances, R_DimSymbol))[0];
	const int num_data_points = INTEGER(getAttrib(R_distances, R_DimSymbol))[1];

	if (indices == NULL) {
		for (int p1 = 0; p1 < num_data_points; ++p1) {
			for (int p2 = p1 + 1; p2 < num_data_points; ++p2) {
				*output_dists = sqrt(idist_get_sq_dist(raw_data_matrix, num_dimensions, p1, p2));
				++output_dists;
			}
		}
	} else {
		for (size_t p1 = 0; p1 < len_indices; ++p1) {
			for (size_t p2 = p1 + 1; p2 < len_indices; ++p2) {
				*output_dists = sqrt(idist_get_sq_dist(raw_data_matrix, num_dimensions, indices[p1], indices[p2]));
				++output_dists;
			}
		}
	}

	return true;
}


// `output_dists` must be of length `len_column_indices * len_row_indices`
bool idist_get_dist_columns(const SEXP R_distances,
                            const size_t len_column_indices,
                            const int column_indices[const],
                            const size_t len_row_indices,
                            const int row_indices[const],
                            double output_dists[])
{
	idist_assert(idist_check_distance_object(R_distances));
	idist_assert(len_column_indices > 0);
	idist_assert(column_indices != NULL);
	idist_assert(output_dists != NULL);

	const double* const raw_data_matrix = REAL(R_distances);
	const int num_data_points = INTEGER(getAttrib(R_distances, R_DimSymbol))[1];
	const int num_dimensions = INTEGER(getAttrib(R_distances, R_DimSymbol))[0];

	if (row_indices == NULL) {
		for (size_t c = 0; c < len_column_indices; ++c) {
			for (int r = 0; r < num_data_points; ++r) {
				*output_dists = sqrt(idist_get_sq_dist(raw_data_matrix, num_dimensions, column_indices[c], r));
				++output_dists;
			}
		}
	} else {
		for (size_t c = 0; c < len_column_indices; ++c) {
			for (size_t r = 0; r < len_row_indices; ++r) {
				*output_dists = sqrt(idist_get_sq_dist(raw_data_matrix, num_dimensions, column_indices[c], row_indices[r]));
				++output_dists;
			}
		}
	}

	return true;
}
