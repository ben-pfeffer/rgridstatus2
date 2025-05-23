% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_gridstatus_dataset.R
\name{get_gridstatus_dataset}
\alias{get_gridstatus_dataset}
\title{Download dataset from API}
\usage{
get_gridstatus_dataset(
  wh_dataset,
  start_time = Sys.Date() - 5,
  end_time = Sys.Date(),
  limit = 100,
  timezone = "market",
  location = "",
  location_type = "",
  resample_frequency = "",
  respondent = "",
  tac_area_name = ""
)
}
\arguments{
\item{wh_dataset}{Name of dataset to download. Default is "caiso_fuel_mix"}

\item{start_time}{Start time. Default is 5 days ago.}

\item{end_time}{End time. Default is today's date.}

\item{limit}{Number of requests to return. Default is 100.}

\item{timezone}{Default is market, which returns times in the market's local time}

\item{location}{filter term for the data's location column}

\item{location_type}{filter term for the data's location_type column}

\item{resample_frequency}{resample the data to a lower frequency}

\item{respondent}{for specifying EIA fuel mix zone}

\item{tac_area_name}{for specifying CAISO Zonal load zone (any zone in WECC)}
}
\value{
df: Dataframe of requested dataset
}
\description{
Download dataset from API
}
