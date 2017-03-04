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

#' Max distance search
#'
#' \code{max_distance_search} searches for the data point furthest from a set of
#' query points.
#'
#' @param distances A \code{\link{distances}} object.
#' @param query_indices An integer vector with point indices to query. If \code{NULL},
#'                      all data points in \code{distances} are queried.
#' @param search_indices An integer vector with point indices to search among. If \code{NULL},
#'                       all data points in \code{distances} are searched over.
#'
#' @return An integer vector with point indices for the data point furthest from each query.
#'
#' @export
max_distance_search <- function(distances,
                                query_indices = NULL,
                                search_indices = NULL) {
  .Call(dist_max_distance_search,
        distances,
        coerce_integer(query_indices),
        coerce_integer(search_indices))
}


#' Nearest neighbor search
#'
#' \code{nearest_neighbor_search} searches for the k nearest neighbors of a set of
#' query points.
#'
#' @param distances A \code{\link{distances}} object.
#' @param k The number of neighbors to search for.
#' @param query_indices An integer vector with point indices to query. If \code{NULL},
#'                      all data points in \code{distances} are queried.
#' @param search_indices An integer vector with point indices to search among. If \code{NULL},
#'                       all data points in \code{distances} are searched over.
#' @param radius Restrict the search to a fixed radius around each query. If fewer than \code{k}
#'               search points exist within this radius, no neighbors are reported (indicated by \code{NA}).
#'
#' @return A matrix with point indices for the nearest neighbors. Columns in this matrix indicate
#'         queries, and rows are ordered by distances from the query.
#'
#' @export
nearest_neighbor_search <- function(distances,
                                    k,
                                    query_indices = NULL,
                                    search_indices = NULL,
                                    radius = NULL) {
  .Call(dist_nearest_neighbor_search,
        distances,
        coerce_integer(k),
        coerce_integer(query_indices),
        coerce_integer(search_indices),
        coerce_double(radius))
}
