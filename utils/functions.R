#=================================================================
# Misc. functions for data processing/cleaning, input processing.
# Includes strings for displaying bug/app info, and misc. notes.
#=================================================================

# Takes in a character vector PRICE and maps its values to corresponding
# integers as string. '$' -> '1', '$$' -> '2', '$$$' -> '3', '$$$$' -> '4'.
# i.e. priceString(c('$', '$$', '$$$')) returns '1, 2, 3'.
nums <- c('1', '2', '3', '4')
names(nums) <- c('$', '$$', '$$$', '$$$$')

priceString <- function(price) {
  paste(nums[price], collapse = ',')
}

# Note Strings:

priceIsNull <- "Price Filtering currently has a bug where some term/price combinations return a NULL error (e.g. Taco Bell with 4 $'s). This simply means the Yelp API was unable to find any results corresponding to those combinations."

offsetNotEmpty <- "Offset cannot be empty; default value is 0."

needsWork1 <- "Writing to .txt needs better formatting (in the .txt file)."

explainHours <- "In business hours, 0-6 correspond to days of the week, where 0 is Monday and 6 is Sunday."
