# distances

[![CRAN Status](https://www.r-pkg.org/badges/version/distances)](https://cran.r-project.org/package=distances)
[![Build Status](https://travis-ci.org/fsavje/distances.svg?branch=master)](https://travis-ci.org/fsavje/distances)
[![Build status](https://ci.appveyor.com/api/projects/status/x6eqojpbbfk6c0fm/branch/master?svg=true)](https://ci.appveyor.com/project/fsavje/distances/branch/master)
[![codecov](https://codecov.io/gh/fsavje/distances/branch/master/graph/badge.svg)](https://codecov.io/gh/fsavje/distances)

The `distances` package provides tools for constructing, manipulating and using distance metrics in R. It calculates distances only as needed (unlike the standard `dist` function which derives the complete distance matrix when called). This saves memory and can increase speed. The package also includes functions for fast nearest and farthest neighbor searching.


## How to install

`distances` is on CRAN and can be installed by running:

```{r}
install.packages("distances")
```


## How to install development version

It is recommended to use the stable CRAN version, but the latest development version can be installed directly from Github using [devtools](https://github.com/hadley/devtools):

```{r}
if (!require("devtools")) install.packages("devtools")
devtools::install_github("fsavje/distances")
```

The package contains compiled code, and you must have a development environment to install the development version. (Use `devtools::has_devel()` to check whether you do.) If no development environment exists, Windows users download and install [Rtools](https://cran.r-project.org/bin/windows/Rtools/) and macOS users download and install [Xcode](https://itunes.apple.com/us/app/xcode/id497799835).
