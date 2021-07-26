#' Find the Best Options for The Wheel Strategy
#'
#' Create a data frame with options information to determine
#' what options is the best for short put also known as "The Wheel" strategy
#'
#' @param data xx
#' @param visualization_type yy
#' @param include_in_the_money zz
#'
#' @return
#' A data frame object with 10 columns: bid
#' @export
#' @importFrom magrittr %>%
#' @importFrom ggplot2 ggplot geom_point
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


