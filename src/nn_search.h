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

#ifndef DIST_NN_SEARCH_HG
#define DIST_NN_SEARCH_HG

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <R.h>
#include <Rinternals.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct idist_NNSearch idist_NNSearch;

SEXP dist_nearest_neighbor_search(SEXP R_distances,
                                  SEXP R_k,
                                  SEXP R_query_indices,
                                  SEXP R_search_indices,
                                  SEXP R_radius);

bool idist_init_nearest_neighbor_search(SEXP R_distances,
                                        size_t len_search_indices,
                                        const int search_indices[],
                                        idist_NNSearch** out_nn_search_object);

bool idist_nearest_neighbor_search(idist_NNSearch* nn_search_object,
                                   size_t len_query_indices,
                                   const int query_indices[],
                                   uint32_t k,
                                   bool radius_search,
                                   double radius,
                                   size_t* out_num_ok_queries,
                                   int out_query_indices[],
                                   int out_nn_indices[]);

bool idist_close_nearest_neighbor_search(idist_NNSearch** out_nn_search_object);

#ifdef __cplusplus
}
#endif

#endif // ifndef DIST_NN_SEARCH_HG
