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


#' distances: Distance metric tools for R
#'
#' Tools for distances and metrics.
#'
#' This package is under development, please exercise caution when using it.
#'
#' More information and the latest version is found here:
#' \url{https://github.com/fsavje/distances}.
#'
#' Bug reports and suggestions are greatly appreciated. They
#' are best reported here:
#' \url{https://github.com/fsavje/distances/issues}.
#'
#' @docType package
#' @name distances-package
NULL

.onAttach <- function(libname, pkgname) {
  packageStartupMessage("The `distances` package is under development. Please exercise caution when using it.")
  packageStartupMessage("Bug reports and suggestions are greatly appreciated. They are best reported here: https://github.com/fsavje/distances/issues")
}
