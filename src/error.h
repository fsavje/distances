/* =============================================================================
 * distances -- R package with tools for distance metrics
 * https://github.com/fsavje/distances
 *
 * Copyright (C) 2017  Fredrik Savje -- http://fredriksavje.com
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see http://www.gnu.org/licenses/
 * ========================================================================== */

#ifndef DIST_ERROR_HG
#define DIST_ERROR_HG

#ifdef __cplusplus
extern "C" {
#endif

#define idist_error(msg) (idist_error__(msg, __FILE__, __LINE__))

#define idist_assert(expression) (void)((expression) || (idist_error__("Failed assert: `" #expression "`.", __FILE__, __LINE__), 0))

void idist_error__(const char* msg,
                   const char* file,
                   int line);

#ifdef __cplusplus
}
#endif

#endif // ifndef DIST_ERROR_HG
