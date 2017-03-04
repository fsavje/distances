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


# ==============================================================================
# Helper functions
# ==============================================================================

# Throw error
new_error <- function(...) {
  stop(structure(list(message = paste0(...),
                      call = match.call(definition = sys.function(-2),
                                        call = sys.call(which = -2),
                                        expand.dots = TRUE,
                                        envir = sys.frame(-3))),
                 class = c("error", "condition")))
}


# Throw warning
new_warning <- function(...) {
  warning(structure(list(message = paste0(...),
                         call = match.call(definition = sys.function(-2),
                                           call = sys.call(which = -2),
                                           expand.dots = TRUE,
                                           envir = sys.frame(-3))),
                    class = c("warning", "condition")))
}


# ==============================================================================
# Ensure functions
# ==============================================================================

# Ensure that `distances` is a `distances` object
ensure_distances <- function(x) {
  if (!is.distances(x)) {
    new_error("`", match.call()$x, "` is not a `distances` object.")
  }
}


# ==============================================================================
# Coerce functions
# ==============================================================================

# Similar to `match.arg` but with custom error message
coerce_args <- function(arg,
                        choices) {
  stopifnot(is.character(choices),
            length(choices) > 0)
  if (!is.character(arg) || (length(arg) != 1L)) {
    new_error("`", match.call()$arg, "` must be character scalar.")
  }
  i <- pmatch(arg, choices, nomatch = 0L)
  if (i == 0) {
    new_error("`", match.call()$arg, "` must be one of ", paste0(paste0("\"", choices, "\""), collapse = ", "), ".")
  }
  choices[i]
}


# Coerce `x` to character vector
coerce_character <- function(x,
                             req_length = NULL) {
  x <- as.character(x)
  if (!is.null(req_length) && (length(x) != req_length)) {
    new_error("`", match.call()$x, "` is not of length `", match.call()$req_length, "`.")
  }
  x
}


# Coerce `data` to non-NA, numeric matrix and extract `id_variable`
coerce_distance_data <- function(data,
                                 id_variable,
                                 dist_variables) {
  if (!is.data.frame(data) && !is.matrix(data) && !is.vector(data)) {
    new_error("`", match.call()$data, "` must be vector, matrix or data frame.")
  }
  if (is.vector(data)) {
    data <- matrix(data, nrow = length(data))
  }
  if (nrow(data) < 2L) {
    new_error("`", match.call()$data, "` must contain at least two data points.")
  }
  if (is.matrix(data)) {
    if (!is.null(dist_variables)) {
      new_error("`", match.call()$dist_variables, "` must be NULL when `", match.call()$data, "` is matrix or vector.")
    }
  } else {
    # is.data.frame(data) == TRUE
    if (!is.null(id_variable) && (length(id_variable) == 1)) {
      if (!(as.character(id_variable) %in% colnames(data))) {
        new_error("`", match.call()$id_variable, "` does not exists as column in `", match.call()$data, "`.")
      }
      if (is.null(dist_variables)) {
        dist_variables <- setdiff(colnames(data), as.character(id_variable))
      }
      id_variable <- data[, as.character(id_variable), drop = TRUE]
    }
    if (!is.null(dist_variables)) {
      if (!all(as.character(dist_variables) %in% colnames(data))) {
        new_error("Some entries in `", match.call()$dist_variables, "` do not exist as columns in `", match.call()$data, "`.")
      }
      data <- data[, as.character(dist_variables), drop = FALSE]
    }
    for (col in names(data)) {
      if (!is.double(data[, col])) {
        if (is.numeric(data[, col])) {
          data[, col] <- as.double(data[, col])
        } else if (is.factor(data[, col])) {
          new_warning("Factor columns in `", match.call()$data, "` are coerced to numeric.")
          data[, col] <- as.double(data[, col])
        } else {
          new_error("Cannot coerce all data columns in `", match.call()$data, "` to numeric.")
        }
      }
    }
    data <- as.matrix(data)
  }
  if (!is.double(data)) {
    if (is.numeric(data)) {
      storage.mode(data) <- "double"
    } else {
      new_error("`", match.call()$data, "` must be numeric.")
    }
  }
  if (any(is.na(data))) {
    new_error("`", match.call()$data, "` may not contain NAs.")
  }
  if (!is.null(id_variable) && (length(id_variable) != nrow(data))) {
    new_error("`", match.call()$id_variable, "` does not match `", match.call()$data, "`.")
  }
  list(data = unname(data),
       id_variable = id_variable)
}


# Coerce `x` to double or null
coerce_double <- function(x) {
  if (!is.double(x) && !is.null(x)) {
    if (is.numeric(x)) {
      storage.mode(x) <- "double"
    } else {
      new_error("`", match.call()$x, "` must be double or NULL.")
    }
  }
  x
}


# Coerce `x` to integer or null
coerce_integer <- function(x) {
  if (!is.integer(x) && !is.null(x)) {
    if (is.numeric(x)) {
      storage.mode(x) <- "integer"
    } else {
      new_error("`", match.call()$x, "` must be integer or NULL.")
    }
  }
  x
}


# Coerce `mat` to symmetric, positive-semidefinite, numeric matrix
coerce_norm_matrix <- function(mat,
                               num_cov) {
  if (is.data.frame(mat)) {
    mat <- as.matrix(mat)
  } else if (is.vector(mat)) {
    mat <- diag(mat)
  }
  mat <- unname(mat)
  if (!is.matrix(mat)) {
    new_error("`", match.call()$mat, "` must be matrix, data.frame or vector.")
  }
  if (!is.numeric(mat)) {
    new_error("`", match.call()$mat, "` must be numeric.")
  }
  if (any(is.na(mat))) {
    new_error("`", match.call()$mat, "` may not contain NAs.")
  }
  if (!isSymmetric(mat)) {
    new_error("`", match.call()$mat, "` must be symmetric.")
  }
  if (ncol(mat) != num_cov) {
    new_error("The dimensions of `", match.call()$mat, "` do not correspond to `", match.call()$num_cov, "`.")
  }
  if (any(eigen(mat, symmetric = TRUE, only.values = TRUE)$values <= 2 * .Machine$double.eps)) {
    new_error("`", match.call()$mat, "` must be positive-semidefinite.")
  }
  mat
}
