#' Download and plot essential climate data
#'
#' Retrieves Arctic or Antarctic annual Sea Ice Index (in million square km).
#' Source is the National Snow and Ice Data Center, defaults to Arctic (Northern Hemisphere) July sea ice extent.
#' \url{https://nsidc.org/data/seaice_index/archives} \cr \cr
#'
#' @name get_seaice
#' @param pole 'N' for Arctic or 'S' for Antarctic
#' @param month 2-digit month to retrieve sea ice for, defaults to '07' (July)
#' @param measure Must be 'extent' or 'area', defaults to 'extent'. Please see terminology link in references for details.
#' @param use_cache (boolean) Return cached data if available, defaults to TRUE. Use FALSE to fetch updated data, or to change pole or month in cache.
#'
#' @return Invisibly returns a tibble with the annual series of monthly Sea Ice Index since 1979 (in million square km).
#'
#' `get_seaice` invisibly returns a tibble with annual series of monthly Sea Ice Index since 1979 (in million square km).
#'
#' User may select Arctic or Antarctic sea ice extent or area (in millions of square kilometers) by year for a given month, specified by argument `month`.
#' Defaults to Arctic July sea ice extent.  \url{https://nsidc.org/arcticseaicenews/faq/#area_extent}
#'
#' @importFrom lubridate ymd ceiling_date
#' @importFrom utils download.file read.csv
#'
#' @examples
#' \dontrun{
#' # Fetch sea ice from cache if available:
#' seaice <- get_seaice()
#' #
#' # Force cache refresh:
#' seaice <- get_seaice(use_cache = FALSE)
#' # change region and month
#' seaice <- get_seaice(pole='S', month='09', use_cache = FALSE)
#' #
#' # Review cache contents and last update dates:
#' hockeystick_cache_details()
#' #
#' # Plot output using package's built-in ggplot2 settings
#' plot_seaice(seaice) }
#'
#' @author Hernando Cortina, \email{hch@@alum.mit.edu}
#' @references
#' \itemize{
#' \item NSIDC Data Archive: \url{https://nsidc.org/data/seaice_index/archives}
#' \item All About Sea Ice: \url{https://nsidc.org/cryosphere/seaice/index.html}
#' \item Sea Ice terminology: \url{https://nsidc.org/cryosphere/seaice/data/terminology.html}
#'  }
#'
#' @export

get_seaice <- function(pole='N', month='07', measure='extent', use_cache = TRUE) {

  if (pole!='S' & pole!='N') stop("pole must be 'N' or 'S'")
  if (!(month %in% c('01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'))) stop("Month must be one of '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12' ")
  if (measure!='extent' & measure!='area') stop("measure must be 'extent' or 'area'")

  hs_path <- rappdirs::user_cache_dir("hockeystick")

  if (use_cache) {
    message('Please set use_cache=FALSE if you are changing pole, month, or measure from last cached data.')
    if (file.exists(file.path(hs_path,'seaice.rds'))) return(invisible(readRDS((file.path(hs_path,'seaice.rds')))))
    }

  if (pole=='N') file_url <- 'ftp://sidads.colorado.edu/DATASETS/NOAA/G02135/north/monthly/data/'
  if (pole=='S') file_url <- 'ftp://sidads.colorado.edu/DATASETS/NOAA/G02135/south/monthly/data/'

  filename <- paste0(pole, '_', month, '_extent_v3.0.csv')

  dl <- tempfile()
  download.file(file.path(file_url, filename), dl)

  seaice <- utils::read.csv(dl, header = TRUE)
  seaice$date <- lubridate::ceiling_date(lubridate::ymd(paste(seaice$year, seaice$mo, '01', sep='-')), 'month')-1

  if (measure == 'extent') seaice <- seaice[,c('date', 'extent')] else seaice <- seaice[,c('date', 'area')]

  saveRDS(seaice, file.path(hs_path, 'seaice.rds'))

  invisible(seaice) }




#' Download and plot essential climate data
#'
#' Plots the Sea Ice Index data retrieved using `get_seaice()` with ggplot2. The output ggplot2 object may be further modified.
#'
#'
#' @name plot_seaice
#' @param dataset Name of the tibble generated by `get_seaice`, defaults to calling `get_seaice`
#' @param print (boolean) Display sea ice ggplot2 chart, defaults to TRUE. Use FALSE to not display chart.
#' @param title chart title, defaults to Arctic Sea Ice
#' @return Invisibly returns a ggplot2 object with Sea Ice Index chart
#'
#' @details `plot_seaice` invisibly returns a ggplot2 object with a pre-defined Sea Ice Index chart using data from `get_seaice`.
#' By default the chart is also displayed. Users may further modify the output ggplot2 chart.
#'
#' @import ggplot2
#' @importFrom lubridate ymd ceiling_date month
#'
#' @examples
#' \dontrun{
#' # Fetch sea ice data:
#' seaice <- get_seaice()
#' #
#' # Plot output using package's built-in ggplot2 defaults
#' plot_seaice(seaice)
#'
#' # Or just call plot_seaice(), which defaults to get_seaice() dataset
#' plot_seaice()
#'
#' p <- plot_seaice(seaice, print = FALSE)
#' p + ggplot2::labs(title='Shrinking Arctic Sea Ice') }
#'
#' @author Hernando Cortina, \email{hch@@alum.mit.edu}
#'
#' @export

plot_seaice <- function(dataset = get_seaice(), title='Arctic Sea Ice', print=TRUE) {

  subtitle <- paste0(as.character(lubridate::month(dataset[nrow(dataset),'date'], label=TRUE, abbr = F))," mean sea ice ", colnames(dataset)[2],". Linear regression in blue.")

  plot <-  ggplot(dataset, aes_string(x="date", y=colnames(dataset)[2])) +geom_line(size=1, color='firebrick1') +
    scale_x_date(name=NULL, breaks='5 years', date_labels='%Y', limits=c(ymd('1978-01-01'), ceiling_date(max(dataset$date), 'years'))) +
    scale_y_continuous(n.breaks = 6) + geom_smooth(method='lm', se=F, linetype=2, size=0.5) + theme_bw(base_size = 12) +
    labs(title=title,
         subtitle=subtitle, y=expression("Million km"^2),
         caption='Source: National Snow & Ice Data Center\nhttps://nsidc.org/data/seaice_index')

  if (print) suppressMessages( print(plot) )
  invisible(plot)
}
