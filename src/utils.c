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

#include "utils.h"
#include <stdbool.h>
#include <string.h>
#include <R.h>
#include <Rinternals.h>
#include "error.h"


SEXP dist_check_distance_object(const SEXP R_distances)
{
	return ScalarLogical((int) idist_check_distance_object(R_distances));
}


SEXP dist_num_data_points(const SEXP R_distances)
{
	idist_assert(idist_check_distance_object(R_distances));
	return ScalarInteger(idist_num_data_points(R_distances));
}


bool idist_check_distance_object(const SEXP R_distances)
{
	SEXP R_class = getAttrib(R_distances, R_ClassSymbol);
	SEXP R_ids = getAttrib(R_distances, install("ids"));
	SEXP R_normalization = getAttrib(R_distances, install("normalization"));
	SEXP R_weights = getAttrib(R_distances, install("weights"));

	return isString(R_class) &&
		(strcmp(CHAR(asChar(R_class)), "distances") == 0) &&
		isMatrix(R_distances) &&
		isReal(R_distances) &&
		(isNull(R_ids) ||
			(isString(R_ids) && ((int) xlength(R_ids) == INTEGER(getAttrib(R_distances, R_DimSymbol))[1]))) &&
		isMatrix(R_normalization) &&
		isReal(R_normalization) &&
		isMatrix(R_weights) &&
		isReal(R_weights);
}


int idist_num_data_points(const SEXP R_distances)
{
	idist_assert(idist_check_distance_object(R_distances));
	return INTEGER(getAttrib(R_distances, R_DimSymbol))[1];
}
