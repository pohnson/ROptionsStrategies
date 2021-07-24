#' @export
#' @importFrom magrittr %>%
#' @import httr

wheel_selector <- function(
  ticker = c('AAPL','GOOG'),
  expiration_date = Sys.Date(),
  consumer_key = NA
){

  #Check if ticker input is in a correct format
  if(class(ticker) != 'character'){
    print('x')
    stop('The input is not in a correct format. Please input either in vector or data frame with $ specifying a ticker column.')
  } # End of ticker check if

  #Check if date is in a correct format


  print('The code is run until the end.')
} # End of function
