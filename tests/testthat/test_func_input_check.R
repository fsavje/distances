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

library(distances)
context("Input checking in exported functions")


# ==============================================================================
# Test objects
# ==============================================================================

sound_distance_object <- distances(matrix(c(1, 4, 3, 2, 45, 6, 3, 2, 6, 5,
                                            34, 2, 4, 6, 4, 6, 4, 2, 7, 8), nrow = 10))
unsound_distance_object <- letters[1:10]

sound_data <- matrix(c(1, 4, 3, 2, 45, 6, 3, 2, 6, 5), nrow = 5)
unsound_data <- matrix(letters[1:10], nrow = 5)
sound_id_variable <- letters[1:5]
unsound_id_variable <- letters[1:3]
sound_dist_variables <- NULL
unsound_dist_variables <- dist(1:10)
sound_normalize <- "mahalanobize"
unsound_normalize <- matrix(c(-1, 2, 2, 3), ncol = 2)
sound_weights <- NULL
unsound_weights <- matrix(letters[1:4], ncol = 2)


# ==============================================================================
# distances
# ==============================================================================

test_that("`distances` checks input.", {
  expect_silent(distances(data = sound_data,
                          id_variable = sound_id_variable,
                          dist_variables = sound_dist_variables,
                          normalize = sound_normalize,
                          weights = sound_weights))
  expect_error(distances(data = unsound_data,
                         id_variable = sound_id_variable,
                         dist_variables = sound_dist_variables,
                         normalize = sound_normalize,
                         weights = sound_weights))
  expect_error(distances(data = sound_data,
                         id_variable = unsound_id_variable,
                         dist_variables = sound_dist_variables,
                         normalize = sound_normalize,
                         weights = sound_weights))
  expect_error(distances(data = sound_data,
                         id_variable = sound_id_variable,
                         dist_variables = unsound_dist_variables,
                         normalize = sound_normalize,
                         weights = sound_weights))
  expect_error(distances(data = sound_data,
                         id_variable = sound_id_variable,
                         dist_variables = sound_dist_variables,
                         normalize = unsound_normalize,
                         weights = sound_weights))
  expect_error(distances(data = sound_data,
                         id_variable = sound_id_variable,
                         dist_variables = sound_dist_variables,
                         normalize = sound_normalize,
                         weights = unsound_weights))
})


# ==============================================================================
# distances methods
# ==============================================================================

test_that("`length.distances` checks input.", {
  expect_silent(length.distances(sound_distance_object))
  expect_error(length.distances(unsound_distance_object))
})

test_that("`as.matrix.distances` checks input.", {
  expect_silent(as.matrix.distances(sound_distance_object))
  expect_error(as.matrix.distances(unsound_distance_object))
})

test_that("`print.distances` checks input.", {
  expect_output(print.distances(sound_distance_object))
  expect_error(print.distances(unsound_distance_object))
})
