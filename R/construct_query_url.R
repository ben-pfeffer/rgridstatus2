#' Build URL for API data request
#' @param wh_dataset Name of dataset to download
#' @param start_time Start time. Default is 5 days ago.
#' @param end_time End time. Default is today's date.
#' @param limit Number of requests to return. Default is 100.
#' @param timezone Default is market, which returns times in the market's local time
#' @param location filter term for the data's location column
#' @param location_type filter term for the data's location_type column
#' @param resample_frequency resample the data to a lower frequency
#' @param respondent for specifying EIA fuel mix zone
#' @param tac_area_name for specifying CAISO Zonal load zone (any zone in WECC)
#' @returns req_url URL for API request with specified parameters
#' @export
#' @seealso [get_available_datasets()]
#' @examples
#' req_url <- construct_query_url("caiso_fuel_mix", "2024-04-1", "2024-04-10")
#'

construct_query_url <- function(wh_dataset,
                                start_time = Sys.Date() - 5,
                                end_time = Sys.Date(),
                                limit = 100,
                                timezone = 'market',
                                location = '',
                                location_type = '',
                                resample_frequency = '',
                                respondent = '',
                                tac_area_name = '') {

  # base url for the Gridstatusio API
  base_url <- "https://api.gridstatus.io/v1/"

  # construct partial request url
  req_url <- paste0(
    base_url, "datasets/", wh_dataset, "/query?",
    "download=true",
    "&start_time=", start_time,
    "&end_time=", end_time,
    '&timezone=', timezone,
    '&limit=', limit
  )

  # add optional filter parameters
  if(location != '') {
    req_url <- append_url(location, req_url)
  }

  if(location_type != '') {
    req_url <- append_url(location_type, req_url)
  }

  if(respondent != '') {
    req_url <- append_url(respondent, req_url)
  }

  if(tac_area_name != '') {
    req_url <- append_url(tac_area_name, req_url)
  }

  if(resample_frequency != '') {
    resample_frequency_clean <- stringr::str_replace_all(resample_frequency, ' ', '%20')

    req_url <- paste0(req_url, '&resample_frequency=', resample_frequency_clean)
  }

  return(req_url)
}

