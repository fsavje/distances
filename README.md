# distances

[![Build Status](https://travis-ci.org/fsavje/distances.svg?branch=master)](https://travis-ci.org/fsavje/distances)
[![Build status](https://ci.appveyor.com/api/projects/status/x6eqojpbbfk6c0fm/branch/master?svg=true)](https://ci.appveyor.com/project/fsavje/distances/branch/master)
[![codecov](https://codecov.io/gh/fsavje/distances/branch/master/graph/badge.svg)](https://codecov.io/gh/fsavje/distances)

The `distances` package provides tools for constructing, manipulating and using distance metrics. It does not calculate the complete distance matrix when distance metric objects are created. This lowers memory use and can increase speed.

## How to install `distances`

`distances` is not yet on CRAN, but you can install the current development version using [devtools](https://github.com/hadley/devtools):

```{r}
if (!require("devtools")) install.packages("devtools")
devtools::install_github("fsavje/distances")
```

The package contains compiled code, and you must have a development environment installed. (Use `devtools::has_devel()` to check whether you do.) If no development environment exists, Windows users download and install [Rtools](https://cran.r-project.org/bin/windows/Rtools/) and macOS users download and install [Xcode](https://itunes.apple.com/us/app/xcode/id497799835).
