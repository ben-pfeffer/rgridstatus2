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

get_fuel_mix <- function(iso,
                         start_time = Sys.Date() - 5,
                         end_time = Sys.Date(),
                         limit = 100,
                         timezone = 'market',
                         location = '',
                         location_type = '',
                         resample_frequency = '',
                         respondent = '',
                         tac_area_name = '') {

  # validate ISO input
  allowed_isos <- c('ercot', 'caiso', 'isone', 'miso', 'nyiso', 'pjm', 'spp', 'eia')
  if(!iso %in% allowed_isos) {
    stop(paste('Invalid ISO entered in get_fuel_mix. Must be one of', list(allowed_isos)))
  }

  # validate resample_frequency input
  allowed_resample_freq <- c('', '1 minute', '5 minutes', '15 minutes',
                             '1 hour', '1 day', '1 week', '1 month', '1 year')
  if(!resample_frequency %in% allowed_resample_freq) {
    stop(paste('Invalid resample_frequency entered in get_fuel_mix. Must be one of',
               list(allowed_resample_freq)))
  }

  wh_dataset <- dplyr::case_when(iso == 'ercot' ~ 'ercot_fuel_mix',
                                 iso == 'caiso' ~ 'caiso_fuel_mix',
                                 iso == 'isone' ~ 'isone_fuel_mix',
                                 iso == 'miso' ~ 'miso_fuel_mix',
                                 iso == 'nyiso' ~ 'nyiso_fuel_mix',
                                 iso == 'pjm' ~ 'pjm_fuel_mix',
                                 iso == 'spp' ~ 'spp_fuel_mix',
                                 iso == 'eia' ~ 'eia_fuel_mix_hourly')

  req_url <- construct_query_url(wh_dataset, start_time, end_time, limit,
                                 timezone, location, location_type,
                                 resample_frequency, respondent, tac_area_name)

  data <- get_api_request(req_url)
}
