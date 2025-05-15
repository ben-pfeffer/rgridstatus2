#' Easily gather hourly DA prices
#' @param iso Name of dataset to download
#' @param start_time Start time. Default is 5 days ago.
#' @param end_time End time. Default is today's date.
#' @param limit Number of requests to return. Default is 100.
#' @param timezone Default is market, which returns times in the market's local time
#' @param location filter term for the data's location column
#' @param location_type filter term for the data's location_type column
#' @param resample_frequency resample the data to a lower frequency
#' @param respondent for specifying EIA fuel mix zone
#' @param tac_area_name for specifying CAISO Zonal load zone (any zone in WECC)
#' @returns dataset of hourly DA Prices for the specified ISO and date range
#' @export
#'

get_da_prices_hourly <- function(iso,
                                 start_time = Sys.Date() - 5,
                                 end_time = Sys.Date(),
                                 limit = 100,
                                 timezone = 'market',
                                 location = '',
                                 location_type = '',
                                 resample_frequency = '',
                                 respondent = '',
                                 tac_area_name = '') {

  allowed_isos <- c('ercot', 'caiso', 'isone', 'miso', 'nyiso', 'pjm', 'spp')
  if(!iso %in% allowed_isos) {
    stop(paste('Invalid ISO entered in get_da_hourly_prices. Must be one of', list(allowed_isos)))
  }

  wh_dataset <- dplyr::case_when(iso == 'ercot' ~ 'ercot_spp_day_ahead_hourly',
                                 iso == 'caiso' ~ 'caiso_lmp_day_ahead_hourly',
                                 iso == 'isone' ~ 'isone_lmp_real_time_hourly_final',
                                 iso == 'miso' ~ 'miso_lmp_day_ahead_hourly',
                                 iso == 'nyiso' ~ 'nyiso_lmp_day_ahead_hourly',
                                 iso == 'pjm' ~ 'pjm_lmp_day_ahead_hourly',
                                 iso == 'spp' ~ 'spp_lmp_day_ahead_hourly')

  req_url <- construct_query_url(wh_dataset, start_time, end_time, limit,
                                 timezone, location, location_type,
                                 resample_frequency, respondent, tac_area_name)

  data <- get_api_request(req_url)
}
