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

#ifndef DIST_GET_DISTS_HG
#define DIST_GET_DISTS_HG

#include <stdbool.h>
#include <stddef.h>
#include <R.h>
#include <Rinternals.h>

SEXP dist_get_dist_matrix(SEXP R_distances,
                          SEXP R_indices);

SEXP dist_get_dist_columns(SEXP R_distances,
                           SEXP R_column_indices,
                           SEXP R_row_indices);

bool idist_get_dist_matrix(SEXP R_distances,
                           size_t len_indices,
                           const int indices[],
                           double output_dists[]);

bool idist_get_dist_columns(SEXP R_distances,
                            size_t len_column_indices,
                            const int column_indices[],
                            size_t len_row_indices,
                            const int row_indices[],
                            double output_dists[]);

#endif // ifndef DIST_GET_DISTS_HG
