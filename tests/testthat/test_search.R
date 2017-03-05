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
context("search.R")


my_data_points <- data.frame(x = c(-0.337583089273209, -1.37648631398233, 1.20172247127349, -1.14105566632672, 0.896351538950015, -1.65678250088529, -0.702935129174973, 0.436019296689133, 0.946791912272624, -0.16316317143057),
                             y = c(-1.36917010106676, -0.448426125058238, 0.607836056473607, -0.146778291857306, -0.360125338032073, -0.37738942655005, 0.43107849723969, -2.02715324025675, 1.12082703897338, 0.788935416029541))
my_distances <- distances(my_data_points)
my_distances_withID <- distances(data.frame(my_data_points, my_ids = letters[1:10]),
                                 id_variable = "my_ids")


# ==============================================================================
# max_distance_search
# ==============================================================================

replica_max_distance_search <- function(distances,
                                        query_indices = NULL,
                                        search_indices = NULL) {
  if (is.null(query_indices)) query_indices <- 1:length(distances)
  if (is.null(search_indices)) search_indices <- 1:length(distances)

  apply(as.matrix(distances)[query_indices, search_indices],
        1, function(x) { search_indices[rev(order(x))[1]] })
}

test_that("`max_distance_search` returns correct output", {
  expect_identical(max_distance_search(my_distances),
                   replica_max_distance_search(my_distances))
  expect_identical(max_distance_search(my_distances, 1:10),
                   replica_max_distance_search(my_distances, 1:10))
  expect_identical(max_distance_search(my_distances, 4:8),
                   replica_max_distance_search(my_distances, 4:8))
  expect_identical(max_distance_search(my_distances, NULL, 1:10),
                   replica_max_distance_search(my_distances, NULL, 1:10))
  expect_identical(max_distance_search(my_distances, NULL, 4:8),
                   replica_max_distance_search(my_distances, NULL, 4:8))
  expect_identical(max_distance_search(my_distances_withID),
                   replica_max_distance_search(my_distances_withID))
  expect_identical(max_distance_search(my_distances_withID, 1:10),
                   replica_max_distance_search(my_distances_withID, 1:10))
  expect_identical(max_distance_search(my_distances_withID, 4:8),
                   replica_max_distance_search(my_distances_withID, 4:8))
  expect_identical(max_distance_search(my_distances_withID, NULL, 1:10),
                   replica_max_distance_search(my_distances_withID, NULL, 1:10))
  expect_identical(max_distance_search(my_distances_withID, NULL, 4:8),
                   replica_max_distance_search(my_distances_withID, NULL, 4:8))
  expect_identical(max_distance_search(my_distances, 1:10, 1:10),
                   replica_max_distance_search(my_distances, 1:10, 1:10))
  expect_identical(max_distance_search(my_distances, 4:8, 1:10),
                   replica_max_distance_search(my_distances, 4:8, 1:10))
  expect_identical(max_distance_search(my_distances_withID, 1:10, 1:10),
                   replica_max_distance_search(my_distances_withID, 1:10, 1:10))
  expect_identical(max_distance_search(my_distances_withID, 4:8, 1:10),
                   replica_max_distance_search(my_distances_withID, 4:8, 1:10))
  expect_identical(max_distance_search(my_distances, 1:10, 1:7),
                   replica_max_distance_search(my_distances, 1:10, 1:7))
  expect_identical(max_distance_search(my_distances, 4:8, 1:7),
                   replica_max_distance_search(my_distances, 4:8, 1:7))
  expect_identical(max_distance_search(my_distances_withID, 1:10, 1:7),
                   replica_max_distance_search(my_distances_withID, 1:10, 1:7))
  expect_identical(max_distance_search(my_distances_withID, 4:8, 1:7),
                   replica_max_distance_search(my_distances_withID, 4:8, 1:7))
})


# ==============================================================================
# nearest_neighbor_search
# ==============================================================================

