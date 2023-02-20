#' List CSVs available to download from the StatsNZ website
#' @description
#' `r lifecycle::badge("experimental")`
#' @param refresh Logical; `TRUE` by default. If `TRUE`, a current list of
#' available CSVs will be scraped from the StatsNZ website. If `FALSE`, a
#' cached internal list of CSVs will be returned.
#'
#' @return a data.frame (tibble) containing three columns: the `title`,
#' `name`, `url`
#' and `ext` (file extension) for a range of CSVs available to download from
#' StatsNZ.
#'
#' @importFrom rlang .data .env
#' @examples
#' show_available_csvs()
#' @export

show_available_csvs <- function(refresh = TRUE) {

  stopifnot(is.logical(refresh))

  if (isFALSE(refresh)) {
    return(scraped_csv_list)
  }

  is_online <- check_statsnz_connection()

  if (isFALSE(is_online)) {
    warning("Could not access the StatsNZ website, returning a cached directory of CSVs")
    return(scraped_csv_list)
  } else {
    return(scrape_available_csvs())
  }

}

scrape_available_csvs <- function() {
  csv_list_url <- "https://www.stats.govt.nz/large-datasets/csv-files-for-download"

  page <- rvest::read_html(csv_list_url)

  js <- page %>%
    rvest::html_elements("#pageViewData") %>%
    rvest::html_attr("data-value") %>%
    jsonlite::fromJSON()

  tib <- js %>%
    purrr::pluck("PageBlocks") %>%
    purrr::pluck("BlockDocuments") %>%
    dplyr::bind_rows() %>%
    dplyr::select(-"DocumentPreviewImage") %>%
    dplyr::as_tibble()

  tib %>%
    dplyr::select(title = "Title",
                  name = "Name",
                  url = "DocumentLink",
                  ext = "DocumentExtension") %>%
    dplyr::mutate(url = paste0("https://www.stats.govt.nz", .data$url),
                  name = tolower(.data$name))
}


