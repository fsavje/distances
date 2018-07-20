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
context("methods.R")


# ==============================================================================
# is.distances
# ==============================================================================

test_that("`is.distances` returns correct output", {
  expect_true(is.distances(structure(t(matrix(as.numeric(1:10), nrow = 5)),
                                     ids = NULL,
                                     normalization = diag(rep(1, 2)),
                                     weights = diag(rep(1, 2)),
                                     class = c("distances"))))
  expect_true(is.distances(structure(t(matrix(as.numeric(1:10), nrow = 5)),
                                     ids = letters[1:5],
                                     normalization = diag(rep(1, 2)),
                                     weights = diag(rep(1, 2)),
                                     class = c("distances"))))

  expect_false(is.distances(structure(t(matrix(as.numeric(1:10), nrow = 5)),
                                      ids = NULL,
                                      normalization = diag(rep(1, 2)),
                                      weights = diag(rep(1, 2)),
                                      class = c("abc"))))
  expect_false(is.distances(structure(as.numeric(1:10),
                                      ids = NULL,
                                      normalization = diag(rep(1, 2)),
                                      weights = diag(rep(1, 2)),
                                      class = c("distances"))))
  expect_false(is.distances(structure(t(matrix(letters[1:10], nrow = 5)),
                                      ids = NULL,
                                      normalization = diag(rep(1, 2)),
                                      weights = diag(rep(1, 2)),
                                      class = c("distances"))))
  expect_false(is.distances(structure(t(matrix(as.numeric(1:10), nrow = 5)),
                                      ids = 1:5,
                                      normalization = diag(rep(1, 2)),
                                      weights = diag(rep(1, 2)),
                                      class = c("distances"))))
  expect_false(is.distances(structure(t(matrix(as.numeric(1:10), nrow = 5)),
                                      ids = letters[1:4],
                                      normalization = diag(rep(1, 2)),
                                      weights = diag(rep(1, 2)),
                                      class = c("distances"))))
  expect_false(is.distances(structure(t(matrix(as.numeric(1:10), nrow = 5)),
                                      ids = NULL,
                                      normalization = NULL,
                                      weights = diag(rep(1, 2)),
                                      class = c("distances"))))
  expect_false(is.distances(structure(t(matrix(as.numeric(1:10), nrow = 5)),
                                      ids = NULL,
                                      normalization = rep(1, 2),
                                      weights = diag(rep(1, 2)),
                                      class = c("distances"))))
  expect_false(is.distances(structure(t(matrix(as.numeric(1:10), nrow = 5)),
                                      ids = NULL,
                                      normalization = matrix(letters[1:4], ncol = 2),
                                      weights = diag(rep(1, 2)),
                                      class = c("distances"))))
  expect_false(is.distances(structure(t(matrix(as.numeric(1:10), nrow = 5)),
                                      ids = NULL,
                                      normalization = diag(rep(1, 2)),
                                      weights = NULL,
                                      class = c("distances"))))
  expect_false(is.distances(structure(t(matrix(as.numeric(1:10), nrow = 5)),
                                      ids = NULL,
                                      normalization = diag(rep(1, 2)),
                                      weights = rep(1, 2),
                                      class = c("distances"))))
  expect_false(is.distances(structure(t(matrix(as.numeric(1:10), nrow = 5)),
                                      ids = NULL,
                                      normalization = diag(rep(1, 2)),
                                      weights = matrix(letters[1:4], ncol = 2),
                                      class = c("distances"))))
})


# ==============================================================================
# length.distances
# ==============================================================================

test_that("`length.distances` returns correct output", {
  expect_identical(length.distances(distances(matrix(c(0.1, 0.2, 0.3, 0.1, 0.2, 0.3), ncol = 2))),
                   3L)
  expect_identical(length.distances(distances(matrix(c(0.1, 0.2, 0.3, 0.1, 0.2, 0.3, 0.1, 0.2, 0.3, 0.3), ncol = 2))),
                   5L)
})

test_that("`length.distances` dispatches correctly", {
  expect_identical(length(distances(matrix(c(0.1, 0.2, 0.3, 0.1, 0.2, 0.3), ncol = 2))),
                   3L)
  expect_identical(length(distances(matrix(c(0.1, 0.2, 0.3, 0.1, 0.2, 0.3, 0.1, 0.2, 0.3, 0.3), ncol = 2))),
                   5L)
})


