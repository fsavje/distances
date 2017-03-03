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


#' @export
length.distances <- function(x) {
  ensure_distances(x)
  c_num_data_points(x)
}

#' @importFrom stats as.dist
#' @export
as.dist.distances <- function(m, diag = FALSE, upper = FALSE) {
  ensure_distances(m)
  ans <- distance_matrix(m)
  attributes(ans) <- NULL
  if (!is.null(attr(m, "ids", exact = TRUE))) {
    attr(ans, "Labels") <- attr(m, "ids", exact = TRUE)
  }
  attr(ans, "Size") <- length(m)
  attr(ans, "Diag") <- diag
  attr(ans, "Upper") <- upper
  attr(ans, "method") <- "distances package"
  attr(ans, "call") <- match.call()
  class(ans) <- "dist"
  ans
}


#' @export
as.matrix.distances <- function(x, ...) {
  as.matrix(as.dist.distances(x))
}


#' @export
print.distances <- function(x, ...) {
  x <- coerce_printable_distances(x)
  print(as.matrix.distances(x))
}
