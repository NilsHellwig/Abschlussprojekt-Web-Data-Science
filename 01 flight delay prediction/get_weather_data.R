# This function is used to identify for a time in which of the four quarters of of a day weather data should be considered.
# This range is then returned.
get_weather_data <- function(departure_time) {
  if (format(departure_time, format = "%Y-%m-%d 06:00:00") > departure_time) {
    weather_span <- format(departure_time, format = "%Y-%m-%d 00:00:00")
  } else if (format(departure_time, format = "%Y-%m-%d 12:00:00") > departure_time) {
    weather_span <- format(departure_time, format = "%Y-%m-%d 06:00:00")
  } else if (format(departure_time, format = "%Y-%m-%d 18:00:00") > departure_time) {
    weather_span <- format(departure_time, format = "%Y-%m-%d 12:00:00")
  } else if (format(departure_time, format = "%Y-%m-%d 24:00:00") > departure_time) {
    weather_span <- format(departure_time, format = "%Y-%m-%d 18:00:00")
  } 
  return(weather_span)
}