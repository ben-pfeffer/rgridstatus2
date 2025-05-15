#' Download dataset from API
#' @param wh_dataset Name of dataset to download. Default is "caiso_fuel_mix"
#' @param start_time Start time. Default is 5 days ago.
#' @param end_time End time. Default is today's date.
#' @param limit Number of requests to return. Default is 100.
#' @param timezone Default is market, which returns times in the market's local time
#' @param location filter term for the data's location column
#' @param location_type filter term for the data's location_type column
#' @param resample_frequency resample the data to a lower frequency
#' @param respondent for specifying EIA fuel mix zone
#' @returns df: Dataframe of requested dataset
#' @export

get_gridstatus_dataset <- function(wh_dataset,
                                   start_time = Sys.Date() - 5,
                                   end_time = Sys.Date(),
                                   limit = 100,
                                   timezone = 'market',
                                   location = '',
                                   location_type = '',
                                   resample_frequency = '',
                                   respondent = '') {

  # construct full request url
  req_url <- construct_query_url(wh_dataset, start_time, end_time,
                                 limit, timezone, location, location_type,
                                 resample_frequency, respondent)

  df <- get_api_request(req_url)

  return(df)
}
