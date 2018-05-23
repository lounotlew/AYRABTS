#==================================================================
# Script code and functions for fetching Yelp business review data.
# Importing and Utilizing the Yelp API. Code written by:
# https://github.com/richierocks/yelp/blob/master/R/reviews.R
# All credits go to richierocks.
#==================================================================
require(assertive.types)
require(httr)
require(tibble)

# Client ID and API Key:
# client_id <- YOUR ID
# api_key <- YOUR KEY

# Supported locales for Yelp reviews (param LOCALES for Yelp API).
SUPPORTED_LOCALES <- c("cs_CZ", "da_DK", "de_AT", "de_CH", "de_DE", "en_AU",
                       "en_BE", "en_CA", "en_CH", "en_GB", "en_HK", "en_IE", "en_MY", "en_NZ",
                       "en_PH", "en_SG", "en_US", "es_AR", "es_CL", "es_ES", "es_MX", "fi_FI",
                       "fil_PH", "fr_BE", "fr_CA", "fr_CH", "fr_FR", "it_CH", "it_IT", "ja_JP",
                       "ms_MY", "nb_NO", "nl_BE", "nl_NL", "pl_PL", "pt_BR", "pt_PT", "sv_FI",
                       "sv_SE", "tr_TR", "zh_HK", "zh_TW"
)

null2empty <- function(x) {
  if(is.null(x)) "" else x
}

# Fetching Yelp Business Reviews Data; returns a data frame.
business_reviews <- function(business_id, locale = "en_US",
                    access_token = api_key) {
  if(is.na(access_token)) {
    stop("No Yelp API access token was found. See ?get_access_token.")
  }
  assert_is_a_string(business_id)
  locale <- match.arg(locale, SUPPORTED_LOCALES)
  endpoint <- sprintf(
    "https://api.yelp.com/v3/businesses/%s/reviews",
    business_id
  )
  response <- GET(
    endpoint,
    config = add_headers(Authorization = paste("bearer", access_token)),
    query = list(locale = locale)
  )
  stop_for_status(response)
  results <- content(response, as = "parsed")
  map_df(
    results$reviews,
    function(review) {
      data_frame(
        rating = review$rating,
        text = review$text,
        time_created = review$time_created,
        url = review$url,
        user_image_url = null2empty(review$user$image_url),
        user_name = review$user$name
      )
    }
  )
}
