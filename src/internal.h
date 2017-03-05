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

#ifndef DIST_INTERNAL_HG
#define DIST_INTERNAL_HG

#include <R.h>
#include <Rinternals.h>

#define translate_R_index_vector(R_indices, upper_bound) (translate_R_index_vector__(R_indices, upper_bound, "Out of bounds: `" #R_indices "`.", __FILE__, __LINE__))

SEXP get_labels(SEXP R_distances,
                SEXP R_indices);

SEXP translate_R_index_vector__(SEXP R_indices,
                                int upper_bound,
                                const char* msg,
                                const char* file,
                                int line);

static inline double idist_get_sq_dist(const double* const raw_data_matrix,
                                       const int num_dimensions,
                                       const int index1,
                                       const int index2)
{
	const double* data1 = &raw_data_matrix[index1 * num_dimensions];
	const double* const data1_stop = data1 + num_dimensions;
	const double* data2 = &raw_data_matrix[index2 * num_dimensions];

	double tmp_dist = 0.0;
	while (data1 != data1_stop) {
		const double value_diff = (*data1 - *data2);
		tmp_dist += value_diff * value_diff;
		++data1;
		++data2;
	}
	return tmp_dist;
}

#endif // ifndef DIST_INTERNAL_HG
