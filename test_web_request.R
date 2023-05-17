# Load necessary packages
library(httr)
library(rvest)


base_url <- "https://www.timeanddate.com/weather/germany/munich/historic?month=8&year=2017"

url <- paste0(base_url)
  
response <- GET(url)
content <- content(response, as = "text")
  
parsed_html <- read_html(content)
  
filename <- "test_request.html"
writeLines(as.character(parsed_html), filename)


