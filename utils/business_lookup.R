#==================================================================
# Script code and functions for fetching Yelp business lookup data.
# Importing and Utilizing the Yelp API. Code based on:
# https://billpetti.github.io/2017-12-23-use-yelp-api-r-rstats/
# All credits go to Jenny Bryan and Bill Petti.

# Could use more columns for richer data.
#==================================================================
require(tidyverse)
require(httr)

# Client ID and API Key:
# client_id <- YOUR ID
# api_key <- YOUR KEY

# Fetching Yelp Business Lookup Data; returns a data frame.
yelp_business_lookup <- function(business_id) {
  
  yelp <- "https://api.yelp.com"
  url <- modify_url(yelp, path = c("v3", "businesses", business_id))
  res <- GET(url, add_headers('Authorization' = paste("bearer", api_key)))
  results <- content(res)
  hourdata <- as.data.frame(results$hours)
  
  df <- data_frame(id = results$id,
                   name = results$name,
                   phone = results$phone,
                   rating = results$rating,
                   review_count = results$review_count, 
                   price = results$price,
                   latitude = results$coordinates$latitude, 
                   longitude = results$coordinates$longitude,
                   address1 = results$location$address1,
                   is_closed = results$is_closed,
                   city = results$location$city,
                   state = results$location$state)
  
  return (df)
}

# Fetching Yelp Business Hours Data; returns a data frame.
# Modified version of business_lookup() to return business hours as a data frame.
business_hours <- function(business_id) {
  
  yelp <- "https://api.yelp.com"
  url <- modify_url(yelp, path = c("v3", "businesses", business_id))
  res <- GET(url, add_headers('Authorization' = paste("bearer", api_key)))
  results <- content(res)
  
  return (as.data.frame(results$hours))
}
