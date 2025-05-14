
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rgridstatus2

<!-- badges: start -->

[![R-CMD-check](https://github.com/ben-pfeffer/rgridstatus2/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/ben-pfeffer/rgridstatus2/actions/workflows/R-CMD-check.yaml)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![Project Status:
WIP](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)

<!-- badges: end -->

The goal of rgridstatus2 is to provide a R API wrapper for the
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
name *GRIDSTATUS_API_KEY*.

## Examples

### Get info on datasets available from GridStatus API:

``` r

library(rgridstatus2)
library(tidyverse)
#> ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
#> ✔ dplyr     1.1.4     ✔ readr     2.1.5
#> ✔ forcats   1.0.0     ✔ stringr   1.5.1
#> ✔ ggplot2   3.5.2     ✔ tibble    3.2.1
#> ✔ lubridate 1.9.4     ✔ tidyr     1.3.1
#> ✔ purrr     1.0.4     
#> ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
#> ✖ dplyr::filter() masks stats::filter()
#> ✖ dplyr::lag()    masks stats::lag()
#> ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors

info <- get_available_datasets()
head(info)
#>                                                 id
#> 1                                      all_records
#> 2                           all_records_timeseries
#> 3                                  caiso_as_prices
#> 4                         caiso_as_procurement_dam
#> 5 caiso_curtailed_non_operational_generator_report
#> 6                                caiso_curtailment
#>                                               name
#> 1                                      All Records
#> 2                           All Records Timeseries
#> 3                                  CAISO AS Prices
#> 4                         CAISO AS Procurement DAM
#> 5 CAISO Curtailed Non Operational Generator Report
#> 6                                CAISO Curtailment
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       description
#> 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           Top daily records for various metrics across all ISOs
#> 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         Timeline of new records for various metrics in all ISOs
#> 3 Ancillary Services Prices as reported by CAISO.\n\n**AS Mapping**\n\nThe *_EXP show only the intertie resources.\n \n-    AS_SP26_P: Resources in AS_SP26\n-    AS_NP26_P: Resources in AS_NP26\n-    AS_SP15_P: Resources in AS_SP15\n-    AS_NP15_P: Resources in AS_NP15\n-    AS_SP26_EXP_P: Resources in AS_SP26_EXP which are not in AS_SP26\n-    AS_NP26_EXP_P: Resources in AS_NP26_EXP which are not in AS_NP26\n-    AS_SP15_EXP_P: Resources in AS_SP15_EXP which are not in AS_SP15\n-    AS_NP15_EXP_P: Resources in AS_NP15_EXP which are not in AS_NP15\n-    AS_CAISO_NP26_P: Resources in AS_CAISO which are not in AS_SP26\n-    AS_CAISO_SP26_P: Resources in AS_CAISO which are not in AS_NP26\n-    AS_CAISO_NP15_P: Resources in AS_CAISO which are not in AS_SP15\n-    AS_CAISO_SP15_P: Resources in AS_CAISO which are not in AS_NP15
#> 4                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Ancillary services procurement data from CAISO.\nIncludes total MW procured and costs.  Corresponds\nto CAISO AS_RESULTS dataset on OASIS. See caiso_as_prices dataset\nfor per MW prices that result from market run.
#> 5                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Prior Day Curtailed Non-Operational Generator Report as reported by CAISO.\n\nGlossary: https://www.caiso.com/glossary
#> 6                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  Daily Curtailment data as reported by CAISO.\n\nNote: CAISO did not publish curtailment reports for 2024-07-26 and 2024-07-27.
#>   earliest_available_time_utc latest_available_time_utc     source
#> 1   2017-12-13T22:05:00+00:00 2025-05-07T19:20:00+00:00 gridstatus
#> 2   2011-01-01T06:30:00+00:00 2025-05-07T14:00:00+00:00 gridstatus
#> 3   2010-01-01T08:00:00+00:00 2025-05-16T06:00:00+00:00      caiso
#> 4   2010-01-01T08:00:00+00:00 2025-05-15T20:00:00+00:00      caiso
#> 5   2021-06-18T07:00:00+00:00 2025-05-14T07:00:00+00:00      caiso
#> 6   2017-01-01T12:00:00+00:00 2025-05-14T06:00:00+00:00      caiso
#>       last_checked_time_utc
#> 1 2025-05-14T20:06:44+00:00
#> 2 2025-05-14T20:06:44+00:00
#> 3 2025-05-14T19:56:57+00:00
#> 4 2025-05-14T20:06:41+00:00
#> 5 2025-05-14T19:39:47+00:00
#> 6 2025-05-14T19:39:55+00:00
#>                                                   primary_key_columns
#> 1                                 iso, rank, record_type, metric_name
#> 2                   iso, interval_start_utc, record_type, metric_name
#> 3                                  interval_start_utc, region, market
#> 4                                          interval_start_utc, region
#> 5           publish_time_utc, outage_mrid, curtailment_start_time_utc
#> 6 interval_start_utc, curtailment_type, curtailment_reason, fuel_type
#>   publish_time_column          time_index_column subseries_index_column
#> 1                <NA>         interval_start_utc                   <NA>
#> 2                <NA>         interval_start_utc                   <NA>
#> 3                <NA>         interval_start_utc                 region
#> 4                <NA>         interval_start_utc                 region
#> 5    publish_time_utc curtailment_start_time_utc                   <NA>
#> 6                <NA>         interval_start_utc                   <NA>
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                all_columns
#> 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   rank, iso, interval_start_utc, date, record_type, metric_name, metric_value, BIGINT, TEXT, TIMESTAMP, DATE, TEXT, TEXT, DOUBLE PRECISION, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, TRUE, TRUE, FALSE, FALSE, FALSE
#> 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              iso, interval_start_utc, date, record_type, metric_name, metric_value, TEXT, TIMESTAMP, DATE, TEXT, TEXT, DOUBLE PRECISION, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, FALSE, TRUE, TRUE, FALSE, FALSE, FALSE
#> 3                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   interval_start_utc, interval_end_utc, region, market, non_spinning_reserves, regulation_down, regulation_mileage_down, regulation_mileage_up, regulation_up, spinning_reserves, TIMESTAMP, TIMESTAMP, VARCHAR, VARCHAR, DOUBLE PRECISION, DOUBLE PRECISION, DOUBLE PRECISION, DOUBLE PRECISION, DOUBLE PRECISION, DOUBLE PRECISION, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE
#> 4 interval_start_utc, interval_end_utc, region, market, non_spinning_reserves_procured_mw, non_spinning_reserves_self_provided_mw, non_spinning_reserves_total_mw, non_spinning_reserves_total_cost, regulation_down_procured_mw, regulation_down_self_provided_mw, regulation_down_total_mw, regulation_down_total_cost, regulation_mileage_down_procured_mw, regulation_mileage_down_self_provided_mw, regulation_mileage_down_total_mw, regulation_mileage_down_total_cost, regulation_mileage_up_procured_mw, regulation_mileage_up_self_provided_mw, regulation_mileage_up_total_mw, regulation_mileage_up_total_cost, regulation_up_procured_mw, regulation_up_self_provided_mw, regulation_up_total_mw, regulation_up_total_cost, spinning_reserves_procured_mw, spinning_reserves_self_provided_mw, spinning_reserves_total_mw, spinning_reserves_total_cost, TIMESTAMP, TIMESTAMP, VARCHAR, VARCHAR, DOUBLE PRECISION, DOUBLE PRECISION, DOUBLE PRECISION, DOUBLE PRECISION, DOUBLE PRECISION, DOUBLE PRECISION, DOUBLE PRECISION, DOUBLE PRECISION, DOUBLE PRECISION, DOUBLE PRECISION, DOUBLE PRECISION, DOUBLE PRECISION, DOUBLE PRECISION, DOUBLE PRECISION, DOUBLE PRECISION, DOUBLE PRECISION, DOUBLE PRECISION, DOUBLE PRECISION, DOUBLE PRECISION, DOUBLE PRECISION, DOUBLE PRECISION, DOUBLE PRECISION, DOUBLE PRECISION, DOUBLE PRECISION, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE
#> 5                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        publish_time_utc, outage_mrid, resource_name, resource_id, outage_type, nature_of_work, curtailment_start_time_utc, curtailment_end_time_utc, curtailment_mw, resource_pmax_mw, net_qualifying_capacity_mw, TIMESTAMP, INTEGER, VARCHAR, VARCHAR, VARCHAR, VARCHAR, TIMESTAMP, TIMESTAMP, DOUBLE PRECISION, DOUBLE PRECISION, DOUBLE PRECISION, FALSE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, TRUE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, FALSE, FALSE, FALSE
#> 6                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  interval_start_utc, interval_end_utc, curtailment_type, curtailment_reason, fuel_type, curtailment_mwh, curtailment_mw, TIMESTAMP, TIMESTAMP, VARCHAR, VARCHAR, VARCHAR, INTEGER, INTEGER, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, TRUE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE
#>   number_of_rows_approximate        table_type is_in_snowflake data_frequency
#> 1                        620 materialized_view           FALSE      IRREGULAR
#> 2                       2155 materialized_view           FALSE      IRREGULAR
#> 3                     621445             table            TRUE         1_HOUR
#> 4                     623449             table            TRUE         1_HOUR
#> 5                    2490715             table            TRUE      IRREGULAR
#> 6                      67748             table            TRUE      5_MINUTES
#>                                                                                 source_url
#> 1                                                                                     <NA>
#> 2                                                                                     <NA>
#> 3                                                 http://oasis.caiso.com/mrioasis/logon.do
#> 4                                                 http://oasis.caiso.com/mrioasis/logon.do
#> 5 https://www.caiso.com/market-operations/outages/curtailed-and-non-operational-generators
#> 6                      https://www.caiso.com/about/our-business/managing-the-evolving-grid
#>   publication_frequency is_published status
#> 1                  <NA>         TRUE active
#> 2                  <NA>         TRUE active
#> 3                  <NA>         TRUE active
#> 4                  <NA>         TRUE active
#> 5                  <NA>         TRUE active
#> 6                  <NA>         TRUE active
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

### Get dataset names for one operator/source

The dataset names all start with the ISO/source, so it is easy to filter
by those:

``` r

info_caiso <- get_available_datasets() |> 
  dplyr::filter(stringr::str_detect(name,"^CAISO_")) # name starts with "CAISO_"
```

### Download a dataset

``` r

df <- get_gridstatus_dataset(wh_dataset = "caiso_fuel_mix", 
                             start_time = "2024-09-03", 
                             end_time = "2024-09-05")

str(df)
#> 'data.frame':    100 obs. of  17 variables:
#>  $ interval_start_local: chr  "2024-09-03T00:00:00-07:00" "2024-09-03T00:05:00-07:00" "2024-09-03T00:10:00-07:00" "2024-09-03T00:15:00-07:00" ...
#>  $ interval_start_utc  : POSIXct, format: "2024-09-03 07:00:00" "2024-09-03 07:05:00" ...
#>  $ interval_end_local  : chr  "2024-09-03T00:05:00-07:00" "2024-09-03T00:10:00-07:00" "2024-09-03T00:15:00-07:00" "2024-09-03T00:20:00-07:00" ...
#>  $ solar               : int  -11 -10 -10 -11 -11 -10 -10 -10 -10 -10 ...
#>  $ wind                : int  2225 2211 2165 2122 2077 2053 2034 1998 1946 1897 ...
#>  $ geothermal          : int  736 736 737 736 737 737 737 737 736 737 ...
#>  $ biomass             : int  323 325 327 326 328 330 329 330 330 330 ...
#>  $ biogas              : int  159 159 156 156 156 155 155 156 156 156 ...
#>  $ small_hydro         : int  255 253 252 253 251 250 250 250 251 252 ...
#>  $ coal                : int  0 0 0 0 0 0 0 0 0 0 ...
#>  $ nuclear             : int  2253 2252 2250 2251 2249 2250 2250 2250 2251 2250 ...
#>  $ natural_gas         : int  12097 12303 12406 12484 12584 12549 12484 12412 12334 12291 ...
#>  $ large_hydro         : int  2732 2523 2491 2471 2461 2451 2447 2446 2445 2448 ...
#>  $ batteries           : int  -456 158 311 261 219 73 -50 -205 -329 -350 ...
#>  $ imports             : int  5764 5267 5020 4994 4969 5134 5241 5266 5337 5377 ...
#>  $ other               : int  0 0 0 0 0 0 0 0 0 0 ...
#>  $ datetime_local      : POSIXct, format: "2024-09-03 00:00:00" "2024-09-03 00:05:00" ...
```

### Get Day Ahead Pricing

``` r

# different ISOs have different location_type filter terms
e <- get_da_hourly_prices(iso = 'ercot', location_type = 'Trading Hub', limit = 5)
# c <- get_da_hourly_prices(iso = 'caiso', location_type = 'Trading Hub', limit = 5)
# n <- get_da_hourly_prices(iso = 'nyiso', location_type = 'Zone',        limit = 5)
# m <- get_da_hourly_prices(iso = 'miso',  location_type = 'Interface',   limit = 5)
# s <- get_da_hourly_prices(iso = 'spp',   location_type = 'Interface',   limit = 5)
# i <- get_da_hourly_prices(iso = 'isone', location_type = 'LOAD ZONE',   limit = 5)
# p <- get_da_hourly_prices(iso = 'pjm',   location_type = 'ZONE',        limit = 5) # case sensitive!

b <- get_da_hourly_prices(iso = 'isone', location = 'DR.MA_Boston', 
                          start_time = '2024-08-08', end_time = '2024-08-09',
                          limit = 5)

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
