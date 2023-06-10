library(httr)
library(rvest)

# We first define the URL that serves as the basis for each request.
base_url_arrivals <- "https://www.timeanddate.com/weather/germany/munich/historic"

# Since we are only interested in the weather in Munich from September 2017 to May 2023, we will only download the weather data between these two points in time.
start_year <- 2017
start_month <- 9
end_year <- 2023
end_month <- 5

for (year in start_year:end_year) {
  range_start <- ifelse(year == start_year, start_month, 1)
  range_end <- ifelse(year == end_year, end_month, 12)
  
  for (month in range_start:range_end) {
    year_str <- sprintf("%04d", year)
    month_str <- sprintf("%02d", month)
    url <- paste0(base_url_arrivals, "?month=", month_str, "&year=", year_str)
    
    response <- GET(url)
    content <- content(response, as = "text")
    parsed_html <- read_html(content)
    
    filename <- paste0("datasets/raw_weather_munich_dataset/request_", year_str, "-", month_str, ".html")
    
    writeLines(as.character(parsed_html), filename)
    Sys.sleep(runif(1, 7, 10))
  }
}
