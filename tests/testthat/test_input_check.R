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
context("Input checking in R code")


# ==============================================================================
# new_error & new_warning
# ==============================================================================

t_new_error <- function(...) {
  temp_func <- function(...) {
    new_error(...)
  }
  temp_func(...)
}

t_new_warning <- function(...) {
  temp_func <- function(...) {
    new_warning(...)
  }
  temp_func(...)
}


test_that("`new_error` & `new_warning` make warnings and errors.", {
  expect_error(t_new_error("This is an error."),
               regexp = "This is an error.")
  expect_error(t_new_error("This is", " also ", "an error."),
               regexp = "This is also an error.")
  expect_warning(t_new_warning("This is a warning."),
                 regexp = "This is a warning.")
  expect_warning(t_new_warning("This is", " also ", "a warning."),
                 regexp = "This is also a warning.")
})


# ==============================================================================
# ensure_distances
# ==============================================================================

t_ensure_distances <- function(t_distances = distances(matrix(1:10, nrow = 5))) {
  ensure_distances(t_distances)
}

test_that("`ensure_distances` checks input.", {
  expect_silent(t_ensure_distances())
  expect_error(t_ensure_distances(t_distances = "a"),
               regexp = "`t_distances` is not a `distances` object.")
})


# ==============================================================================
# coerce_args
# ==============================================================================

t_coerce_args <- function(t_arg = "abc",
                          t_choices = c("abcdef", "123456", "xzy", "amb")) {
  coerce_args(t_arg, t_choices)
}

test_that("`coerce_args` checks input.", {
  expect_silent(t_coerce_args())
  expect_error(t_coerce_args(t_choices = 1L))
  expect_error(t_coerce_args(t_choices = character()))
  expect_error(t_coerce_args(t_arg = 1L),
               regexp = "`t_arg` must be character scalar.")
  expect_error(t_coerce_args(t_arg = c("a", "z")),
               regexp = "`t_arg` must be character scalar.")
  expect_error(t_coerce_args(t_arg = "nonexist"),
               regexp = "`t_arg` must be one of \"abcdef\", \"123456\", \"xzy\", \"amb\".")
  expect_error(t_coerce_args(t_arg = "a"),
               regexp = "`t_arg` must be one of \"abcdef\", \"123456\", \"xzy\", \"amb\".")
})

test_that("`coerce_args` coerces correctly.", {
  expect_identical(t_coerce_args(), "abcdef")
  expect_identical(t_coerce_args(t_arg = "123456"), "123456")
  expect_identical(t_coerce_args(t_arg = "x"), "xzy")
})


# ==============================================================================
# coerce_character
# ==============================================================================

t_coerce_character <- function(t_x = letters[1:10],
                               t_req_length = NULL) {
  coerce_character(t_x, t_req_length)
}

test_that("`coerce_character` checks input.", {
  expect_silent(t_coerce_character())
  expect_silent(t_coerce_character(t_req_length = 10))
  expect_error(t_coerce_character(t_req_length = 8),
               regexp = "`t_x` is not of length `t_req_length`.")
})

test_that("`coerce_character` coerces correctly.", {
  expect_identical(t_coerce_character(), letters[1:10])
  expect_identical(t_coerce_character(t_x = "123456"), "123456")
  expect_identical(t_coerce_character(t_x = c(1, 2, 3, 4)), c("1", "2", "3", "4"))
})


# ==============================================================================
# coerce_distance_data
# ==============================================================================

t_distance_data_frame <- data.frame(x = 1:10,
                                    y = 11:20,
                                    z = 21:30,
                                    id = letters[1:10],
                                    stringsAsFactors = FALSE)

t_coerce_distance_data <- function(t_data = matrix(as.numeric(1:10), nrow = 5),
                                   t_id_variable = NULL,
                                   t_dist_variables = NULL) {
  coerce_distance_data(t_data, t_id_variable, t_dist_variables)
}

