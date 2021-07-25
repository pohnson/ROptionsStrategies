#' Find the Best Options for The Wheel Strategy
#'
#' Create a data frame with options information to determine
#' what options is the best for short put also known as "The Wheel" strategy
#'
#' @param data xx
#' @param visualization_type yy
#'
#' @return
#' A data frame object with 10 columns: bid
#' @export
#' @importFrom magrittr %>%
#' @importFrom ggplot2 ggplot geom_point
#'
#'

wheel_visualizer <- function(
data = NULL,
visualization_type = c('ggplot_histogram', 'plotly_histogram')
){
  ##### Check if input data frame has necessary columns #####
  if(
    sum(
      c('bid','delta','xxx') %in% names(data)
    ) != 3
  ){
    stop('The input data frame does not have required columns: strikePrice, inTheMoney, ticker, prob_otm, cash_inflow, invested_capital, and return_on_risk')
  }
  print('y')


} #End wheel_visualizer function


