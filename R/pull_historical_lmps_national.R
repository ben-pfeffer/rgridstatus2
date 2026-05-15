#' Pulls Historical DA LMPs from Gridstatus for all ISOs for a given date range
#'
#' @param start_date The first day of data to pull
#' @param end_date NOT INCLUSIVE! Gridstatus returns data for dates BEFORE this date,
#' but does not return data for this date
#'
#' @return a table of historical hourly LMPs for all ISOs (wide format). The function
#' also saves an excel file with all the data
#'
#' @export



# main level function to download hourly DA LMPs for all ISOs nationally
pull_historical_lmps_national <- function(start_date, end_date) {

  library(dplyr)
  library(lubridate)
  library(openxlsx2)

  # generic clean up default gridstatus data pull
  clean_up_raw_gridstatus <- function(df) {
    df_clean <- df %>%
      select(interval_start_local, interval_end_local, market, location,
             location_type, lmp) %>%
      # remove text after final -
      mutate(interval_start_local = stringr::str_replace(interval_start_local,
                                                         "-[^-]*$", ""),
             interval_end_local = stringr::str_replace(interval_end_local,
                                                       "-[^-]*$", ""))
  }

  # idiosyncratic clean up processes by ISO
  clean_up_iso <- function(df_raw, iso) {

    if(iso == 'isone') {
      tmp_clean1 <- df_raw %>%
        clean_up_raw_gridstatus() %>%
        group_by(interval_start_local) %>%
        summarize(interval_end_local = first(interval_end_local),
                  market = first(market),
                  location = 'ISONE',
                  location_type = 'Average of Hub Prices',
                  lmp = mean(lmp))

      tmp_clean2 <- df_raw %>%
        clean_up_raw_gridstatus() %>%
        filter(location == '.Z.NEMASSBOST')

      tmp_clean <- rbind(tmp_clean1, tmp_clean2)
      return(tmp_clean)
    }

    if(iso == 'nyiso') {
      tmp_clean1 <- df_raw %>%
        clean_up_raw_gridstatus() %>%
        group_by(interval_start_local) %>%
        summarize(interval_end_local = first(interval_end_local),
                  market = first(market),
                  location = 'NYISO',
                  location_type = 'Average of Zonal Prices',
                  lmp = mean(lmp))

      tmp_clean2 <- df_raw %>%
        clean_up_raw_gridstatus() %>%
        filter(location == 'N.Y.C.')

      tmp_clean <- rbind(tmp_clean1, tmp_clean2)
      return(tmp_clean)
    }

    if(iso == 'pjm') {
      tmp_clean <- df_raw %>%
        clean_up_raw_gridstatus() %>%
        group_by(interval_start_local) %>%
        summarize(interval_end_local = first(interval_end_local),
                  market = first(market),
                  location = 'PJM',
                  location_type = 'Average of Zonal Prices',
                  lmp = mean(lmp))

      return(tmp_clean)
    }

    if(iso == 'miso') {
      tmp_clean <- df_raw %>%
        clean_up_raw_gridstatus() %>%
        group_by(interval_start_local) %>%
        summarize(interval_end_local = first(interval_end_local),
                  market = first(market),
                  location = 'MISO',
                  location_type = 'Average of Interface Prices',
                  lmp = mean(lmp))

      return(tmp_clean)
    }


    if(iso == 'spp') {
      tmp_clean <- df_raw %>%
        clean_up_raw_gridstatus()

      return(tmp_clean)
    }

    if(iso == 'ercot') {
      tmp_clean <- df_raw %>%
        rename(lmp = spp) %>%
        clean_up_raw_gridstatus() %>%
        filter(location == 'HB_HUBAVG') %>%
        mutate(location = 'ERCOT',
               location_type = 'Hub Average')

      return(tmp_clean)
    }

    if(iso == 'caiso') {
      tmp_clean <- df_raw %>%
        clean_up_raw_gridstatus() %>%
        group_by(interval_start_local) %>%
        summarize(interval_end_local = first(interval_end_local),
                  market = first(market),
                  location = 'CAISO',
                  location_type = 'Average of Hub Prices',
                  lmp = mean(lmp))

      return(tmp_clean)
    }
  }

  iso_list <- c('isone', 'nyiso', 'pjm', 'miso', 'spp', 'ercot', 'caiso')

  hourly_lmps_national <- data.frame()
  for(iso in iso_list) {
    start_t <- Sys.time()

    tmp <- download_historical_data(start_date, end_date, iso)
    tmp_clean <- clean_up_iso(tmp, iso)
    hourly_lmps_national <- rbind(hourly_lmps_national, tmp_clean)

    end_t <- Sys.time()
    diff <- difftime(end_t, start_t, units = 'mins')
    message(paste('Finished downloading for', toupper(iso), 'in', round(diff,1),
                  'minutes'))
  }

  # format months and dates
  hourly_lmps_national <- hourly_lmps_national %>%
    mutate(interval_start_local = ymd_hms(interval_start_local),
           interval_end_local = ymd_hms(interval_end_local),
           day = as_date(interval_start_local),
           year = year(interval_start_local),
           month = month(interval_start_local),
           day = day(interval_start_local),
           hour = hour(interval_start_local) + 1)

  # pivot to wide format
  hourly_lmps_wide <- hourly_lmps_national %>%
    select(-location_type) %>%
    tidyr::pivot_wider(names_from = location, values_from = lmp)

  # write outputs to excel file
  wb <- wb_workbook() %>%
    wb_add_worksheet('Prices Wide') %>%
    wb_add_data(x = hourly_lmps_wide) %>%
    wb_add_worksheet('Prices Long') %>%
    wb_add_data(x = hourly_lmps_national)

  wb_save(wb, paste0("National Historical Prices " , start_date,
                     ' to ', end_date, ".xlsx"))

  return(hourly_lmps_wide)
}

