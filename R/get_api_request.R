#' Make API GET request and return data
#' @param query_url URL for the API query
#' @param api_key API key; Defaults is key saved in .renviron file as "GRIDSTATUS_API_KEY"
#' @param parse_request boolean - TRUE returns data; FALSE returns raw JSON. Default is TRUE
#' @returns data from the API response
#' @export

get_api_request <- function(query_url, api_key = Sys.getenv("GRIDSTATUS_API_KEY"),
                            parse_request = TRUE){

  # send GET request
  resp <- httr::GET(query_url, httr::add_headers('x-api-key' = api_key),
                    httr::user_agent("rgridstatus2 (https://github.com/ben-pfeffer/gridstatus2)"))

  # check if successful response code returned
  if (resp$status_code != 200) {
    stop(paste("API returned not 200 status code: ", resp$status_code))
  }

  if(parse_request == TRUE) {
    #parse response
    resp_parsed <- jsonlite::fromJSON(httr::content(resp, as = "text", encoding = "UTF-8"))

    # return the data
    df <- resp_parsed$data
  }

  if(parse_request == FALSE) {
    # return raw json
    df <- resp
  }

  return(df)

}
