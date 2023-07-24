library(httr)
library(rvest)

# I chose to download flight data from flightera.net. I decided to collect flight data for the period between October 2017 and May 2023. For these months, flight data is available on Flightera for every day. 
# As downloading takes a long time, I decided to collect flight data for four random hours for each day. 
# This allowed me to collect around 200,000 flights, which took three full days using this script.

# We first define the URL that serves as the basis for each request
base_url_departures <- "https://www.flightera.net/en/airport/Munich/EDDM/departure/"

# These are the days that are available on Flightera.net for the departure flights
days_for_crawling <- as.character(seq(as.Date("2017-10-05"), as.Date("2017-10-20"), by = "day"))

n_hours_to_crawl = 4

# A maximum of 99 requests are made in order to avoid a "too many request" error. 
# I also make sure that there is always a waiting time of at least 45 minutes
# between these 99 requests. 
requests_per_pause <- 99
pause_per_request <- 8
pause_duration <- 2800

n_requests <- 0

# Download flight metadata (as .html files)
for (i in 1:length(days_for_crawling)) {
  day <- days_for_crawling[i]
  
  # Select random hours between 0 and 23 and create the URLs for the requests
  hours <- sample(0:23, n_hours_to_crawl, replace = FALSE)
  urls <- paste0(base_url_departures, day, "%20", sprintf("%02d", hours), "_00?")
  
  for (j in 1:length(hours)) {
    # Check if the number of requests is requests_per_pause.
    # We need to wait 45 minutes until we can download the next 99 pages.
    if (n_requests == requests_per_pause) {
      Sys.sleep(pause_duration)
      n_requests <- 0
    }
    
    hour <- hours[j]
    url <- urls[j]
    
    # Send an HTTP GET request to the URL and read the HTML
    response <- GET(url)
    content <- content(response, as = "text")
    parsed_html <- read_html(content)
    
    # Write the parsed HTML content to a file
    filename <- paste0("../datasets/raw_departures_dataset/request_", day, "_", sprintf("%02d", hour), "_00.html")
    writeLines(as.character(parsed_html), filename)
    
    # Wait for some seconds until the next request
    Sys.sleep(pause_per_request)
    
    n_requests <- n_requests + 1
  }
}