# helper function to avoid 100,000 row gridstatus limit per API call
calculate_expected_rows <- function(start_date, end_date, num_locations) {
  num_days <- difftime(as.Date(end_date), as.Date(start_date))
  num_rows <- num_days * 24 * num_locations
}

# function to download hourly LMPs for a given ISO between given dates
download_historical_data <- function(start_date, end_date, iso) {

  num_locations <- case_when(iso == 'isone' ~ 8,
                             iso == 'nyiso' ~ 15,
                             iso == 'pjm' ~ 23,
                             iso == 'miso' ~ 45,
                             iso == 'spp' ~ 2,
                             iso == 'ercot' ~ 7,
                             iso == 'caiso' ~ 3)

  if(calculate_expected_rows(start_date, end_date, num_locations) > 100000) {

    # find the round down halfway day between two dates
    halfway_date <- as_date(start_date) + floor((as_date(end_date) -
                                                   as_date(start_date)) / 2)

    d1 <- download_historical_data(start_date, halfway_date, iso)
    d2 <- download_historical_data(halfway_date, end_date, iso)
    d <- rbind(d1, d2)
  }
  else {
    location_type <- case_when(iso == 'isone' ~ 'LOAD ZONE',
                               iso == 'nyiso' ~ 'Zone',
                               iso == 'pjm' ~ 'ZONE',
                               iso == 'miso' ~ 'Interface',
                               iso == 'spp' ~ 'Hub',
                               iso == 'ercot' ~ 'Trading Hub',
                               iso == 'caiso' ~ 'Trading Hub')

    # try to download data
    message(paste0('Downloading historical prices for ', toupper(iso), '...'))
    d <- try(get_da_prices_hourly(iso = iso,  location_type = location_type,
                                  limit = 8760*num_locations*1.1,
                                  start_time = start_date, end_time = end_date))

    # if download fails, try again once
    if (inherits(d, "try-error")) {
      message(paste0("Error downloading ", iso, ' from ', start_date, ' to ',
                     end_date, '. Retrying...'))
      d <- try(get_da_prices_hourly(iso = iso,  location_type = location_type,
                                    limit = 8760*num_locations*1.1,
                                    start_time = start_date, end_time = end_date))

      # if download fails a second time, abort
      if (inherits(d, "try-error")) {
        message(paste0("Another Error downloading ", iso, '. Aborting Script.'))
      }
    }
  }
  return(d)
}
