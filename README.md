
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rgridstatus2

<!-- badges: start -->

[![R-CMD-check](https://github.com/ben-pfeffer/rgridstatus2/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/ben-pfeffer/rgridstatus2/actions/workflows/R-CMD-check.yaml)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![Project Status:
WIP](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)

<!-- badges: end -->

The goal of rgridstatus2 is to provide an R API wrapper for the
[GridStatusIO](https://www.gridstatus.io/home)
[API](https://www.gridstatus.io/api).

This package is based on Andy Picke’s rgridstatus package. See more at
his [blog
post](https://andypicke.quarto.pub/portfolio/posts/rGridStatus/rGridStatus.html)
and [github page](https://github.com/andypicke/rgridstatus).

## Installation

You can install the development version of
[rgridstatus](https://github.com/ben-pfeffer/rgridstatus2) from
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
```

## Examples

### Get info on datasets available from GridStatus API:

``` r
library(rgridstatus2)

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

head(df, 5)
#>        interval_start_local  interval_start_utc        interval_end_local solar
#> 1 2024-09-03T00:00:00-07:00 2024-09-03 07:00:00 2024-09-03T00:05:00-07:00   -11
#> 2 2024-09-03T00:05:00-07:00 2024-09-03 07:05:00 2024-09-03T00:10:00-07:00   -10
#> 3 2024-09-03T00:10:00-07:00 2024-09-03 07:10:00 2024-09-03T00:15:00-07:00   -10
#> 4 2024-09-03T00:15:00-07:00 2024-09-03 07:15:00 2024-09-03T00:20:00-07:00   -11
#> 5 2024-09-03T00:20:00-07:00 2024-09-03 07:20:00 2024-09-03T00:25:00-07:00   -11
#>   wind geothermal biomass biogas small_hydro coal nuclear natural_gas
#> 1 2225        736     323    159         255    0    2253       12097
#> 2 2211        736     325    159         253    0    2252       12303
#> 3 2165        737     327    156         252    0    2250       12406
#> 4 2122        736     326    156         253    0    2251       12484
#> 5 2077        737     328    156         251    0    2249       12584
#>   large_hydro batteries imports other      datetime_local
#> 1        2732      -456    5764     0 2024-09-03 00:00:00
#> 2        2523       158    5267     0 2024-09-03 00:05:00
#> 3        2491       311    5020     0 2024-09-03 00:10:00
#> 4        2471       261    4994     0 2024-09-03 00:15:00
#> 5        2461       219    4969     0 2024-09-03 00:20:00
```

### Convenience Function - Get Day Ahead Pricing

``` r
# different ISOs have different location_type filter terms
e <- get_da_hourly_prices(iso = 'ercot', location_type = 'Trading Hub', limit = 5)
# c <- get_da_hourly_prices(iso = 'caiso', location_type = 'Trading Hub', limit = 5)
# n <- get_da_hourly_prices(iso = 'nyiso', location_type = 'Zone',        limit = 5)
# m <- get_da_hourly_prices(iso = 'miso',  location_type = 'Interface',   limit = 5)
# s <- get_da_hourly_prices(iso = 'spp',   location_type = 'Interface',   limit = 5)
# i <- get_da_hourly_prices(iso = 'isone', location_type = 'LOAD ZONE',   limit = 5)
# p <- get_da_hourly_prices(iso = 'pjm',   location_type = 'ZONE',        limit = 5) # case sensitive!

# b <- get_da_hourly_prices(iso = 'isone', location = 'DR.MA_Boston', 
#                           start_time = '2024-08-08', end_time = '2024-08-09',
#                           limit = 5)

head(e, 5)
#>        interval_start_local        interval_start_utc        interval_end_local
#> 1 2025-05-09T00:00:00-05:00 2025-05-09T05:00:00+00:00 2025-05-09T01:00:00-05:00
#> 2 2025-05-09T00:00:00-05:00 2025-05-09T05:00:00+00:00 2025-05-09T01:00:00-05:00
#> 3 2025-05-09T00:00:00-05:00 2025-05-09T05:00:00+00:00 2025-05-09T01:00:00-05:00
#> 4 2025-05-09T00:00:00-05:00 2025-05-09T05:00:00+00:00 2025-05-09T01:00:00-05:00
#> 5 2025-05-09T00:00:00-05:00 2025-05-09T05:00:00+00:00 2025-05-09T01:00:00-05:00
#>            interval_end_utc   location location_type           market   spp
#> 1 2025-05-09T06:00:00+00:00  HB_BUSAVG   Trading Hub DAY_AHEAD_HOURLY 42.07
#> 2 2025-05-09T06:00:00+00:00 HB_HOUSTON   Trading Hub DAY_AHEAD_HOURLY 40.11
#> 3 2025-05-09T06:00:00+00:00  HB_HUBAVG   Trading Hub DAY_AHEAD_HOURLY 42.50
#> 4 2025-05-09T06:00:00+00:00   HB_NORTH   Trading Hub DAY_AHEAD_HOURLY 42.75
#> 5 2025-05-09T06:00:00+00:00     HB_PAN   Trading Hub DAY_AHEAD_HOURLY 46.14
```

### Convenience Function - Get Load Data

Coming soon…

### Convenience Function - Get Fuel Mix

Coming soon…

### Convenience Function - Get Capacity Data

Coming soon…
