
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
#>        interval_start_local        interval_start_utc        interval_end_local
#> 1 2024-09-03T00:00:00-07:00 2024-09-03T07:00:00+00:00 2024-09-03T00:05:00-07:00
#> 2 2024-09-03T00:05:00-07:00 2024-09-03T07:05:00+00:00 2024-09-03T00:10:00-07:00
#> 3 2024-09-03T00:10:00-07:00 2024-09-03T07:10:00+00:00 2024-09-03T00:15:00-07:00
#> 4 2024-09-03T00:15:00-07:00 2024-09-03T07:15:00+00:00 2024-09-03T00:20:00-07:00
#> 5 2024-09-03T00:20:00-07:00 2024-09-03T07:20:00+00:00 2024-09-03T00:25:00-07:00
#>            interval_end_utc solar wind geothermal biomass biogas small_hydro
#> 1 2024-09-03T07:05:00+00:00   -11 2225        736     323    159         255
#> 2 2024-09-03T07:10:00+00:00   -10 2211        736     325    159         253
#> 3 2024-09-03T07:15:00+00:00   -10 2165        737     327    156         252
#> 4 2024-09-03T07:20:00+00:00   -11 2122        736     326    156         253
#> 5 2024-09-03T07:25:00+00:00   -11 2077        737     328    156         251
#>   coal nuclear natural_gas large_hydro batteries imports other
#> 1    0    2253       12097        2732      -456    5764     0
#> 2    0    2252       12303        2523       158    5267     0
#> 3    0    2250       12406        2491       311    5020     0
#> 4    0    2251       12484        2471       261    4994     0
#> 5    0    2249       12584        2461       219    4969     0
```

### Convenience Function - Get Day Ahead Pricing

``` r
# different ISOs have different location_type filter terms (case sensitive!)
# you can also specify an exact node or hub with the location input
# plus start and end dates and timezones (defaults to market local timezone)

# s <- get_da_hourly_prices(iso = 'spp',   location_type = 'Interface',   limit = 5)
# p <- get_da_hourly_prices(iso = 'pjm',   location_type = 'ZONE',        limit = 5)
  e <- get_da_hourly_prices(iso = 'ercot', location_type = 'Trading Hub', limit = 5)
# c <- get_da_hourly_prices(iso = 'caiso', location_type = 'Trading Hub', limit = 5)
# i <- get_da_hourly_prices(iso = 'isone', location_type = 'LOAD ZONE',   limit = 5)
# m <- get_da_hourly_prices(iso = 'miso',  location_type = 'Interface',   limit = 5)
# e <- get_da_hourly_prices(iso = 'ercot', location_type = 'Trading Hub', limit = 5)
# n <- get_da_hourly_prices(iso = 'nyiso', location_type = 'Zone',        limit = 5)

# b <- get_da_hourly_prices(iso = 'isone', location = 'DR.MA_Boston', 
#                           start_time = '2024-08-08', end_time = '2024-08-09',
#                           limit = 5)

head(e, 5)
#>        interval_start_local        interval_start_utc        interval_end_local
#> 1 2025-05-10T00:00:00-05:00 2025-05-10T05:00:00+00:00 2025-05-10T01:00:00-05:00
#> 2 2025-05-10T00:00:00-05:00 2025-05-10T05:00:00+00:00 2025-05-10T01:00:00-05:00
#> 3 2025-05-10T00:00:00-05:00 2025-05-10T05:00:00+00:00 2025-05-10T01:00:00-05:00
#> 4 2025-05-10T00:00:00-05:00 2025-05-10T05:00:00+00:00 2025-05-10T01:00:00-05:00
#> 5 2025-05-10T00:00:00-05:00 2025-05-10T05:00:00+00:00 2025-05-10T01:00:00-05:00
#>            interval_end_utc   location location_type           market   spp
#> 1 2025-05-10T06:00:00+00:00  HB_BUSAVG   Trading Hub DAY_AHEAD_HOURLY 41.19
#> 2 2025-05-10T06:00:00+00:00 HB_HOUSTON   Trading Hub DAY_AHEAD_HOURLY 40.05
#> 3 2025-05-10T06:00:00+00:00  HB_HUBAVG   Trading Hub DAY_AHEAD_HOURLY 41.53
#> 4 2025-05-10T06:00:00+00:00   HB_NORTH   Trading Hub DAY_AHEAD_HOURLY 41.65
#> 5 2025-05-10T06:00:00+00:00     HB_PAN   Trading Hub DAY_AHEAD_HOURLY 44.20
```

### Convenience Function - Get Load Data (ISO and Zonal resolutions)

Coming soon…

### Convenience Function - Get Fuel Mix

``` r
# note that fuel mix data is natively in 5 minute intervals
# but can be resampled hourly (or other intervals) if desired
ercot_fuel_mix <- get_fuel_mix(iso = 'ercot',
                               limit = 15,
                               resample_frequency = '1 hour')
