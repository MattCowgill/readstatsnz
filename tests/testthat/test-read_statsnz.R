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
  check_df(read_statsnz("labour-market-statistics", "lci"))
})
