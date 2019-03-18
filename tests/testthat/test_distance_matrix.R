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
context("distance_matrix.R")


my_data_points <- data.frame(x = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10),
                             y = c(10, 9, 8, 7, 6, 6, 7, 8, 9, 10))
my_distances <- distances(my_data_points)
my_distances_withID <- distances(data.frame(my_data_points, my_ids = letters[1:10]),
                                 id_variable = "my_ids")
my_data_points_matrix <- as.matrix(my_data_points)
my_dist <- dist(my_data_points_matrix)
dimnames(my_data_points_matrix)[[1]] <- letters[1:10]
my_dist_withID <- dist(my_data_points_matrix)

my_data_points_log <- data.frame(x = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10),
                                 y = rep(c(TRUE, FALSE), 5))
my_distances_log <- distances(my_data_points_log)
my_dist_log <- dist(my_data_points_log)

# ==============================================================================
# distance_matrix
# ==============================================================================

replica_distance_matrix <- function(x,
                                    indices = NULL) {
  if (!is.null(indices)) {
    x <- as.dist(as.matrix(x)[indices, indices])
  }
  attr(x, "method") <- "distances package"
  attr(x, "call") <- NULL
  x
}

test_that("`distance_matrix` returns correct output", {
  expect_identical(distance_matrix(my_distances), replica_distance_matrix(my_dist))
  expect_identical(distance_matrix(my_distances_log), replica_distance_matrix(my_dist_log))
  expect_identical(distance_matrix(my_distances, indices = 1:10), replica_distance_matrix(my_dist, indices = 1:10))
  expect_identical(distance_matrix(my_distances, indices = 4:8), replica_distance_matrix(my_dist, indices = 4:8))
  expect_identical(distance_matrix(my_distances_withID), replica_distance_matrix(my_dist_withID))
  expect_identical(distance_matrix(my_distances_withID, indices = 1:10), replica_distance_matrix(my_dist_withID, indices = 1:10))
  expect_identical(distance_matrix(my_distances_withID, indices = 4:8), replica_distance_matrix(my_dist_withID, indices = 4:8))
})


# ==============================================================================
# distance_columns
# ==============================================================================

replica_distance_columns <- function(x,
                                     column_indices,
                                     row_indices = NULL) {
  if (is.null(row_indices)) row_indices <- 1:attr(x, "Size")
  as.matrix(x)[row_indices, column_indices]
}

test_that("`distance_columns` returns correct output", {
  expect_identical(distance_columns(my_distances, 1:10), replica_distance_columns(my_dist, 1:10))
  expect_identical(distance_columns(my_distances, 4:8), replica_distance_columns(my_dist, 4:8))
  expect_identical(distance_columns(my_distances_withID, 1:10), replica_distance_columns(my_dist_withID, 1:10))
  expect_identical(distance_columns(my_distances_withID, 4:8), replica_distance_columns(my_dist_withID, 4:8))
  expect_identical(distance_columns(my_distances, 1:10, 1:10), replica_distance_columns(my_dist, 1:10, 1:10))
  expect_identical(distance_columns(my_distances, 4:8, 1:10), replica_distance_columns(my_dist, 4:8, 1:10))
  expect_identical(distance_columns(my_distances_withID, 1:10, 1:10), replica_distance_columns(my_dist_withID, 1:10, 1:10))
  expect_identical(distance_columns(my_distances_withID, 4:8, 1:10), replica_distance_columns(my_dist_withID, 4:8, 1:10))
  expect_identical(distance_columns(my_distances, 1:10, 1:7), replica_distance_columns(my_dist, 1:10, 1:7))
  expect_identical(distance_columns(my_distances, 4:8, 1:7), replica_distance_columns(my_dist, 4:8, 1:7))
  expect_identical(distance_columns(my_distances_withID, 1:10, 1:7), replica_distance_columns(my_dist_withID, 1:10, 1:7))
  expect_identical(distance_columns(my_distances_withID, 4:8, 1:7), replica_distance_columns(my_dist_withID, 4:8, 1:7))
})
