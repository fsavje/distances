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


#' Check \code{distances} object
#'
#' \code{is.distances} checks whether the provided object
#' is a valid instance of the \code{\link{distances}} class.
#'
#' @param x  object to check.
#'
#' @return Returns \code{TRUE} if \code{x} is a valid
#'         \code{distances} object, otherwise \code{FALSE}.
#'
#' @export
is.distances <- function(x) {
  .Call(dist_check_distance_object,
        x)
}


#' @export
length.distances <- function(x) {
  .Call(dist_num_data_points,
        x)
}


#' @importFrom stats as.dist
#' @export
as.dist.distances <- function(m, diag = FALSE, upper = FALSE) {
  ans <- distance_matrix(m)
  if (!missing(diag)) attr(ans, "Diag") <- diag
  if (!missing(upper)) attr(ans, "Upper") <- upper
  attr(ans, "call") <- match.call()
  ans
}


#' @export
as.matrix.distances <- function(x, ...) {
  as.matrix(as.dist.distances(x))
}


#' @export
print.distances <- function(x, ...) {
  ensure_distances(x)
  if (length(x) > 20L) {
    warning("`", match.call()$x, "` contains too many data points, showing the first 20 out of the total ", ncol(x), ".")
    x <- distances(t(x[, 1:20]), id_variable = attr(x, "ids", exact = TRUE)[1:20])
  }
  print(as.matrix.distances(x))
}
