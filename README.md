# distances

[![CRAN Status](https://www.r-pkg.org/badges/version/distances)](https://cran.r-project.org/package=distances)

The `distances` package provides tools for constructing, manipulating and using distance metrics in R. It calculates distances only as needed (unlike the standard `dist` function which derives the complete distance matrix when called). This saves memory and can increase speed. The package also includes functions for fast nearest and farthest neighbor searching.


## How to install

`distances` is on CRAN and can be installed by running:

```{r}
install.packages("distances")
```


## How to install development version

It is recommended to use the stable CRAN version, but the latest development version can be installed directly from Github using [devtools](https://github.com/r-lib/devtools):

```{r}
if (!require("devtools")) install.packages("devtools")
devtools::install_github("fsavje/distances")
```

The package contains compiled code, and you must have a development environment to install the development version. (Use `devtools::has_devel()` to check whether you do.) If no development environment exists, Windows users download and install [Rtools](https://cran.r-project.org/bin/windows/Rtools/) and macOS users download and install [Xcode](https://apps.apple.com/us/app/xcode/id497799835).