# ==============================================================================
# as.dist.distances
# ==============================================================================

test_distances <- distances(matrix(c(0.1, 0.2, 0.3, 0.1, 0.2, 0.3, 0.1, 0.2, 0.3, 0.3), ncol = 2))
ref_dist <- dist(matrix(c(0.1, 0.2, 0.3, 0.1, 0.2, 0.3, 0.1, 0.2, 0.3, 0.3), ncol = 2))
attr(ref_dist, "method") <- "distances package"
attr(ref_dist, "call") <- NULL

test_that("`as.dist.distances` returns correct output", {
  tmp_test <- as.dist.distances(test_distances)
  attr(tmp_test, "call") <- NULL
  expect_equal(tmp_test, ref_dist)
})

test_that("`as.dist.distances` dispatches correctly", {
  tmp_test <- as.dist(test_distances)
  attr(tmp_test, "call") <- NULL
  expect_equal(tmp_test, ref_dist)
})


# ==============================================================================
# [.distances
# ==============================================================================

test_distances <- distances(matrix(c(0.1, 0.2, 0.3, 0.1, 0.2, 0.3, 0.1, 0.2, 0.3, 0.3), ncol = 2))
ref_dist <- as.matrix(dist(matrix(c(0.1, 0.2, 0.3, 0.1, 0.2, 0.3, 0.1, 0.2, 0.3, 0.3), ncol = 2)))

test_that("`[.distances` returns correct output", {
  expect_equal(`[.distances`(test_distances), ref_dist)
  expect_equal(`[.distances`(test_distances), ref_dist[])
  expect_equal(`[.distances`(test_distances, drop = FALSE), ref_dist[drop = FALSE])
  expect_equal(`[.distances`(test_distances, drop = TRUE), ref_dist[drop = TRUE])

  expect_equal(`[.distances`(test_distances, 1:3), ref_dist[1:3, ])
  expect_equal(`[.distances`(test_distances, 1:3, drop = FALSE), ref_dist[1:3, , drop = FALSE])
  expect_equal(`[.distances`(test_distances, 1:3, drop = TRUE), ref_dist[1:3, , drop = TRUE])

  expect_equal(`[.distances`(test_distances, j = 4:5), ref_dist[, 4:5])
  expect_equal(`[.distances`(test_distances, j = 4:5, drop = FALSE), ref_dist[, 4:5, drop = FALSE])
  expect_equal(`[.distances`(test_distances, j = 4:5, drop = TRUE), ref_dist[, 4:5, drop = TRUE])

  expect_equal(`[.distances`(test_distances, 1:3, 4:5), ref_dist[1:3, 4:5])
  expect_equal(`[.distances`(test_distances, 1:3, 4:5, drop = FALSE), ref_dist[1:3, 4:5, drop = FALSE])
  expect_equal(`[.distances`(test_distances, 1:3, 4:5, drop = TRUE), ref_dist[1:3, 4:5, drop = TRUE])

  expect_equal(`[.distances`(test_distances, 3), ref_dist[3, ])
  expect_equal(`[.distances`(test_distances, 3, drop = FALSE), ref_dist[3, , drop = FALSE])
  expect_equal(`[.distances`(test_distances, 3, drop = TRUE), ref_dist[3, , drop = TRUE])

  expect_equal(`[.distances`(test_distances, j = 2), ref_dist[, 2])
  expect_equal(`[.distances`(test_distances, j = 2, drop = FALSE), ref_dist[, 2, drop = FALSE])
  expect_equal(`[.distances`(test_distances, j = 2, drop = TRUE), ref_dist[, 2, drop = TRUE])

  expect_equal(`[.distances`(test_distances, 1:3, 2), ref_dist[1:3, 2])
  expect_equal(`[.distances`(test_distances, 1:3, 2, drop = FALSE), ref_dist[1:3, 2, drop = FALSE])
  expect_equal(`[.distances`(test_distances, 1:3, 2, drop = TRUE), ref_dist[1:3, 2, drop = TRUE])

  expect_equal(`[.distances`(test_distances, 3, 4:5), ref_dist[3, 4:5])
  expect_equal(`[.distances`(test_distances, 3, 4:5, drop = FALSE), ref_dist[3, 4:5, drop = FALSE])
  expect_equal(`[.distances`(test_distances, 3, 4:5, drop = TRUE), ref_dist[3, 4:5, drop = TRUE])

  expect_equal(`[.distances`(test_distances, 2, 2), ref_dist[2, 2])
  expect_equal(`[.distances`(test_distances, 2, 2, drop = FALSE), ref_dist[2, 2, drop = FALSE])
  expect_equal(`[.distances`(test_distances, 2, 2, drop = TRUE), ref_dist[2, 2, drop = TRUE])

  expect_equal(`[.distances`(test_distances, 3, 5), ref_dist[3, 5])
  expect_equal(`[.distances`(test_distances, 3, 5, drop = FALSE), ref_dist[3, 5, drop = FALSE])
  expect_equal(`[.distances`(test_distances, 3, 5, drop = TRUE), ref_dist[3, 5, drop = TRUE])
})

