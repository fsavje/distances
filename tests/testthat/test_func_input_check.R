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

sound_indices <- 1:5
unsound_indices <- letters[1:5]
out_of_bounds_indices1 <- 0:10
out_of_bounds_indices2 <- 1:11


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

test_that("`as.dist.distances` checks input.", {
  expect_silent(as.dist.distances(sound_distance_object))
  expect_error(as.dist.distances(unsound_distance_object))
})

test_that("`as.matrix.distances` checks input.", {
  expect_silent(as.matrix.distances(sound_distance_object))
  expect_error(as.matrix.distances(unsound_distance_object))
})

test_that("`print.distances` checks input.", {
  expect_output(print.distances(sound_distance_object))
  expect_error(print.distances(unsound_distance_object))
})


# ==============================================================================
# distance_matrix
# ==============================================================================

wrap_distance_matrix <- function(distances = sound_distance_object,
                                 indices = sound_indices) {
  distance_matrix(distances, indices)
}

test_that("`distance_matrix` checks input.", {
  expect_silent(wrap_distance_matrix())
  expect_error(wrap_distance_matrix(distances = unsound_distance_object))
  expect_error(wrap_distance_matrix(indices = unsound_indices))
  expect_error(wrap_distance_matrix(indices = out_of_bounds_indices1))
  expect_error(wrap_distance_matrix(indices = out_of_bounds_indices2))
})


# ==============================================================================
# distance_columns
# ==============================================================================

wrap_distance_columns <- function(distances = sound_distance_object,
                                  column_indices = sound_indices,
                                  row_indices = sound_indices) {
  distance_columns(distances, column_indices, row_indices)
}

test_that("`distance_columns` checks input.", {
  expect_silent(wrap_distance_columns())
  expect_error(wrap_distance_columns(distances = unsound_distance_object))
  expect_error(wrap_distance_columns(column_indices = NULL))
  expect_error(wrap_distance_columns(column_indices = unsound_indices))
  expect_error(wrap_distance_columns(column_indices = out_of_bounds_indices1))
  expect_error(wrap_distance_columns(column_indices = out_of_bounds_indices2))
  expect_error(wrap_distance_columns(row_indices = unsound_indices))
  expect_error(wrap_distance_columns(row_indices = out_of_bounds_indices1))
  expect_error(wrap_distance_columns(row_indices = out_of_bounds_indices2))
})


# ==============================================================================
# max_distance_search
# ==============================================================================

wrap_max_distance_search <- function(distances = sound_distance_object,
                                     query_indices = sound_indices,
                                     search_indices = sound_indices) {
  max_distance_search(distances, query_indices, search_indices)
}

test_that("`max_distance_search` checks input.", {
  expect_silent(wrap_max_distance_search())
  expect_error(wrap_max_distance_search(distances = unsound_distance_object))
  expect_error(wrap_max_distance_search(query_indices = unsound_indices))
  expect_error(wrap_max_distance_search(query_indices = out_of_bounds_indices1))
  expect_error(wrap_max_distance_search(query_indices = out_of_bounds_indices2))
  expect_error(wrap_max_distance_search(search_indices = unsound_indices))
  expect_error(wrap_max_distance_search(search_indices = out_of_bounds_indices1))
  expect_error(wrap_max_distance_search(search_indices = out_of_bounds_indices2))
})

# ==============================================================================
# nearest_neighbor_search
# ==============================================================================

wrap_nearest_neighbor_search <- function(distances = sound_distance_object,
                                         k = 2L,
                                         query_indices = sound_indices,
                                         search_indices = sound_indices,
                                         radius = 1) {
  nearest_neighbor_search(distances, k, query_indices, search_indices, radius)
}

test_that("`nearest_neighbor_search` checks input.", {
  expect_silent(wrap_nearest_neighbor_search())
  expect_error(wrap_nearest_neighbor_search(distances = unsound_distance_object))
  expect_error(wrap_nearest_neighbor_search(k = "a"))
  expect_error(wrap_nearest_neighbor_search(query_indices = unsound_indices))
  expect_error(wrap_nearest_neighbor_search(query_indices = out_of_bounds_indices1))
  expect_error(wrap_nearest_neighbor_search(query_indices = out_of_bounds_indices2))
  expect_error(wrap_nearest_neighbor_search(search_indices = unsound_indices))
  expect_error(wrap_nearest_neighbor_search(search_indices = out_of_bounds_indices1))
  expect_error(wrap_nearest_neighbor_search(search_indices = out_of_bounds_indices2))
  expect_error(wrap_nearest_neighbor_search(radius = "1"))
  expect_error(wrap_nearest_neighbor_search(radius = -2))
})
