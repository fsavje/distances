# ==============================================================================
# distances -- Distance metric tools for R
# https://github.com/fsavje/distances
#
# Copyright (C) 2017  Fredrik Savje -- http://fredriksavje.com
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see http://www.gnu.org/licenses/
# ==============================================================================

#' Nearest neighbor search
#'
#' Nearest neighbor search
#'
#' @param distances ...
#' @param k ...
#' @param query_indices ...
#' @param search_indices ...
#' @param radius ...
#'
#' @return ...
#'
#' @useDynLib distances dist_nearest_neighbor_search
#' @export
nearest_neighbor_search <- function(distances,
                                    k,
                                    query_indices = NULL,
                                    search_indices = NULL,
                                    radius = NULL) {
  .Call(dist_nearest_neighbor_search,
        distances,
        k,
        query_indices,
        search_indices,
        radius)
}


#' Max distance search
#'
#' Max distance search
#'
#' @param distances ...
#' @param query_indices ...
#' @param search_indices ...
#'
#' @return ...
#'
#' @useDynLib distances dist_max_distance_search
#' @export
max_distance_search <- function(distances,
                                query_indices = NULL,
                                search_indices = NULL) {
  .Call(dist_max_distance_search,
        distances,
        query_indices,
        search_indices)
}