test_that("`[.distances` dispatches correctly", {
  expect_equal(test_distances[], ref_dist)
  expect_equal(test_distances[], ref_dist[])
  expect_equal(test_distances[,], ref_dist[])
  expect_equal(test_distances[, drop = FALSE], ref_dist[drop = FALSE])
  expect_equal(test_distances[, drop = TRUE], ref_dist[drop = TRUE])

  expect_equal(test_distances[1:3, ], ref_dist[1:3, ])
  expect_equal(test_distances[1:3, , drop = FALSE], ref_dist[1:3, , drop = FALSE])
  expect_equal(test_distances[1:3, , drop = TRUE], ref_dist[1:3, , drop = TRUE])

  expect_equal(test_distances[, 4:5], ref_dist[, 4:5])
  expect_equal(test_distances[, 4:5, drop = FALSE], ref_dist[, 4:5, drop = FALSE])
  expect_equal(test_distances[, 4:5, drop = TRUE], ref_dist[, 4:5, drop = TRUE])

  expect_equal(test_distances[1:3, 4:5], ref_dist[1:3, 4:5])
  expect_equal(test_distances[1:3, 4:5, drop = FALSE], ref_dist[1:3, 4:5, drop = FALSE])
  expect_equal(test_distances[1:3, 4:5, drop = TRUE], ref_dist[1:3, 4:5, drop = TRUE])

  expect_equal(test_distances[3, ], ref_dist[3, ])
  expect_equal(test_distances[3, , drop = FALSE], ref_dist[3, , drop = FALSE])
  expect_equal(test_distances[3, , drop = TRUE], ref_dist[3, , drop = TRUE])

  expect_equal(test_distances[, 2], ref_dist[, 2])
  expect_equal(test_distances[, 2, drop = FALSE], ref_dist[, 2, drop = FALSE])
  expect_equal(test_distances[, 2, drop = TRUE], ref_dist[, 2, drop = TRUE])

  expect_equal(test_distances[1:3, 2], ref_dist[1:3, 2])
  expect_equal(test_distances[1:3, 2, drop = FALSE], ref_dist[1:3, 2, drop = FALSE])
  expect_equal(test_distances[1:3, 2, drop = TRUE], ref_dist[1:3, 2, drop = TRUE])

  expect_equal(test_distances[3, 4:5], ref_dist[3, 4:5])
  expect_equal(test_distances[3, 4:5, drop = FALSE], ref_dist[3, 4:5, drop = FALSE])
  expect_equal(test_distances[3, 4:5, drop = TRUE], ref_dist[3, 4:5, drop = TRUE])

  expect_equal(test_distances[2, 2], ref_dist[2, 2])
  expect_equal(test_distances[2, 2, drop = FALSE], ref_dist[2, 2, drop = FALSE])
  expect_equal(test_distances[2, 2, drop = TRUE], ref_dist[2, 2, drop = TRUE])

  expect_equal(test_distances[3, 5], ref_dist[3, 5])
  expect_equal(test_distances[3, 5, drop = FALSE], ref_dist[3, 5, drop = FALSE])
  expect_equal(test_distances[3, 5, drop = TRUE], ref_dist[3, 5, drop = TRUE])
})


# ==============================================================================
# as.matrix.distances
# ==============================================================================

test_that("`as.matrix.distances` returns correct output", {
  expect_equal(as.matrix.distances(distances(matrix(c(0.1, 0.2, 0.3, 0.1, 0.2, 0.3, 0.1, 0.2, 0.3, 0.3), ncol = 2))),
               as.matrix(dist(matrix(c(0.1, 0.2, 0.3, 0.1, 0.2, 0.3, 0.1, 0.2, 0.3, 0.3), ncol = 2))))
})

