library(httr)
library(rvest)

# In order to have other features besides the metadata on the flights, I decided to collect historical weather data for the period between October 2017 and May 2023. 
# Weather data of the departure airport has been considered as features by other studies as well
# [1] Ding, Y. (2017, August). Predicting flight delay based on multiple linear regression. In IOP conference series: Earth and environmental science (Vol. 81, No. 1, p. 012198). IOP Publishing.
# [2] Chen, J., & Li, M. (2019). Chained predictions of flight delay using machine learning. In AIAA Scitech 2019 forum (p. 1661).

# We first define the URL that serves as the basis for each request.
base_url <- "https://www.timeanddate.com/weather/germany/munich/historic"

# Since we are only interested in the weather in Munich from October 2017 to May 2023, we will only download the weather data between these two points in time.
start_year <- 2017
start_month <- 10
end_year <- 2023
end_month <- 5

for (year in start_year:end_year) {
  range_start <- ifelse(year == start_year, start_month, 1)
  range_end <- ifelse(year == end_year, end_month, 12)
  
  for (month in range_start:range_end) {
    year_str <- sprintf("%04d", year)
    month_str <- sprintf("%02d", month)
    url <- paste0(base_url, "?month=", month_str, "&year=", year_str)
    
    response <- GET(url)
    content <- content(response, as = "text")
    parsed_html <- read_html(content)
    
    filename <- paste0("../datasets/raw_weather_munich_dataset/request_", year_str, "-", month_str, ".html")
    
    writeLines(as.character(parsed_html), filename)
    Sys.sleep(7)
  }
}