head(ercot_fuel_mix, 5)
#>        interval_start_local        interval_start_utc        interval_end_local
#> 1 2025-05-10T00:00:00-05:00 2025-05-10T05:00:00+00:00 2025-05-10T01:00:00-05:00
#> 2 2025-05-10T01:00:00-05:00 2025-05-10T06:00:00+00:00 2025-05-10T02:00:00-05:00
#> 3 2025-05-10T02:00:00-05:00 2025-05-10T07:00:00+00:00 2025-05-10T03:00:00-05:00
#> 4 2025-05-10T03:00:00-05:00 2025-05-10T08:00:00+00:00 2025-05-10T04:00:00-05:00
#> 5 2025-05-10T04:00:00-05:00 2025-05-10T09:00:00+00:00 2025-05-10T05:00:00-05:00
#>            interval_end_utc coal_and_lignite    hydro  nuclear power_storage
#> 1 2025-05-10T06:00:00+00:00         7817.357 135.8202 3831.783      337.7860
#> 2 2025-05-10T07:00:00+00:00         7689.243 139.5328 3832.024      260.0565
#> 3 2025-05-10T08:00:00+00:00         7655.841 139.7241 3833.212      220.3583
#> 4 2025-05-10T09:00:00+00:00         7611.821 139.8233 3833.630      175.8334
#> 5 2025-05-10T10:00:00+00:00         7530.173 140.1089 3834.102      141.1753
#>       solar     wind natural_gas     other
#> 1 0.1936253 5789.068    27209.80 0.1938161
#> 2 0.2687631 5875.986    25334.53 0.1893156
#> 3 0.3541457 6048.499    23371.16 0.2111240
#> 4 0.4287731 6708.144    22302.09 0.2020901
#> 5 0.3805516 7614.964    21271.78 0.2436381

# EIA publishes fuel mixes for non-market regions (hourly native resolution)
# specify a specific region with the respondent input
carolina_fuel_mix <- get_fuel_mix(iso = 'eia',
                                  limit = 15,
                                  respondent = 'CAR')
head(carolina_fuel_mix, 5)
#>          interval_start_utc          interval_end_utc respondent
#> 1 2025-05-10T00:00:00+00:00 2025-05-10T01:00:00+00:00        CAR
#> 2 2025-05-10T01:00:00+00:00 2025-05-10T02:00:00+00:00        CAR
#> 3 2025-05-10T02:00:00+00:00 2025-05-10T03:00:00+00:00        CAR
#> 4 2025-05-10T03:00:00+00:00 2025-05-10T04:00:00+00:00        CAR
#> 5 2025-05-10T04:00:00+00:00 2025-05-10T05:00:00+00:00        CAR
#>   respondent_name coal hydro natural_gas nuclear other petroleum solar wind
#> 1       Carolinas 5055  1419        4959   11996   919         0    16   NA
#> 2       Carolinas 4806  1269        4575   11998   927         0    -6   NA
#> 3       Carolinas 4575   817        4064   12008   878         0    -3   NA
#> 4       Carolinas 3921   652        3779   12013   817         0    -6   NA
#> 5       Carolinas 3382   450        3524   12024   762         0    -4   NA
#>   battery_storage pumped_storage solar_with_integrated_battery_storage
#> 1               0           1967                                    -1
#> 2               0           1776                                     0
#> 3               0           1444                                    -2
#> 4               0            681                                    -1
#> 5               0             -2                                    -1
#>   unknown_energy_storage geothermal other_energy_storage
#> 1                     NA         NA                   NA
#> 2                     NA         NA                   NA
#> 3                     NA         NA                   NA
#> 4                     NA         NA                   NA
#> 5                     NA         NA                   NA
#>   wind_with_integrated_battery_storage
#> 1                                   NA
#> 2                                   NA
#> 3                                   NA
#> 4                                   NA
#> 5                                   NA
```

### Convenience Function - Get Hourly Standardized Data

Coming soon…
