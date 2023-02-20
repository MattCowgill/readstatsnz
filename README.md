
<!-- README.md is generated from README.Rmd. Please edit that file -->

# readstatsnz

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/MattCowgill/readstatsnz/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/MattCowgill/readstatsnz/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of {readstatsnz} is to make it easy to download and import data
from StatsNZ into R.

The package enables easy access to [the CSVs listed on this
page](https://www.stats.govt.nz/large-datasets/csv-files-for-download).

## Installation

You can install the development version of readstatsnz from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("MattCowgill/readstatsnz")
```

## Example

The package enables easy access to [the CSVs listed on this
page](https://www.stats.govt.nz/large-datasets/csv-files-for-download).

Some StatsNZ files are simple CSVs, which can be loaded like this:

``` r
library(readstatsnz)

read_statsnz("national-labour-force-projections")
#> # A tibble: 276 × 8
#>     year Characteristic   P05   P25   P50   P75   P95 sortorder
#>    <dbl> <chr>          <dbl> <dbl> <dbl> <dbl> <dbl>     <dbl>
#>  1  2020 totlf           2860  2886  2904  2922  2950         1
#>  2  2023 totlf           2858  2916  2963  3011  3073         1
#>  3  2028 totlf           2874  3016  3110  3208  3356         1
#>  4  2033 totlf           2899  3099  3239  3387  3598         1
#>  5  2038 totlf           2941  3175  3343  3528  3810         1
#>  6  2043 totlf           2950  3226  3434  3656  4012         1
#>  7  2048 totlf           2914  3285  3515  3775  4143         1
#>  8  2053 totlf           2897  3313  3578  3876  4280         1
#>  9  2058 totlf           2882  3318  3621  3933  4424         1
#> 10  2063 totlf           2823  3315  3654  3994  4557         1
#> # … with 266 more rows
```

Some are ZIP files, in which case you need to supply a `subname`
argument:

``` r
read_statsnz("labour-market-statistics", subname = "lci")
#> # A tibble: 27,446 × 13
#>    Series_re…¹ Period Data_…² STATUS UNITS MAGNT…³ Subject Group Serie…⁴ Serie…⁵
#>    <chr>        <dbl>   <dbl> <chr>  <chr>   <dbl> <chr>   <chr> <chr>   <chr>  
#>  1 LCIQ.SD53Z9  1992.    610. FINAL  index       0 Labour… All … All Se… All Sa…
#>  2 LCIQ.SD53Z9  1993.    612. FINAL  index       0 Labour… All … All Se… All Sa…
#>  3 LCIQ.SD53Z9  1993.    614. FINAL  index       0 Labour… All … All Se… All Sa…
#>  4 LCIQ.SD53Z9  1993.    615. FINAL  index       0 Labour… All … All Se… All Sa…
#>  5 LCIQ.SD53Z9  1993.    617. FINAL  index       0 Labour… All … All Se… All Sa…
#>  6 LCIQ.SD53Z9  1994.    618. FINAL  index       0 Labour… All … All Se… All Sa…
#>  7 LCIQ.SD53Z9  1994.    620. FINAL  index       0 Labour… All … All Se… All Sa…
#>  8 LCIQ.SD53Z9  1994.    623. FINAL  index       0 Labour… All … All Se… All Sa…
#>  9 LCIQ.SD53Z9  1994.    624. FINAL  index       0 Labour… All … All Se… All Sa…
#> 10 LCIQ.SD53Z9  1995.    626. FINAL  index       0 Labour… All … All Se… All Sa…
#> # … with 27,436 more rows, 3 more variables: Series_title_3 <chr>,
#> #   Series_title_4 <chr>, Series_title_5 <chr>, and abbreviated variable names
#> #   ¹​Series_reference, ²​Data_value, ³​MAGNTUDE, ⁴​Series_title_1, ⁵​Series_title_2
```

To see the available files, use:

``` r
show_available_csvs()
#> # A tibble: 100 × 4
#>    title                                                       name  url   ext  
#>    <chr>                                                       <chr> <chr> <chr>
#>  1 Annual enterprise survey: 2021 financial year (provisional… annu… http… csv  
#>  2 Annual enterprise survey: 2021 financial year (provisional… annu… http… csv  
#>  3 Business employment data: September 2022 quarter – CSV      busi… http… zip  
#>  4 Business financial data: September 2022 quarter – CSV       busi… http… zip  
#>  5 Business operations survey: 2021 – The transition to low e… bos2… http… csv  
#>  6 Business price indexes: September 2022 quarter – CSV        busi… http… zip  
#>  7 Economic survey of manufacturing: September 2022 quarter –… econ… http… zip  
#>  8 Electronic card transactions: December 2022 – CSV           elec… http… zip  
#>  9 International trade: September 2022 quarter – CSV           inte… http… zip  
#> 10 Geographic units, by industry and statistical area: 2000–2… csv-… http… zip  
#> # … with 90 more rows
```

## Lifecycle

This package is
[experimental](https://lifecycle.r-lib.org/articles/stages.html#experimental).
The StatsNZ website may, at any time, change in such a way that the
package stops working. The package is in an early stage of development,
so functions (including function names and/or arguments) may change.

## Roadmap

In future, this package could house functions to query the StatsNZ API.
I’d welcome contributions. Please open an issue before commencing.

## Disclaimer

This package is provided as-is. All data is provided under the terms set
out on the StatsNZ website. This package is not in any way affiliated
with or endorsed by StatsNZ.
