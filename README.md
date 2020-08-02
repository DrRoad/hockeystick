
<!-- README.md is generated from README.Rmd. Please edit that file -->

# hockeystick <img src='man/figures/logo.png' align="right" height="139" />

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

The goal of hockeystick is to download and visualize essential climate
change data

## Installation

You can install the development version of hockeystick from
<https://github.com/cortinah/hockeystick> with:

``` r
remotes::install_github("cortinah/hockeystick")
```

## Examples

Retrieve NOAA/ESRL Mauna Loa CO<sub>2</sub> concentration and plot it:

``` r
library(hockeystick)
ml_co2 <- get_carbon()
plot_carbon(ml_co2)
```

<img src="man/figures/README-example-1.png" width="75%" />

## Acknowledgments

  - Carbon Dioxide dataset: Dr. Pieter Tans, NOAA/GML
    (www.esrl.noaa.gov/gmd/ccgg/trends/) and Dr. Ralph Keeling, Scripps
    Institution of Oceanography (www.scrippsco2.ucsd.edu/).
  - Caching data sets: ROpenSci guide to [Persistent config and data for
    R packages](https://blog.r-hub.io/2020/03/12/user-preferences/) and
    the [getlandsat](https://docs.ropensci.org/getlandsat/) package.
