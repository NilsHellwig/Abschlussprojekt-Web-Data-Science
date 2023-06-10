library(httr)
library(rvest)

# We first define the URL that serves as the basis for each request. This is either the url for departures or arrivals.
base_url_departures <- "https://www.flightera.net/en/airport/Munich/EDDM/departure/"

# These are the days that are available on Flightera.net for both departures and arrivals
days_for_crawling <- as.character(seq(as.Date("2017-09-18"), as.Date("2023-05-15"), by = "day"))

n_hours_to_crawl = 10

# I have determined this parameter "empirically". I always make sure that a maximum of 100 requests are made in 
# succession in order to avoid a "too many request" error. I also make sure that there is always a 45-minute wait 
# between these requests. This means that I can use this script to download 
# flight data without receiving a "too many request" error.
requests_per_pause <- 100 / n_hours_to_crawl
pause_duration <- 2800

# Download dataset with flights (as .html files)
for (i in 1:length(days_for_crawling)) {
  day <- days_for_crawling[i]
  
  # Select two random hours between 0 and 23 and the URLs for the requests
  hours <- sample(0:23, n_hours_to_crawl, replace = FALSE)
  urls <- paste0(base_url_departures, day, "%20", sprintf("%02d", hours), "_00?")
  
  for (j in 1:length(hours)) {
    hour <- hours[j]
    url <- urls[j]
    
    # Send an HTTP GET request to the URL and read the HTML
    response <- GET(url)
    content <- content(response, as = "text")
    parsed_html <- read_html(content)
    
    # Write the parsed HTML content to a file
    filename <- paste0("datasets/raw_departures_dataset/request_", day, "_", sprintf("%02d", hour), "_00.html")
    writeLines(as.character(parsed_html), filename)
    
    # Pause for 7 minutes
    Sys.sleep(7)
  }
  
  # Check if the number of requests is a multiple of requests_per_pause.
  # We need to wait 45 minutes until we can download the next 99 pages.
  if (i %% requests_per_pause == 0) {
    Sys.sleep(pause_duration)
  }
}
