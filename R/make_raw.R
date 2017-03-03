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


#' @useDynLib distances dist_get_dist_matrix
#' @export
get_dist_matrix <- function(distances,
                            point_indices = NULL) {
  .Call(dist_get_dist_matrix,
        distances,
        point_indices)
}


#' @useDynLib distances dist_get_dist_rows
#' @export
get_dist_rows <- function(distances,
                          row_indices,
                          column_indices = NULL) {
  .Call(dist_get_dist_rows,
        distances,
        row_indices,
        column_indices)
}
