#================================================================
# Script code and functions for fetching Yelp business data.
# Importing and Utilizing the Yelp API. Code written by:
# https://billpetti.github.io/2017-12-23-use-yelp-api-r-rstats/
# All credits go to Jenny Bryan and Bill Petti.
#================================================================
require(tidyverse)
require(httr)

# Client ID and API Key:
# client_id <- YOUR ID
# api_key <- YOUR KEY

# Fetching Yelp Business Search Data; returns a data frame.
yelp_business_search <- function(term = NULL, location = NULL, 
                                 categories = NULL, radius = NULL, price=NULL,
                                 limit = 50, offset = 0, client_id = client_id, 
                                 api_key = api_key) {
  
  yelp <- "https://api.yelp.com"
  url <- modify_url(yelp, path = c("v3", "businesses", "search"),
                    query = list(term = term, location = location, limit = limit, price = price,
                                 radius = radius, categories = categories, offset = offset))
  res <- GET(url, add_headers('Authorization' = paste("bearer", api_key)))
  results <- content(res)
  
  yelp_httr_parse <- function(x) {
    
    parse_list <- list(id = x$id, 
                       name = x$name, 
                       rating = x$rating, 
                       review_count = x$review_count,
                       price = x$price,
                       latitude = x$coordinates$latitude, 
                       longitude = x$coordinates$longitude, 
                       address1 = x$location$address1, 
                       city = x$location$city, 
                       state = x$location$state, 
                       distance = x$distance)
    
    parse_list <- lapply(parse_list, FUN = function(x) ifelse(is.null(x), "", x))
    
    df <- data_frame(id=parse_list$id,
                     name=parse_list$name, 
                     rating = parse_list$rating, 
                     review_count = parse_list$review_count,
                     price = parse_list$price,
                     latitude=parse_list$latitude, 
                     longitude = parse_list$longitude, 
                     address1 = parse_list$address1, 
                     city = parse_list$city, 
                     state = parse_list$state, 
                     distance= parse_list$distance)
    df
  }
  results_list <- lapply(results$businesses, FUN = yelp_httr_parse)
  payload <- do.call("rbind", results_list)
  payload <- payload %>%
    filter(grepl(term, name))
  
  payload
}