test_that("`as.matrix.distances` dispatches correctly", {
  expect_equal(as.matrix(distances(matrix(c(0.1, 0.2, 0.3, 0.1, 0.2, 0.3, 0.1, 0.2, 0.3, 0.3), ncol = 2))),
               as.matrix(dist(matrix(c(0.1, 0.2, 0.3, 0.1, 0.2, 0.3, 0.1, 0.2, 0.3, 0.3), ncol = 2))))
})


# ==============================================================================
# print.distances
# ==============================================================================

test_that("`print.distances` prints correctly", {
  expect_output(print.distances(distances(matrix(c(0.1, 0.2, 0.3, 0.1, 0.2, 0.3, 0.1, 0.2, 0.3, 0.3), ncol = 2))),
                "0.0000000 0.2236068 0.2236068 0.0000000 0.1000000", fixed = TRUE)
  expect_output(print.distances(distances(matrix(c(0.1, 0.2, 0.3, 0.1, 0.2, 0.3, 0.1, 0.2, 0.3, 0.3), ncol = 2))),
                "0.2236068 0.0000000 0.1414214 0.2236068 0.2000000", fixed = TRUE)
  expect_output(print.distances(distances(matrix(c(0.1, 0.2, 0.3, 0.1, 0.2, 0.3, 0.1, 0.2, 0.3, 0.3), ncol = 2))),
                "0.2236068 0.1414214 0.0000000 0.2236068 0.1414214", fixed = TRUE)
  expect_output(print.distances(distances(matrix(c(0.1, 0.2, 0.3, 0.1, 0.2, 0.3, 0.1, 0.2, 0.3, 0.3), ncol = 2))),
                "0.0000000 0.2236068 0.2236068 0.0000000 0.1000000", fixed = TRUE)
  expect_output(print.distances(distances(matrix(c(0.1, 0.2, 0.3, 0.1, 0.2, 0.3, 0.1, 0.2, 0.3, 0.3), ncol = 2))),
                "0.1000000 0.2000000 0.1414214 0.1000000 0.0000000", fixed = TRUE)

  expect_warning(
    expect_output(
      print.distances(distances(matrix(as.numeric(1:100), ncol = 2))),
      "38.98718  29.46184  19.79899", fixed = TRUE
    ),
    regexp = "contains too many data points, showing the first 20 out of the total 50."
  )
  expect_warning(
    expect_output(
      print.distances(distances(matrix(as.numeric(1:100), ncol = 2))),
      "118.27088 110.05453 101.68579", fixed = TRUE
    ),
    regexp = "contains too many data points, showing the first 20 out of the total 50."
  )
})


test_that("`print.distances` dispatches correctly", {
  expect_output(print(distances(matrix(c(0.1, 0.2, 0.3, 0.1, 0.2, 0.3, 0.1, 0.2, 0.3, 0.3), ncol = 2))),
                "0.0000000 0.2236068 0.2236068 0.0000000 0.1000000", fixed = TRUE)
  expect_output(print(distances(matrix(c(0.1, 0.2, 0.3, 0.1, 0.2, 0.3, 0.1, 0.2, 0.3, 0.3), ncol = 2))),
                "0.2236068 0.0000000 0.1414214 0.2236068 0.2000000", fixed = TRUE)
  expect_output(print(distances(matrix(c(0.1, 0.2, 0.3, 0.1, 0.2, 0.3, 0.1, 0.2, 0.3, 0.3), ncol = 2))),
                "0.2236068 0.1414214 0.0000000 0.2236068 0.1414214", fixed = TRUE)
  expect_output(print(distances(matrix(c(0.1, 0.2, 0.3, 0.1, 0.2, 0.3, 0.1, 0.2, 0.3, 0.3), ncol = 2))),
                "0.0000000 0.2236068 0.2236068 0.0000000 0.1000000", fixed = TRUE)
  expect_output(print(distances(matrix(c(0.1, 0.2, 0.3, 0.1, 0.2, 0.3, 0.1, 0.2, 0.3, 0.3), ncol = 2))),
                "0.1000000 0.2000000 0.1414214 0.1000000 0.0000000", fixed = TRUE)
})
