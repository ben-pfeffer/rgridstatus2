#' calculate_REC_prices
#' 
#' Builds the standard output Dashboard for Encompass runs
#' 
#' @param start_date the first day of data to pull
#' @param end_date the last day of data to pull. NOT INCLUSIVE! 
#' data from the end_date will NOT be pulled. Data from the day before will be
#' @param node_df a data frame with 2 columns, BA and Node. These correspond to 
#' the BA (ISO) and Gridstatus Node name for each node to download data for. 
#' Note that these are Case sensitive. Gridstatus usually requires ALL CAPS for 
#' node names. 
#' 
#' @return saves an excel file with outputs in the working directory, and
#' returns the wide-formatted results from the query
#' 
#' @export
#' 

pull_historical_lmps_nodal <- function(start_date, end_date, node_df) {
  
  # helper function to avoid 100,000 row gridstatus limit per API call
  calculate_expected_rows <- function(start_date, end_date, num_nodes) {
    num_days <- difftime(as.Date(end_date), as.Date(start_date))
    num_rows <- num_days * 24 * num_nodes
  }
  
  # function to download hourly LMPs for a given ISO between given dates
  download_historical_nodal <- function(start_date, end_date, node_list, ba) {
    
    if(calculate_expected_rows(start_date, end_date, length(node_list)) > 100000) {
      
      # find the round down halfway day between two dates
      halfway_date <- as_date(start_date) + floor((as_date(end_date) -
                                                     as_date(start_date)) / 2)
      
      d1 <- download_historical_nodal(start_date, halfway_date, node_list, ba)
      d2 <- download_historical_nodal(halfway_date, end_date, node_list, ba)
      d <- rbind(d1, d2)
    }
    else {
      
      num_days = difftime(as_date(end_date), as_date(start_date))
      
      # try to download data
      message(paste0('Downloading historical prices for ', toupper(ba), '...'))
      # message(paste0('iso = ', tolower(ba), '. location = ', node_list,
      #                '. limit = ', num_days *24*1.1, '. start_time = ', start_date,
      #                '. end_time = ', end_date))
      d <- try(get_da_prices_hourly(iso = tolower(ba),  location = node_list,
                                    limit = ceiling(num_days * length(node_list) * 24 * 1.1),
                                    start_time = start_date, end_time = end_date))
      
      # if download fails, try again once
      if (inherits(d, "try-error")) {
        message(paste0("Error downloading ", toupper(ba), , 
                       ' from ', start_date, ' to ',
                       end_date, '. Retrying...'))
        d <- try(get_da_prices_hourly(iso = tolower(ba),  location = node,
                                      limit = ceiling(num_days * length(node_list) * 24 * 1.1),
                                      start_time = start_date, end_time = end_date))
        
        # if download fails a second time, abort
        if (inherits(d, "try-error")) {
          message(paste0("Another Error downloading ", iso, '. Aborting Script.'))
        }
      }
      
      Sys.sleep(1) # pause to avoid overloading API limits
      
    }
    return(d)
  }
  
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
    
    if(tolower(iso) == 'isone') {
      tmp_clean <- df_raw %>%
        clean_up_raw_gridstatus()
      
      return(tmp_clean)
    }
    
    if(tolower(iso) == 'nyiso') {
      tmp_clean <- df_raw %>%
        clean_up_raw_gridstatus() 
      
      return(tmp_clean)
    }
    
    if(tolower(iso) == 'pjm') {
      tmp_clean <- df_raw %>%
        clean_up_raw_gridstatus()
      
      return(tmp_clean)
    }
    
    if(tolower(iso) == 'miso') {
      tmp_clean <- df_raw %>%
        clean_up_raw_gridstatus()
      
      return(tmp_clean)
    }
    
    
    if(tolower(iso) == 'spp') {
      tmp_clean <- df_raw %>%
        clean_up_raw_gridstatus()
      
      return(tmp_clean)
    }
    
    if(tolower(iso) == 'ercot') {
      tmp_clean <- df_raw %>%
        rename(lmp = spp) %>%
        clean_up_raw_gridstatus()
      
      return(tmp_clean)
    }
    
    if(tolower(iso) == 'caiso') {
      tmp_clean <- df_raw %>%
        clean_up_raw_gridstatus() 
      
      return(tmp_clean)
    }
  }
  
  hourly_lmps_nodal <- data.frame()
  for(ba in unique(node_df$BA)) {
    start_t <- Sys.time()
    
    ba_node_list <- node_df %>%
      filter(BA == ba)
    
    tmp <- download_historical_nodal(start_date, end_date, ba_node_list$Node, ba)
    tmp_clean <- clean_up_iso(tmp, iso = ba)
    hourly_lmps_nodal <- rbind(hourly_lmps_nodal, tmp_clean)
    
    end_t <- Sys.time()
    diff <- difftime(end_t, start_t, units = 'mins')
    message(paste('Finished downloading for', toupper(ba), 'in', round(diff,1),
                  'minutes'))
  }
  
  # format months and dates
  hourly_lmps_nodal <- hourly_lmps_nodal %>%
    mutate(interval_start_local = ymd_hms(interval_start_local),
           interval_end_local = ymd_hms(interval_end_local),
           year = year(interval_start_local),
           month = month(interval_start_local),
           day = day(interval_start_local),
           hour = hour(interval_start_local) + 1)
  
  # pivot to wide format
  hourly_lmps_wide <- hourly_lmps_nodal %>%
    select(-location_type) %>%
    tidyr::pivot_wider(names_from = location, values_from = lmp)
  
  # write outputs to excel file
  wb <- wb_workbook() %>%
    wb_add_worksheet('Prices Wide') %>%
    openxlsx2::wb_add_data(x = hourly_lmps_wide) %>%
    wb_add_worksheet('Prices Long') %>%
    openxlsx2::wb_add_data(x = hourly_lmps_nodal)
  
  wb_save(wb, paste0("Nodal Historical Prices " , start_date,
                     ' to ', end_date, ".xlsx"))
  
  return(hourly_lmps_wide)
  
}
