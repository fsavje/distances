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


#' Distance matrix
#'
#' \code{distance_matrix} makes distance matrices (complete and partial) from
#' \code{\link{distances}} objects.
#'
#' @param distances A \code{\link{distances}} object.
#' @param indices If \code{NULL}, the complete distance matrix is made.
#'                If integer vector with point indices,
#'                a partial matrix including only the indicated data points is made.
#'
#' @return Returns a distance matrix of class \code{\link[stats]{dist}}.
#'
#' @export
distance_matrix <- function(distances,
                            indices = NULL) {
  .Call(dist_get_dist_matrix,
        distances,
        coerce_integer(indices))
}


#' Distance matrix columns
#'
#' \code{distance_columns} extracts columns from the distance matrix.
#'
#' If the complete distance matrix is desired, \code{\link{distance_matrix}} is
#' faster than \code{distance_columns}.
#'
#' @param distances A \code{\link{distances}} object.
#' @param column_indices An integer vector with point indices indicating
#'                       which columns to be extracted.
#' @param row_indices If \code{NULL}, complete rows will be extracted.
#'                    If integer vector with point indices, only the indicated
#'                    rows will be extracted.
#'
#' @return Returns a matrix with the requested columns.
#'
#' @export
distance_columns <- function(distances,
                             column_indices,
                             row_indices = NULL) {
  .Call(dist_get_dist_columns,
        distances,
        coerce_integer(column_indices),
        coerce_integer(row_indices))
}
