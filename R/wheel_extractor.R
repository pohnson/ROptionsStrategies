#' @export
#' @importFrom magrittr %>%
#' @import httr

wheel_extractor <- function(
  ticker = c('aapl','goog'),
  expiration_date = Sys.Date(),
  consumer_key = NULL
){

  #Check if ticker input is in a correct format
  if(class(ticker) != 'character'){
    stop('The input is not in a correct format. Please input either in vector or data frame with $ specifying a ticker column.')
  } # End of ticker check if


  #Check if date is more than 1
  if(length(expiration_date) > 1){
    stop('Please only input one expiration date')
  }

  #Check if date is in a correct format
  if(class(try(as.Date(expiration_date))) == 'try-error'){
    stop('Incorrect input expiration date format. Please input expiration date in YYYY-MM-DD format.')
  }

  #Check if consumer key is blank
  if(is.na(consumer_key) == TRUE || is.null(consumer_key) == TRUE){
    stop('Please input consumer key from TDAmertirade Developer.')
  }

  #Convert ticker to upper case
  ticker <- toupper(ticker)

  ##### Start the Loop to Extract Data #####
  temp_container <- data.frame(NULL)
  for(loop_a in 1:length(ticker)){
    url_1 <- 'https://api.tdameritrade.com/v1/marketdata/chains?apikey='
    url_api_key_1.1 <- consumer_key
    url_1.2 <- '&symbol='
    url_stock_2 <- ticker[loop_a]
    url_3 <- '&contractType=PUT&includeQuotes=TRUE&strategy=ANALYTICAL&range=OTM&fromDate='
    url_from_4 <- expiration_date
    url_5 <- '&toDate='
    url_to_6 <- expiration_date
    url_final <- paste(url_1, url_api_key_1.1, url_1.2, url_stock_2, url_3, url_from_4, url_5, url_to_6, sep = '')

    print(url_final)

    ##### Request data from TDA #####
    temp_data <- try(
      httr::GET(
        url = url_final
      )
    )

    ##### Check if the result has HTTP Code 200 #####
    if(temp_data[['status_code']] != 200){
      stop(
        'The error code is ', temp_data[['status_code']], '.\n ',
        'Error Code 400 indicates an error message indicating the caller must pass a non null value in the parameter.\n',
        'Error Code 401 indicates unauthorized.\n',
        'Error Code 403 indicates forbidden.\n',
        'Error Code 404 indicates optionchain for the symbol was not found.\n',
        'Error Code 500 indicates internal error in the service.'
      )
    } #End Check for Status Code

    ##### Extract Content #####
    temp_data_2 <<- httr::content(temp_data)

  } #End of loop_a

  print('The code is run until the end.')
  return(temp_data_2)

} # End of function
