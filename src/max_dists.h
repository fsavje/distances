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

#ifndef DIST_MAX_DIST_HG
#define DIST_MAX_DIST_HG

#include <stdbool.h>
#include <stddef.h>
#include <R.h>
#include <Rinternals.h>

typedef struct idist_MaxSearch idist_MaxSearch;

SEXP dist_max_distance_search(SEXP R_distances,
                              SEXP R_query_indices,
                              SEXP R_search_indices);

bool idist_init_max_distance_search(SEXP R_distances,
                                    size_t len_search_indices,
                                    const int search_indices[],
                                    idist_MaxSearch** out_max_dist_object);

bool idist_max_distance_search(idist_MaxSearch* max_dist_object,
                               size_t len_query_indices,
                               const int query_indices[],
                               int out_max_indices[],
                               double out_max_dists[]);

bool idist_close_max_distance_search(idist_MaxSearch** out_max_dist_object);

#endif // ifndef DIST_MAX_DIST_HG
