# ==============================================================================
# distances -- R package with tools for distance metrics
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


#' distances: Tools for Distance Metrics
#'
#' The \code{distances} package provides tools for constructing, manipulating
#' and using distance metrics in R. It calculates distances only as needed
#' (unlike the standard \code{\link[stats]{dist}} function which derives the
#' complete distance matrix when called). This saves memory and can increase
#' speed. The package also includes functions for fast nearest and farthest
#' neighbor searching.
#'
#' See the package's website for more information:
#' \url{https://github.com/fsavje/distances}.
#'
#' Bug reports and suggestions are greatly appreciated. They
#' are best reported here:
#' \url{https://github.com/fsavje/distances/issues/new}.
#'
#' @docType package
#' @name distances-package
NULL

#' @useDynLib distances, .registration = TRUE
.onUnload <- function (libpath) {
  library.dynam.unload("distances", libpath)
}
