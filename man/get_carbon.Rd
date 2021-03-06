% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/carbon.R
\name{get_carbon}
\alias{get_carbon}
\title{Download and plot essential climate data}
\usage{
get_carbon(use_cache = TRUE)
}
\arguments{
\item{use_cache}{(boolean) Return cached data if available, defaults to TRUE. Use FALSE to fetch updated data.}
}
\value{
Invisibly returns a tibble with the monthly carbon dioxide series
}
\description{
Retrieves atmospheric carbon dioxide measurements from National Oceanic and Atmospheric Administration
Earth System Research Laboratories monitoring laboratory in Mauna Loa, Hawaii.
\url{https://www.esrl.noaa.gov/gmd/ccgg/trends/data.html}
}
\details{
\code{get_carbon} invisibly returns a tibble with NOAA's monthly average carbon dioxide measurement.
The returned object includes date, year, month, average, interpolated, and trend columns.
Average and interpolated are basically identical with interpolated filling in a very small number of missing months.
Trend is NOAA's published trend.  Please refer to above website for details.
}
\examples{
\dontrun{
# Fetch from cache if available:
maunaloa <- get_carbon()
#
# Force cache refresh:
maunaloa <- get_carbon(use_cache=FALSE)
#
# Review cache contents and last update dates:
hockeystick_cache_details()
#
# Plot output using package's built-in ggplot2 settings
plot_carbon(maunaloa) }

}
\references{
Dr. Pieter Tans, NOAA/GML \url{https://www.esrl.noaa.gov/gmd/ccgg/trends/} and Dr. Ralph Keeling, Scripps Institution of Oceanography \url{https://scrippsco2.ucsd.edu/}.

C.D. Keeling, R.B. Bacastow, A.E. Bainbridge, C.A. Ekdahl, P.R. Guenther, and L.S. Waterman, (1976), Atmospheric carbon dioxide variations at Mauna Loa Observatory, Hawaii, \emph{Tellus}, vol. 28, 538-551
}
\author{
Hernando Cortina, \email{hch@alum.mit.edu}
}
