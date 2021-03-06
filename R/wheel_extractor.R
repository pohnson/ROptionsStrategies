#' Find the Best Options for The Wheel Strategy
#'
#' Create a data frame with options information to determine
#' what options is the best for short put also known as "The Wheel" strategy
#'
#' @param ticker stock ticker
#' @param expiration_date an option expiration date
#' @param consumer_key Consumer Key from TDAmeritrade Developer
#' @param sleep_second Sleep in second before making a new API call
#'
#' @return
#' A data frame object with 10 columns: bid, delta, strikePrice, inTheMoney, ticker, prob_otm,
#' cast_inflow, invested_capital, return_on_risk, and expiration_date. You can inspect the result by yourself or use wheel_visualizer().
#'
#' @examples
#' #You want to know what strike price from AAPL, AMZN, and TSLA whose
#' #expiration date is Dec 31, 2021 has the highest return on risk.
#' #You'd input the parameters as follows:
#'
#' #result <- wheel_extractor(
#' #      ticker = c('AAPL', 'AMZN', 'TSLA'),
#' #      expiration_date = '2021-12-31',
#' #      consumer_key = 'Your TDA API Key',
#' #      sleep_second = 1 #or 0 if you want
#' # )
#'
#' #If you have many stocks that you want to know you can simply create a data frame and use $.
#'
#' ###### First create a data frame #####
#' candidates <- data.frame(ticker = c('AAPL', 'AMZN', 'TSLA', 'GOOG'))
#'
#' ###### Then use $ #####
#' #result <- wheel_extractor(
#' #      ticker = candidates$ticker
#' #      expiration_date = '2021-12-31',
#' #      consumer_key = 'xxx',
#' #      sleep_second = 1 #or 0 if you want
#' # )
#'
#' @references
#' If you haven't created a free TDAmeritrde API Key, please follow steps from this website https://www.reddit.com/r/algotrading/comments/c81vzq/td_ameritrade_api_access_2019_guide/
#'
#' @seealso
#' Execute ?wheel_visualizer() on how to visualize the resulting data frame
#' @export
#' @importFrom magrittr %>%
#' @import httr
#' @importFrom rlang .data


wheel_extractor <- function(
  ticker = c('AAPL','GOOG'),
  expiration_date = Sys.Date(),
  consumer_key = NULL,
  sleep_second = 1
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
    url_3 <- '&contractType=PUT&includeQuotes=TRUE&strategy=ANALYTICAL&range=ALL&fromDate='
    url_from_4 <- expiration_date
    url_5 <- '&toDate='
    url_to_6 <- expiration_date
    url_final <- paste(url_1, url_api_key_1.1, url_1.2, url_stock_2, url_3, url_from_4, url_5, url_to_6, sep = '')

    print(
      paste(
        'Requesting data for',
        url_stock_2,
        sep = ' '
      )
    )

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
    temp_data_2 <- httr::content(temp_data)

    ##### Extracting Data from List #####
    temp_container_2 <- data.frame(NULL)
    if(temp_data_2[[2]] == 'SUCCESS'){

      temp_data_3 <- temp_data_2[c('putExpDateMap')]

      for(loop_b in 1:length(temp_data_3)){
        y <- list()

        for(loop_c in 1:length(temp_data_3[[loop_b]])){ #at date time level

          for(loop_d in 1:length(temp_data_3[[loop_b]][[loop_c]])){ #at strike price level
            y <- append(
              y,
              temp_data_3[[loop_b]][[loop_c]][[loop_d]] #data at strike level
            )

          } #End of loop_d

          ##### Get Only Desired Columns #####
          y_2 <- lapply(y, helper_list_to_select)

          y_3 <- data.table::rbindlist(y_2, fill = T) %>%
            dplyr::mutate(ticker = temp_data_2$symbol)

        } # End of loop_c

        #Combine Data from Each Expiration of a Given Stock
        temp_container_2 <- rbind(temp_container_2, y_3)

      }# End of loop_b

    }# End If Success

    #Combine Data from Different Stocks
    temp_container <- rbind(temp_container, temp_container_2)

    #Sleep to make sure that TDAmeritrade will not disconnect due to too many requests
    Sys.sleep(sleep_second)

  } #End of loop_a
  print('Finished requesting data from TDAmeritrade.')

  temp_container_3 <- temp_container %>%
    dplyr::mutate(
      prob_otm = 1 + .data$delta,
      cash_inflow = .data$bid * 100,
      invested_capital = .data$strikePrice*100,
      return_on_risk = (.data$bid*100)/.data$invested_capital,
      expiration_date = expiration_date
    )

  return(data.frame(temp_container_3))

} # End of function

helper_list_to_select <- function(x){
  return(
    x[c('bid', 'delta', 'strikePrice', 'inTheMoney')]
  )
}

