#' append to URL for API data request
#' @param variable_name name of the filter variable
#' @param req_url the url to be appended to
#' @export
#'

append_url <- function(variable_name, req_url = req_url) {

  if(length(variable_name) == 1) {
    variable_value_clean <- stringr::str_replace_all(variable_name, ' ', '%20')
    variable_name <- deparse(substitute(variable_name))

    req_url <- paste0(req_url,
                      '&filter_column=', variable_name,
                      '&filter_value=',  variable_value_clean)
    }

  else if(length(variable_name) > 1) {
    variable_value_clean <- stringr::str_replace_all(variable_name, ' ', '%20')
    variable_name <- deparse(substitute(variable_name))
    filter_operator <- 'in'

    req_url <- paste0(req_url,
                      '&filter_column=', variable_name,
                      '&filter_operator=', filter_operator,
                      '&filter_value=',  paste0(variable_value_clean, collapse = ','))
  }


  return(req_url)
}
