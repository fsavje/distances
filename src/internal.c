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

#include "internal.h"
#include <stddef.h>
#include <stdio.h>
#include <R.h>
#include <Rinternals.h>
#include "error.h"


SEXP get_labels(const SEXP R_distances,
                const SEXP R_indices) {

	SEXP R_ids = getAttrib(R_distances, install("ids"));
	const int num_data_points = INTEGER(getAttrib(R_distances, R_DimSymbol))[1];

	SEXP out_labels;
	if (isInteger(R_indices)) {
		const size_t len_indices = (size_t) xlength(R_indices);
		const int* const indices = INTEGER(R_indices);
		out_labels = PROTECT(allocVector(STRSXP, (R_xlen_t) len_indices));

		if (isString(R_ids)) {
			for (size_t p = 0; p < len_indices; ++p) {
				SET_STRING_ELT(out_labels, p, STRING_ELT(R_ids, indices[p] - 1));
			}
		} else {
			idist_assert(isNull(R_ids));
			char tmp_str[255];
			for (size_t p = 0; p < len_indices; ++p) {
				snprintf(tmp_str, 255, "%d", indices[p]);
				SET_STRING_ELT(out_labels, p, mkChar(tmp_str));
			}
		}

	} else {
		idist_assert(isNull(R_indices));
		if (isString(R_ids)) {
			out_labels = PROTECT(R_ids);
		} else {
			idist_assert(isNull(R_ids));
			out_labels = PROTECT(allocVector(STRSXP, (R_xlen_t) num_data_points));
			char tmp_str[255];
			for (int p = 0; p < num_data_points; ++p) {
				snprintf(tmp_str, 255, "%d", p + 1);
				SET_STRING_ELT(out_labels, p, mkChar(tmp_str));
			}
		}
	}

	UNPROTECT(1);
	return out_labels;
}


SEXP translate_R_index_vector__(const SEXP R_indices,
                                const int upper_bound,
                                const char* const msg,
                                const char* const file,
                                const int line)
{
	SEXP R_indices_local = PROTECT(duplicate(R_indices));
	if (isInteger(R_indices_local)) {
		int out_of_bounds = 0;
		const int* const i_stop = INTEGER(R_indices_local) + xlength(R_indices_local);
		for (int* i = INTEGER(R_indices_local); i != i_stop; ++i) {
			--(*i);
			out_of_bounds += (*i < 0) + (*i >= upper_bound);
		}
		if (out_of_bounds != 0) {
			idist_error__(msg, file, line);
		}
	}
	UNPROTECT(1);
	return R_indices_local;
}
