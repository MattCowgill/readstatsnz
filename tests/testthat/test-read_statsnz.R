test_that("read_statsnz() works", {

  skip_on_cran()
  skip_if_offline()
  check_statsnz_connection()

  check_df <- function(df) {
    expect_s3_class(df, "tbl_df")
    expect_gt(nrow(df), 0)
  }

  check_df(read_statsnz("national-labour-force-projections"))
  expect_error(read_statsnz("labour-market-statistics"))

  df_remote <- read_statsnz("labour-market-statistics", "lci",
                        check_local = FALSE)

  df_local <- read_statsnz("labour-market-statistics", "lci",
                           check_local = TRUE)

  check_df(df_remote)
  check_df(df_local)
  expect_identical(df_remote, df_local)


  random_dir <- file.path(tempdir(),
                          paste0(sample(letters, 10), collapse = ""))

  on.exit(unlink(random_dir))

  check_df(read_statsnz("business-financial-data", check_local = F,
                        path = random_dir))
})
