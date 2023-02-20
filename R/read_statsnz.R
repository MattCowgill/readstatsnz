#' Read CSVs from StatsNZ
#'
#' @description
#' This function downloads and imports CSVs from StatsNZ
#' @param name A name of a StatsNZ CSV or ZIP, or a unique fragment thereof
#' @param subname Used when `name` refers to a ZIP. `subname` is the name,
#' or a unique fragment thereof, of a file within the ZIP.
#' @param path Directory in which to save downloaded file(s)
#' @examples
#'
#' read_statsnz("national-labour-force-projections")
#'
#' read_statsnz("labour-market-statistics", subname = "lci")
#' @export

read_statsnz <- function(name,
                         subname = NULL,
                         path = tempdir()) {

  stopifnot(length(name) == 1)

  url <- get_url(name)

  stopifnot(length(url) == 1)

  filename <- file.path(path, tolower(basename(url)))

  ext <- tools::file_ext(filename)

  utils::download.file(url, filename)

  if (ext == "zip") {

    unzip_dir <- file.path(tempdir(),
                           tools::file_path_sans_ext(basename(filename)))

    if (fs::dir_exists(unzip_dir)) {
      fs::dir_delete(unzip_dir)
    }

    fs::dir_create(unzip_dir)

    utils::unzip(filename,
                 overwrite = TRUE,
                 junkpaths = TRUE,
                 exdir = unzip_dir)

    post_unzip_files <- list.files(path,
                                   pattern = "\\.csv",
                                         full.names = TRUE,
                                         include.dirs = FALSE)

    if (is.null(subname)) {
      stop(name, " is a .zip file.\nSpecify `subname` to choose which file to ",
           "load.\nOptions are: ",
           paste0(tools::file_path_sans_ext(basename(post_unzip_files)),
                  collapse = "; "), ".")
    } else {
      filename <- post_unzip_files[grepl(subname, post_unzip_files,
                                         ignore.case = TRUE)]
    }

  }


  readr::read_csv(filename,
                  show_col_types = FALSE,
                  lazy = FALSE)
}

get_url <- function(name) {
  avail <- show_available_csvs()
  avail %>%
    dplyr::filter(grepl(.env$name, .data$name)) %>%
    dplyr::pull(.data$url)
}


