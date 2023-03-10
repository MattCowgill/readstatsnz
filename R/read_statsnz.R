#' Read CSVs from StatsNZ
#'
#' @description
#' `r lifecycle::badge("experimental")`
#' This function downloads and imports CSVs from StatsNZ
#' @param name A name of a StatsNZ CSV or ZIP, or a unique fragment thereof
#' @param subname Used when `name` refers to a ZIP that contains more than one
#' CSV. `subname` is the name,
#' or a unique fragment thereof, of a CSV file within the ZIP.
#' @param path Directory in which to save downloaded file(s)
#' @param check_local Logical; `TRUE` by default. If `TRUE`, `read_statsnz()`
#' will look in `path` for a file with the same filename as the one you've
#' requested. If it exists, it will be loaded. If not, the file will be
#' downloaded from StatsNZ. If `FALSE`, the file will always be
#' downloaded from StatsNZ.
#' @examples
#' \dontrun{
#' read_statsnz("national-labour-force-projections")
#'
#' read_statsnz("labour-market-statistics", subname = "lci")
#' }
#' @export

read_statsnz <- function(name,
                         subname = NULL,
                         path = tempdir(),
                         check_local = TRUE) {

  stopifnot(length(name) == 1)

  url <- get_url(name)

  stopifnot(length(url) == 1)

  if (!fs::dir_exists(path)) {
    fs::dir_create(path)
  }

  filename <- file.path(path, tolower(basename(url)))

  ext <- tools::file_ext(filename)

  if (isFALSE(check_local) || !file.exists(filename)) {
    utils::download.file(url, filename)
  }

  if (ext == "zip") {

    unzip_dir <- file.path(path,
                           tools::file_path_sans_ext(basename(filename)))

    if (!fs::dir_exists(unzip_dir)) {
      fs::dir_create(unzip_dir)
    }

    utils::unzip(filename,
                 overwrite = TRUE,
                 junkpaths = TRUE,
                 exdir = unzip_dir)

    post_unzip_files <- list.files(unzip_dir,
                                   pattern = "\\.csv",
                                         full.names = TRUE,
                                         include.dirs = FALSE)

    subname_required <- if (length(post_unzip_files) > 1) {
      TRUE
    } else {
      FALSE
    }

    if (subname_required && is.null(subname)) {
      stop(name, " is a .zip file.\nSpecify `subname` to choose which file to ",
           "load.\nOptions are: ",
           paste0(tools::file_path_sans_ext(basename(post_unzip_files)),
                  collapse = "; "), ".")
    }

    if (subname_required && !is.null(subname)) {
      filename <- post_unzip_files[grepl(subname, post_unzip_files,
                                         ignore.case = TRUE)]
    }

    if (!subname_required) {
      filename <- post_unzip_files
    }

  }

  stopifnot(length(filename) == 1)

  out <- readr::read_csv(filename,
                  show_col_types = FALSE,
                  lazy = FALSE) %>%
    janitor::clean_names()

  if ("data_value" %in% colnames(out)) {
    out <- out %>%
      dplyr::rename(value = "data_value")
  }

  return(out)
}

#' @noRd
#' @keywords internal
#' Given a `name`, return the URL(s) corresponding to that name
#' @param name A (unique fragment of) a release name. For possible release
#' names, see the `name` column of the dataframe returned by
#' `show_available_csvs()`.
#' @return A character vector of URL(s) corresponding to the name provided
#' @examples
#' get_url("economic-survey-of-manufacturing")
get_url <- function(name) {
  avail <- show_available_csvs()
  avail %>%
    dplyr::filter(grepl(.env$name, .data$name)) %>%
    dplyr::pull(.data$url)
}



