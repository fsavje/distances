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

#ifndef DISTANCES_API_HG
#define DISTANCES_API_HG

#include <R_ext/Rdynload.h>

#ifdef __cplusplus
extern "C" {
#endif

/* =============================================================================
 * The API is not stable. Expect changes!
 * ========================================================================== */

static SEXP dist_check_distance_object(SEXP R_distances)
{
	static SEXP(*func)(SEXP) = NULL;
	if (func == NULL) {
		func = (SEXP(*)(SEXP)) R_GetCCallable("distances", "dist_check_distance_object");
	}
	return func(R_distances);
}


static SEXP dist_num_data_points(SEXP R_distances)
{
	static SEXP(*func)(SEXP) = NULL;
	if (func == NULL) {
		func = (SEXP(*)(SEXP)) R_GetCCallable("distances", "dist_num_data_points");
	}
	return func(R_distances);
}


static SEXP dist_get_dist_matrix(SEXP R_distances,
                                 SEXP R_indices)
{
	static SEXP(*func)(SEXP, SEXP) = NULL;
	if (func == NULL) {
		func = (SEXP(*)(SEXP, SEXP)) R_GetCCallable("distances", "dist_get_dist_matrix");
	}
	return func(R_distances, R_indices);
}


static SEXP dist_get_dist_columns(SEXP R_distances,
                                  SEXP R_column_indices,
                                  SEXP R_row_indices)
{
	static SEXP(*func)(SEXP, SEXP, SEXP) = NULL;
	if (func == NULL) {
		func = (SEXP(*)(SEXP, SEXP, SEXP)) R_GetCCallable("distances", "dist_get_dist_columns");
	}
	return func(R_distances, R_column_indices, R_row_indices);
}


static SEXP dist_max_distance_search(SEXP R_distances,
                                     SEXP R_query_indices,
                                     SEXP R_search_indices)
{
	static SEXP(*func)(SEXP, SEXP, SEXP) = NULL;
	if (func == NULL) {
		func = (SEXP(*)(SEXP, SEXP, SEXP)) R_GetCCallable("distances", "dist_max_distance_search");
	}
	return func(R_distances, R_query_indices, R_search_indices);
}


static SEXP dist_nearest_neighbor_search(SEXP R_distances,
                                         SEXP R_k,
                                         SEXP R_query_indices,
                                         SEXP R_search_indices,
                                         SEXP R_radius)
{
	static SEXP(*func)(SEXP, SEXP, SEXP, SEXP, SEXP) = NULL;
	if (func == NULL) {
		func = (SEXP(*)(SEXP, SEXP, SEXP, SEXP, SEXP)) R_GetCCallable("distances", "dist_nearest_neighbor_search");
	}
	return func(R_distances, R_k, R_query_indices, R_search_indices, R_radius);
}


#ifdef __cplusplus
}
#endif

#endif // ifndef DISTANCES_API_HG