test_that("`coerce_distance_data` checks input.", {
  expect_silent(t_coerce_distance_data())
  expect_silent(t_coerce_distance_data(t_data = matrix(1:10, nrow = 5)))
  expect_silent(t_coerce_distance_data(t_data = 1:10))
  expect_silent(t_coerce_distance_data(t_data = data.frame(matrix(1:10, nrow = 5))))
  expect_silent(t_coerce_distance_data(t_data = data.frame(x = 1:10,
                                                           y = rep(c(TRUE, FALSE), 5))))
  expect_silent(t_coerce_distance_data(t_id_variable = letters[1:5]))
  expect_silent(t_coerce_distance_data(t_data = t_distance_data_frame,
                                       t_id_variable = "id"))
  expect_silent(t_coerce_distance_data(t_data = t_distance_data_frame,
                                       t_id_variable = "id",
                                       t_dist_variables = c("x", "y")))
  expect_error(t_coerce_distance_data(t_data = dist(1:10)),
               regexp = "`t_data` must be vector, matrix or data frame.")
  expect_error(t_coerce_distance_data(t_data = matrix(1:2, nrow = 1)),
               regexp = "`t_data` must contain at least two data points.")
  expect_error(t_coerce_distance_data(t_dist_variables = "X1"),
               regexp = "`t_dist_variables` must be NULL when `t_data` is matrix or vector.")
  expect_error(t_coerce_distance_data(t_data = t_distance_data_frame,
                                      t_id_variable = "xxx"),
               regexp = "`t_id_variable` does not exists as column in `t_data`.")
  expect_error(t_coerce_distance_data(t_data = t_distance_data_frame,
                                      t_id_variable = "id",
                                      t_dist_variables = c("x", "nkjsne")),
               regexp = "Some entries in `t_dist_variables` do not exist as columns in `t_data`.")
  expect_warning(t_coerce_distance_data(t_data = data.frame(x = 1:10,
                                                            y = factor(1:10))),
                 regexp = "Factor columns in `t_data` are coerced to numeric.")
  expect_error(t_coerce_distance_data(t_data = data.frame(x = 1:10,
                                                          y = letters[1:10],
                                                          stringsAsFactors = FALSE)),
               regexp = "Cannot coerce all data columns in `t_data` to numeric.")
  expect_error(t_coerce_distance_data(t_data = matrix(letters[1:10], nrow = 5)),
               regexp = "`t_data` must be numeric.")
  expect_error(t_coerce_distance_data(t_data = matrix(c(1:9, NA), nrow = 5)),
               regexp = "`t_data` may not contain NAs.")
  expect_error(t_coerce_distance_data(t_id_variable = 1:4),
               regexp = "`t_id_variable` does not match `t_data`.")
})

t_dist_test1 <- data.frame(x = as.numeric(1:5),
                           y = 6:10)
t_dist_test2 <- data.frame(x = 1:5,
                           y = 6:10,
                           id = letters[1:5],
                           stringsAsFactors = FALSE)
t_dist_test3 <- data.frame(x = 1:5,
                           y = 6:10,
                           z = 20:24,
                           id = letters[1:5],
                           stringsAsFactors = FALSE)
t_dist_test4 <- data.frame(x = factor(letters[1:5]),
                           y = 6:10)
t_dist_test5 <- matrix(1:10, nrow = 5)
dimnames(t_dist_test5) <- list(1:5, c("a", "b"))

t_dist_ref1 <- list(data = matrix(as.numeric(1:10), nrow = 5),
                    id_variable = NULL)
t_dist_ref2 <- list(data = matrix(as.numeric(1:10), nrow = 5),
                    id_variable = letters[1:5])

test_that("`coerce_distance_data` coerces correctly.", {
  expect_equal(t_coerce_distance_data(), t_dist_ref1)
  expect_equal(t_coerce_distance_data(t_data = matrix(1:10, nrow = 5)), t_dist_ref1)
  expect_equal(t_coerce_distance_data(t_id_variable = letters[1:5]), t_dist_ref2)
  expect_equal(t_coerce_distance_data(t_data = t_dist_test1), t_dist_ref1)
  expect_equal(t_coerce_distance_data(t_data = t_dist_test2,
                                      t_id_variable = "id"), t_dist_ref2)
  expect_equal(t_coerce_distance_data(t_data = t_dist_test3,
                                      t_dist_variables = c("x", "y")), t_dist_ref1)
  expect_equal(t_coerce_distance_data(t_data = t_dist_test3,
                                      t_dist_variables = c("x", "y"),
                                      t_id_variable = "id"), t_dist_ref2)
  expect_warning(expect_equal(t_coerce_distance_data(t_data = t_dist_test4), t_dist_ref1))
  expect_equal(t_coerce_distance_data(t_data = t_dist_test5), t_dist_ref1)
})


