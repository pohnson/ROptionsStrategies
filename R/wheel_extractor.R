#' @export
#' @importFrom magrittr %>%
#' @import httr

wheel_extractor <- function(
  ticker = c('AAPL','GOOG'),
  expiration_date = Sys.Date(),
  consumer_key = NULL
){

  #Check if ticker input is in a correct format
  if(class(ticker) != 'character'){
    stop('The input is not in a correct format. Please input either in vector or data frame with $ specifying a ticker column.')
  } # End of ticker check if

  #Check if date is in a correct format
  if(class(try(as.Date(expiration_date))) == 'try-error'){
    stop('Incorrect input expiration date format. Please input expiration date in YYYY-MM-DD format.')
  }

  #Check if consumer key is blank
  if(is.na(consumer_key) == TRUE || is.null(consumer_key) == TRUE){
    stop('Please input consumer key from TDAmertirade Developer.')
  }

  print(expiration_date)
  print('The code is run until the end.')
} # End of function
