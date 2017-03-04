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

#include <R_ext/Rdynload.h>
#include "get_dists.h"
#include "max_dists.h"
#include "nn_search.h"
#include "utils.h"


static const R_CallMethodDef callMethods[] = {
	{"dist_check_distance_object",    (DL_FUNC) &dist_check_distance_object,    1},
	{"dist_num_data_points",          (DL_FUNC) &dist_num_data_points,          1},
	{"dist_get_dist_columns",         (DL_FUNC) &dist_get_dist_columns,         3},
	{"dist_get_dist_matrix",          (DL_FUNC) &dist_get_dist_matrix,          2},
	{"dist_max_distance_search",      (DL_FUNC) &dist_max_distance_search,      3},
	{"dist_nearest_neighbor_search",  (DL_FUNC) &dist_nearest_neighbor_search,  5},
	{NULL,                            NULL,                                     0}
};


void R_init_distances(DllInfo *info) {

	R_registerRoutines(info, NULL, callMethods, NULL, NULL);
	R_useDynamicSymbols(info, FALSE);

	// Register R level functions
	R_RegisterCCallable("distances", "dist_check_distance_object", (DL_FUNC) &dist_check_distance_object);
	R_RegisterCCallable("distances", "dist_num_data_points", (DL_FUNC) &dist_num_data_points);
	R_RegisterCCallable("distances", "dist_get_dist_matrix", (DL_FUNC) &dist_get_dist_matrix);
	R_RegisterCCallable("distances", "dist_get_dist_columns", (DL_FUNC) &dist_get_dist_columns);
	R_RegisterCCallable("distances", "dist_max_distance_search", (DL_FUNC) &dist_max_distance_search);
	R_RegisterCCallable("distances", "dist_nearest_neighbor_search", (DL_FUNC) &dist_nearest_neighbor_search);


	// Register C level functions
	R_RegisterCCallable("distances", "idist_check_distance_object", (DL_FUNC) &idist_check_distance_object);
	R_RegisterCCallable("distances", "idist_num_data_points", (DL_FUNC) &idist_num_data_points);
	R_RegisterCCallable("distances", "idist_get_dist_matrix", (DL_FUNC) &idist_get_dist_matrix);
	R_RegisterCCallable("distances", "idist_get_dist_columns", (DL_FUNC) &idist_get_dist_columns);
	R_RegisterCCallable("distances", "idist_init_max_distance_search", (DL_FUNC) &idist_init_max_distance_search);
	R_RegisterCCallable("distances", "idist_max_distance_search", (DL_FUNC) &idist_max_distance_search);
	R_RegisterCCallable("distances", "idist_close_max_distance_search", (DL_FUNC) &idist_close_max_distance_search);
	R_RegisterCCallable("distances", "idist_init_nearest_neighbor_search", (DL_FUNC) &idist_init_nearest_neighbor_search);
	R_RegisterCCallable("distances", "idist_nearest_neighbor_search", (DL_FUNC) &idist_nearest_neighbor_search);
	R_RegisterCCallable("distances", "idist_close_nearest_neighbor_search", (DL_FUNC) &idist_close_nearest_neighbor_search);
}