# ==============================================================================
# coerce_double
# ==============================================================================

t_coerce_double <- function(t_x = as.numeric(1:10)) {
  coerce_double(t_x)
}

test_that("`coerce_double` checks input.", {
  expect_silent(t_coerce_double())
  expect_silent(t_coerce_double(t_x = NULL))
  expect_silent(t_coerce_double(t_x = 1:10))
  expect_error(t_coerce_double(t_x = letters[1:10]),
               regexp = "`t_x` must be double or NULL.")
})

test_that("`coerce_double` coerces correctly.", {
  expect_identical(t_coerce_double(), as.numeric(1:10))
  expect_identical(t_coerce_double(t_x = NULL), NULL)
  expect_identical(t_coerce_double(t_x = 1:10), as.numeric(1:10))
})


# ==============================================================================
# coerce_integer
# ==============================================================================

t_coerce_integer <- function(t_x = 1:10) {
  coerce_integer(t_x)
}

test_that("`coerce_integer` checks input.", {
  expect_silent(t_coerce_integer())
  expect_silent(t_coerce_integer(t_x = NULL))
  expect_silent(t_coerce_integer(t_x = as.numeric(1:10)))
  expect_error(t_coerce_integer(t_x = letters[1:10]),
               regexp = "`t_x` must be integer or NULL.")
})

test_that("`coerce_integer` coerces correctly.", {
  expect_identical(t_coerce_integer(), 1:10)
  expect_identical(t_coerce_integer(t_x = NULL), NULL)
  expect_identical(t_coerce_integer(t_x = as.numeric(1:10)), 1:10)
})


# ==============================================================================
# coerce_norm_matrix
# ==============================================================================

t_coerce_norm_matrix <- function(t_mat = rep(1, 4),
                                 t_num_cov = 4) {
  coerce_norm_matrix(t_mat, t_num_cov)
}

test_that("`coerce_norm_matrix` checks input.", {
  expect_silent(t_coerce_norm_matrix())
  expect_silent(t_coerce_norm_matrix(t_mat = diag(rep(1, 4))))
  expect_silent(t_coerce_norm_matrix(t_mat = data.frame(diag(rep(1, 4)))))
  expect_silent(t_coerce_norm_matrix(t_mat = matrix(diag(rep(1, 4)), ncol = 4,
                                                    dimnames = list(c(1:4), letters[1:4]))))
  expect_error(t_coerce_norm_matrix(t_mat = dist(1:4)),
               regexp = "`t_mat` must be matrix, data.frame or vector.")
  expect_error(t_coerce_norm_matrix(t_mat = matrix(letters[1:16], ncol = 4)),
               regexp = "`t_mat` must be numeric.")
  expect_error(t_coerce_norm_matrix(t_mat = c(1, NA, 1, 1)),
               regexp = "`t_mat` may not contain NAs.")
  expect_error(t_coerce_norm_matrix(t_mat = matrix(1:16, ncol = 4)),
               regexp = "`t_mat` must be symmetric.")
  expect_error(t_coerce_norm_matrix(t_num_cov = 3),
               regexp = "The dimensions of `t_mat` do not correspond to `t_num_cov`.")
  expect_error(t_coerce_norm_matrix(t_mat = matrix(c(-1, 2, 2, 3), ncol = 2),
                                    t_num_cov = 2),
               regexp = "`t_mat` must be positive-semidefinite.")
})

test_that("`coerce_norm_matrix` coerces correctly.", {
  expect_equal(t_coerce_norm_matrix(),
               diag(rep(1, 4)))
  expect_equal(t_coerce_norm_matrix(t_mat = diag(rep(1, 4))),
               diag(rep(1, 4)))
  expect_equal(t_coerce_norm_matrix(t_mat = data.frame(diag(rep(1, 4)))),
               diag(rep(1, 4)))
  expect_equal(t_coerce_norm_matrix(t_mat = matrix(diag(rep(1, 4)), ncol = 4,
                                                   dimnames = list(c(1:4), letters[1:4]))),
               diag(rep(1, 4)))
})
