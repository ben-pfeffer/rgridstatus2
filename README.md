
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rgridstatus2

<!-- badges: start -->

[![R-CMD-check](https://github.com/ben-pfeffer/rgridstatus2/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/ben-pfeffer/rgridstatus2/actions/workflows/R-CMD-check.yaml)
[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-green.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![Project Status:
Active](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)

<!-- badges: end -->

The goal of rgridstatus2 is to provide an R API wrapper for the
[GridStatusIO](https://www.gridstatus.io/home)
[API](https://www.gridstatus.io/api).

This package is built from Andy Picke’s rgridstatus package. See more at
his [blog
post](https://andypicke.quarto.pub/portfolio/posts/rGridStatus/rGridStatus.html)
and [github page](https://github.com/andypicke/rgridstatus).

## Installation

You can install the development version of
[rgridstatus2](https://github.com/ben-pfeffer/rgridstatus2) from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("ben-pfeffer/rgridstatus2")
```

You will need to register for an API key. By default, all functions
assume you have stored your API key in your *.Renviron* file with the
name *GRIDSTATUS_API_KEY*. I used the usethis package to add my key to
my environment.

``` r
# usethis::edit_r_environ() # set API key as GRIDSTATUS_API_KEY = 'XXXXXXXXXXX'
# Sys.getenv('GRIDSTATUS_API_KEY') # test that your key is in your environment

library(rgridstatus2)
```

## Examples

### Get info on datasets available from GridStatus API:

``` r
info <- get_available_datasets()
```

### Get unique data source names

Most of the “sources” are
[ISOs](https://en.wikipedia.org/wiki/Regional_transmission_organization_(North_America)).

``` r
# input is info from get_available_datasets()
sources <- get_source_names(info)
sources
#>  [1] "all"   "caiso" "eia"   "ercot" "ieso"  "isone" "isos"  "miso"  "nyiso"
#> [10] "pjm"   "spp"
```

### Download a dataset

``` r
df <- get_gridstatus_dataset(wh_dataset = "caiso_fuel_mix", 
                             start_time = "2024-09-03", 
                             end_time = "2024-09-05")
```

### Convenience Function - Get Hourly Day Ahead Pricing

``` r
# different ISOs have different location_type filter terms (case sensitive!)
# you can also specify an exact node or hub with the location input
# plus start and end dates and timezones (defaults to market local timezone)

# s <- get_da_prices_hourly(iso = 'spp',   location_type = 'Interface',   limit = 5)
# p <- get_da_prices_hourly(iso = 'pjm',   location_type = 'ZONE',        limit = 5)
  e <- get_da_prices_hourly(iso = 'ercot', location_type = 'Trading Hub', limit = 5)
# c <- get_da_prices_hourly(iso = 'caiso', location_type = 'Trading Hub', limit = 5)
# i <- get_da_prices_hourly(iso = 'isone', location_type = 'LOAD ZONE',   limit = 5)
# m <- get_da_prices_hourly(iso = 'miso',  location_type = 'Interface',   limit = 5)
# e <- get_da_prices_hourly(iso = 'ercot', location_type = 'Trading Hub', limit = 5)
# n <- get_da_prices_hourly(iso = 'nyiso', location_type = 'Zone',        limit = 5)

# b <- get_da_prices_hourly(iso = 'isone', location = 'DR.MA_Boston', 
#                           start_time = '2024-08-08', end_time = '2024-08-09',
#                           limit = 5)
```

### Convenience Function - Get Load Data (ISO and Zonal resolutions)

``` r
# get_load_iso() fetches ISO-level load data
# most ISOs default to 5 minute native granularity
caiso_load <- get_load_iso(iso = 'caiso', resample_frequency = '1 hour', limit = 5)

# get_load_zonal() fetches Zonal-level load data
# Nonmarket EIA data can be found through the get_load_zonal function (native hourly)
# Specify a zone of interest with the location parameter
ava_load <- get_load_zonal(iso = 'eia', respondent = 'AVA', limit = 5)

# ercot has both load zone and weather zone data available
# ercot_lz_load <- get_load_zonal(iso = 'ercot', limit = 5)
# ercot_wz_load <- get_load_zonal(iso = 'ercot_weather', limit = 5)
```

### Convenience Function - Get Fuel Mix

``` r
# note that fuel mix data is natively in 5 minute intervals
# but can be resampled hourly (or other intervals) if desired
ercot_fuel_mix <- get_fuel_mix(iso = 'ercot',
                               limit = 15,
                               resample_frequency = '1 hour')

# EIA publishes fuel mixes for non-market regions (hourly native resolution)
# specify a specific region with the respondent input
carolina_fuel_mix <- get_fuel_mix(iso = 'eia',
                                  limit = 15,
                                  respondent = 'CAR')
```

### Convenience Function - Get Hourly Standardized Data

Standardized data includes load, and generation breakdown by fuel type

``` r
isone_standardized <- get_standardized_data_hourly(iso = 'isone', limit = 5)
```
