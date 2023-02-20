## code to prepare `scraped_csv_list` dataset goes here

devtools::load_all()
scraped_csv_list <- scrape_available_csvs()

usethis::use_data(scraped_csv_list, overwrite = TRUE, internal = TRUE)
