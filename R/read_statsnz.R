#' Read CSVs from StatsNZ
#'
#' @description
#' This function downloads and imports CSVs from StatsNZ
#' @param name A name of a StatsNZ CSV, or a unique fragment thereof
#' @param path Directory in which to save downloaded file(s)
#' @examples
#'
#' read_statsnz("national-labour-force-projections")
#' @export

read_statsnz <- function(name,
                         path = tempdir()) {

  stopifnot(length(name) == 1)

  url <- get_url(name)

  stopifnot(length(url) == 1)

  filename <- file.path(path, tolower(basename(url)))

  download.file(url, filename)

  readr::read_csv(filename)
}

get_url <- function(name) {
  avail <- show_available_csvs()
  avail %>%
    dplyr::filter(grepl(.env$name, .data$name)) %>%
    dplyr::pull(.data$url)
}


