#' Visualize Options with the Best Return on Risk
#'
#' This function will create a histogram plot for the resulting data frame from
#' the wheel_extractor() function.
#'
#' @param data A resulting data frame object from wheel_extractor() function.
#' @param visualization_type Currently only support ggplot2's ggplot_histogram.
#' @param include_in_the_money The Wheel generally employs on OTM options. But the data frame also includes ITM.
#'
#' @return
#' Ggplot2 histogram chart.
#'
#' @examples
#' #First let's create sample data frame
#' sample <- data.frame(
#'      strikePrice = c(50, 60, 70, 80),
#'      inTheMoney = c(FALSE, FALSE, FALSE, TRUE),
#'      ticker = c('AAPL', 'AAPL', 'TSLA', 'TSLA'),
#'      prob_otm = c(0.3, 0.4, 0.3, 0.4),
#'      cash_inflow = c(250, 400, 115, 220),
#'      invested_capital = c(5000, 6000, 7000, 8000),
#'      return_on_risk = c(0.05, 0.07, 0.02, 0.03)
#' )
#'
#' #Then use the function
#' wheel_visualizer(data = sample)
#'
#' @export
#' @import ggplot2
#' @importFrom magrittr %>%
#' @importFrom scales percent
#' @importFrom rlang .data

wheel_visualizer <- function(
data = NULL,
visualization_type = 'ggplot_histogram',
include_in_the_money = FALSE
){
  ##### Check if input data frame has necessary columns #####
  if(
    sum(
      c(
        'strikePrice', 'inTheMoney', 'ticker', 'prob_otm', 'cash_inflow',
        'invested_capital', 'return_on_risk'
      ) %in% names(data)
    ) < 7
  ){
    stop('The input data frame does not have required columns: strikePrice, inTheMoney, ticker, prob_otm, cash_inflow, invested_capital, and return_on_risk')
  } # End Check Column

  ##### Check if include_in_the_money is either T or F #####
  if(is.logical(include_in_the_money) == FALSE){
    stop('Include_In_The_Money value can only be either TRUE or FALSE.')
  }

  ##### Check if Visualization Type is Valid #####
  if(visualization_type != 'ggplot_histogram'){
    stop('Current function can only visualize histogram using GGPLOT2 function.')
  }

  ##### ITM Filtering #####
  if(include_in_the_money == FALSE){
    data_final <- data %>% dplyr::filter(.data$inTheMoney == FALSE)
  } else {
    data_final <- data
  }

  ##### Visualize #####
  if(visualization_type == 'ggplot_histogram'){
    data_final %>%
      dplyr::filter(
        .data$prob_otm > 0
      ) %>%
      ggplot2::ggplot(
        ggplot2::aes(y = .data$prob_otm, x = .data$return_on_risk, col = .data$ticker, label = .data$strikePrice)
      ) +
      geom_point() +
      ggplot2::scale_y_continuous(labels = scales::percent) +
      ggplot2::scale_x_continuous(labels = scales::percent) +
      ggplot2::xlab('Return on Risk') +
      ggplot2::ylab('Probablity OTM')
      #ggplot2::geom_text()
      #ggrepel::geom_label_repel(max.overlaps = 200)

  } #End If visualization_type

} #End wheel_visualizer function


