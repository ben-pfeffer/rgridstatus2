#' append to URL for API data request
#' @param variable_name name of the filter variable
#' @param req_url the url to be appended to
#' @export
#'

append_url <- function(variable_name, req_url = req_url) {

  variable_value_clean <- stringr::str_replace_all(variable_name, ' ', '%20')
  variable_name <- deparse(substitute(variable_name))

  req_url <- paste0(req_url,
                    '&filter_column=', variable_name,
                    '&filter_value=',  variable_value_clean)

  return(req_url)
}
