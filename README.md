
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ROptionsStrategies

<!-- badges: start -->

[![Travis build
status](https://travis-ci.com/pohnson/ROptionsStrategies.svg?branch=main)](https://travis-ci.com/pohnson/ROptionsStrategies)
<!-- badges: end -->

The goal of ROptionsStrategies is to utilize the flexibilities of R and
its vast libraries to analyze options data provided through TDAmeritrade
API. Although the only available strategy is short put (The Wheel,)
strategies such as spread, iron condor, and butterfly are in the
development roadmap.

## Installation

You can install the released version of ROptionsStrategies from
[CRAN](https://CRAN.R-project.org) WHEN IT IS AVAILABLE with:

``` r
#install.packages("ROptionsStrategies") Not available yet
```

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("pohnson/ROptionsStrategies")
```

## Authentication

The most important data point in this package is the TDAmeritrade’s
Consumer Key. If you haven’t had one yet, please follow this thorough
guideline to obtain one:
<a href="https://www.reddit.com/r/algotrading/comments/c81vzq/td_ameritrade_api_access_2019_guide/">link</a>.

## Wheel\_Extractor Function

Now, let’s assume that you already have one and save it in a csv file.
We then can read it like this.

``` r
library(ROptionsStrategies)
library(tidyverse)

consumer_key <- read_csv("consumer_key.csv") %>% as.character()
```

Let’s assume that you can only execute one Wheel trade and wonder if the
option should be AAPL, AMD, or XLF. You can use to get underlying data
as follows:
