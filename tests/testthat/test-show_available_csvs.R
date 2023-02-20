test_that("show_available_csvs() works", {
  skip_on_cran()
  skip_if_offline()
  check_statsnz_connection()

  res <- show_available_csvs(refresh = TRUE)
  expect_s3_class(res, "tbl_df")
  expect_length(res, 4)
  expect_gt(nrow(res), 90)
  expect_true(all(purrr::map_lgl(res, is.character)))
})
