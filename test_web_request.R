# Load necessary packages
library(httr)
library(rvest)


base_url <- "https://www.flightera.net/en/airport/Munich/EDDM/departure/"

# Create a list of all days between 2016-01-01 and 2023-04-30 as strings
days <- as.character(seq(as.Date("2017-09-17"), as.Date("2023-04-30"), by = "day"))

# Loop through all days and scrape the webpage for each day
for (day in days) {
  # Generate a random hour between 0 and 23
  hour <- sprintf("%02d", sample(0:23, 1))
  
  # Format the URL for the current day and random hour
  url <- paste0(base_url, day, "%20", hour, "_00?")
  
  # Send an HTTP GET request to the URL and get the content
  response <- GET(url)
  content <- content(response, as = "text")
  
  # Parse the HTML content using the read_html() function
  parsed_html <- read_html(content)
  
  # Write the parsed HTML content to a file
  filename <- paste0("raw_depature_dataset/request_", day, "_", hour, "_00.html")
  writeLines(as.character(parsed_html), filename)
  
  # Pause for a random amount of time between 2 and 5 seconds
  Sys.sleep(runif(1, 2, 4))
}