replica_nearest_neighbor_search <- function(distances,
                                            k,
                                            query_indices = NULL,
                                            search_indices = NULL,
                                            radius = NULL) {
  if (is.null(query_indices)) query_indices <- 1:length(distances)
  if (is.null(search_indices)) search_indices <- 1:length(distances)

  ans <- apply(as.matrix(distances)[query_indices, search_indices],
               1, function(x) {
                 if (is.null(radius) || x[order(x)[k]] <= radius) { search_indices[order(x)[1:k]] } else { rep(NA, k) }
               })

  if (!is.matrix(ans)) ans <- matrix(ans, ncol = length(ans), dimnames = list(NULL, names(ans)))
  ans
}

test_that("`nearest_neighbor_search` returns correct output", {
  expect_identical(nearest_neighbor_search(my_distances, 1L),
                   replica_nearest_neighbor_search(my_distances, 1L))
  expect_identical(nearest_neighbor_search(my_distances, 3L, 1:10),
                   replica_nearest_neighbor_search(my_distances, 3L, 1:10))
  expect_identical(nearest_neighbor_search(my_distances, 2L, 4:8),
                   replica_nearest_neighbor_search(my_distances, 2L, 4:8))
  expect_identical(nearest_neighbor_search(my_distances, 3L, NULL, 1:10),
                   replica_nearest_neighbor_search(my_distances, 3L, NULL, 1:10))
  expect_identical(nearest_neighbor_search(my_distances, 2L, NULL, 4:8),
                   replica_nearest_neighbor_search(my_distances, 2L, NULL, 4:8))
  expect_identical(nearest_neighbor_search(my_distances_withID, 1L),
                   replica_nearest_neighbor_search(my_distances_withID, 1L))
  expect_identical(nearest_neighbor_search(my_distances_withID, 3L, 1:10),
                   replica_nearest_neighbor_search(my_distances_withID, 3L, 1:10))
  expect_identical(nearest_neighbor_search(my_distances_withID, 2L, 4:8),
                   replica_nearest_neighbor_search(my_distances_withID, 2L, 4:8))
  expect_identical(nearest_neighbor_search(my_distances_withID, 3L, NULL, 1:10),
                   replica_nearest_neighbor_search(my_distances_withID, 3L, NULL, 1:10))
  expect_identical(nearest_neighbor_search(my_distances_withID, 1L, NULL, 4:8),
                   replica_nearest_neighbor_search(my_distances_withID, 1L, NULL, 4:8))
  expect_identical(nearest_neighbor_search(my_distances, 3L, 1:10, 1:10),
                   replica_nearest_neighbor_search(my_distances, 3L, 1:10, 1:10))
  expect_identical(nearest_neighbor_search(my_distances, 3L, 4:8, 1:10),
                   replica_nearest_neighbor_search(my_distances, 3L, 4:8, 1:10))
  expect_identical(nearest_neighbor_search(my_distances_withID, 3L, 1:10, 1:10),
                   replica_nearest_neighbor_search(my_distances_withID, 3L, 1:10, 1:10))
  expect_identical(nearest_neighbor_search(my_distances_withID, 1L, 4:8, 1:10),
                   replica_nearest_neighbor_search(my_distances_withID, 1L, 4:8, 1:10))
  expect_identical(nearest_neighbor_search(my_distances, 3L, 1:10, 1:7),
                   replica_nearest_neighbor_search(my_distances, 3L, 1:10, 1:7))
  expect_identical(nearest_neighbor_search(my_distances, 2L, 4:8, 1:7),
                   replica_nearest_neighbor_search(my_distances, 2L, 4:8, 1:7))
  expect_identical(nearest_neighbor_search(my_distances_withID, 2L, 1:10, 1:7),
                   replica_nearest_neighbor_search(my_distances_withID, 2L, 1:10, 1:7))
  expect_identical(nearest_neighbor_search(my_distances_withID, 3L, 4:8, 1:7),
                   replica_nearest_neighbor_search(my_distances_withID, 3L, 4:8, 1:7))

  expect_identical(nearest_neighbor_search(my_distances, 1L, radius = 1),
                   replica_nearest_neighbor_search(my_distances, 1L, radius = 1))
  expect_identical(nearest_neighbor_search(my_distances, 3L, 1:10, radius = 1),
                   replica_nearest_neighbor_search(my_distances, 3L, 1:10, radius = 1))
  expect_identical(nearest_neighbor_search(my_distances, 2L, 4:8, radius = 1),
                   replica_nearest_neighbor_search(my_distances, 2L, 4:8, radius = 1))
  expect_identical(nearest_neighbor_search(my_distances, 3L, NULL, 1:10, radius = 1),
                   replica_nearest_neighbor_search(my_distances, 3L, NULL, 1:10, radius = 1))
  expect_identical(nearest_neighbor_search(my_distances, 2L, NULL, 4:8, radius = 1),
                   replica_nearest_neighbor_search(my_distances, 2L, NULL, 4:8, radius = 1))
  expect_identical(nearest_neighbor_search(my_distances_withID, 1L, radius = 1),
                   replica_nearest_neighbor_search(my_distances_withID, 1L, radius = 1))
  expect_identical(nearest_neighbor_search(my_distances_withID, 3L, 1:10, radius = 1),
                   replica_nearest_neighbor_search(my_distances_withID, 3L, 1:10, radius = 1))
  expect_identical(nearest_neighbor_search(my_distances_withID, 2L, 4:8, radius = 1),
                   replica_nearest_neighbor_search(my_distances_withID, 2L, 4:8, radius = 1))
  expect_identical(nearest_neighbor_search(my_distances_withID, 3L, NULL, 1:10, radius = 1),
                   replica_nearest_neighbor_search(my_distances_withID, 3L, NULL, 1:10, radius = 1))
  expect_identical(nearest_neighbor_search(my_distances_withID, 1L, NULL, 4:8, radius = 1),
                   replica_nearest_neighbor_search(my_distances_withID, 1L, NULL, 4:8, radius = 1))
  expect_identical(nearest_neighbor_search(my_distances, 3L, 1:10, 1:10, radius = 1),
                   replica_nearest_neighbor_search(my_distances, 3L, 1:10, 1:10, radius = 1))
  expect_identical(nearest_neighbor_search(my_distances, 3L, 4:8, 1:10, radius = 1),
                   replica_nearest_neighbor_search(my_distances, 3L, 4:8, 1:10, radius = 1))
  expect_identical(nearest_neighbor_search(my_distances_withID, 3L, 1:10, 1:10, radius = 1),
                   replica_nearest_neighbor_search(my_distances_withID, 3L, 1:10, 1:10, radius = 1))
  expect_identical(nearest_neighbor_search(my_distances_withID, 1L, 4:8, 1:10, radius = 1),
                   replica_nearest_neighbor_search(my_distances_withID, 1L, 4:8, 1:10, radius = 1))
  expect_identical(nearest_neighbor_search(my_distances, 3L, 1:10, 1:7, radius = 1),
                   replica_nearest_neighbor_search(my_distances, 3L, 1:10, 1:7, radius = 1))
  expect_identical(nearest_neighbor_search(my_distances, 2L, 4:8, 1:7, radius = 1),
                   replica_nearest_neighbor_search(my_distances, 2L, 4:8, 1:7, radius = 1))
  expect_identical(nearest_neighbor_search(my_distances_withID, 2L, 1:10, 1:7, radius = 1),
                   replica_nearest_neighbor_search(my_distances_withID, 2L, 1:10, 1:7, radius = 1))
  expect_identical(nearest_neighbor_search(my_distances_withID, 3L, 4:8, 1:7, radius = 1),
                   replica_nearest_neighbor_search(my_distances_withID, 3L, 4:8, 1:7, radius = 1))
})
