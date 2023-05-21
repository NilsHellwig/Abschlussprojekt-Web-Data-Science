extract_minutes_from_delay_string <- function(input_string) {
  input_string <- input_string[length(input_string)]
  input_string <- trimws(input_string)
  
  if (input_string == "on time") {
    return(0)
  }
  
  # Check if "early" is present in the input_string
  if (grepl("early", input_string)) {
    negate_sign <- -1
  } else {
    negate_sign <- 1
  }
  
  # extract all digits in the string
  numbers <- as.numeric(regmatches(input_string, gregexpr("\\d+", input_string))[[1]])
  
  # extract all units in the string
  units <- regmatches(input_string, gregexpr("[a-z]+", input_string))[[1]]
  
  hours <- numbers[units == "h"]
  minutes <- numbers[units == "min" | units == "m"]
  
  if (length(hours) == 0) {
    hours <- 0
  }
  if (length(minutes) == 0) {
    minutes <- 0
  }
  
  total_minutes <- (hours * 60) + minutes
  return(total_minutes * negate_sign)
}


convert_date_string <- function(date_string) {
  month_codes <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
  date_parts <- unlist(strsplit(date_string, "[,\\. ]+"))
  
  day <- as.numeric(date_parts[2])
  month <- match(date_parts[3], month_codes)
  year <- as.numeric(date_parts[4])
  
  formatted_date <- sprintf("%04d-%02d-%02d", year, month, day)
  return(formatted_date)
}
