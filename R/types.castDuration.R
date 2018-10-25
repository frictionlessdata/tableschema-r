#' @title Cast duration of time
#' @description Cast duration of time
#' @param format no options (other than the default)
#' @param value duration to cast
#' 
#' @seealso \href{https://frictionlessdata.io/specs/table-schema/#duration}{Types and formats specifications}, 
#' \code{\link[lubridate]{lubridate-package}}.
#' 
#' @details We follow the definition of \href{https://www.w3.org/TR/xmlschema-2/#duration}{XML Schema duration datatype} 
#' directly and that definition is implicitly inlined here.
#' 
#' To summarize: the lexical representation for duration is the \href{https://en.wikipedia.org/wiki/ISO_8601#Durations}{ISO 8601}
#' extended format PnYnMnDTnHnMnS, where nY represents the number of years, nM the number of months, nD the number of days, 
#' 'T' is the date/time separator, nH the number of hours, nM the number of minutes and nS the number of seconds. 
#' The number of seconds can include decimal digits to arbitrary precision. 
#' Date and time elements including their designator may be omitted if their value is zero, 
#' and lower order elements may also be omitted for reduced precision.
#' 
#' @rdname types.castDuration
#' @export
#' 
#' @examples 
#' 
#' types.castDuration(format = "default", value = durations(years= 10))
#' 
#' types.castDuration(format = "default", value = "P1Y10M3DT5H11M7S")
#'  
types.castDuration <- function(format = "default", value) {
  
  if (isTRUE(grepl("(\\d+) Years, (\\d+) Months, (\\d+) Days, ",value)))  duration <- value 
  
  else if (isTRUE(grepl("P(\\d+)Y(\\d+)M(\\d+)DT(\\d+)H(\\d+)M(\\d+)S",value))) duration <- ifelse(grepl(".*M(\\d)S", value), gsub("P(\\d+)Y(\\d+)M(\\d+)DT(\\d+)H(\\d+)M(\\d)S", "\\1 Years, \\2 Months, \\3 Days, \\4:\\5:0\\6", value), 
                                                                                                  gsub("P(\\d+)Y(\\d+)M(\\d+)DT(\\d+)H(\\d+)M(\\d+)S", "\\1 Years, \\2 Months, \\3 Days, \\4:\\5:\\6", value))
  
  else return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
    #stop(TableSchemaError$new("Value should be ISO-8601 extended format or duration object, see duration function")$message)

  return(duration)
}



#' Durations
#' @description Help function to use with \code{\link{types.castDuration}}
#' @param years years
#' @param months months
#' @param days days
#' @param hours hours
#' @param minutes minutes
#' @param seconds seconds
#' @rdname durations
#' @seealso \code{\link{types.castDuration}}
#' @export
#' 
durations <- function(years = 0, months = 0, days = 0, hours = 00, minutes = 00, seconds = 00) {
  
  time <- paste( formatC(hours, width = 2, format = "d", flag = ""), 
                formatC(minutes, width = 2, format = "d", flag = "0"),
                formatC(seconds, width = 2, format = "d", flag = "0"), sep = ":")
  
  date <- paste(paste(formatC(years, width = 1, format = "d", flag = "0"), "Years"), 
               paste(formatC(months, width = 1, format = "d", flag = "0"), "Months"),
               paste(formatC(days, width = 1, format = "d", flag = "0"), "Days"), sep = ", ")
  
  duration <- paste(date , time, sep = ",")

  return(duration)
}


# #' duration
# #' @param x input duration
# #' @param type time unit of x 
# #' @details Available inputs for type of input duration are picoseconds, nanoseconds, microseconds, milliseconds, seconds, minutes, hours, days, weeks, years
# #' @rdname Duration
# #' @export
# Duration = function(x, type="seconds") {
#   
#   if( type == "picoseconds" ) x = lubridate::dpicoseconds(x)
#   if( type == "nanoseconds" ) x = lubridate::dnanoseconds(x)
#   if( type == "microseconds" ) x = lubridate::dmicroseconds(x)
#   if( type == "milliseconds" ) x = lubridate::dmilliseconds(x)
#   if( type == "seconds" ) x = lubridate::dseconds(x)
#   if( type == "minutes" ) x = lubridate::dminutes(x)
#   if( type == "hours" ) x = lubridate::dhours(x)
#   if( type == "days" ) x = lubridate::ddays(x)
#   if( type == "weeks" ) x = lubridate::dweeks(x)
#   if( type == "years" ) x = lubridate::dyears(x)
#   
#   return(x)
# }


# #' @title cast duration
# #' @description cast duration
# #' @param value value
# #' @param format time unit of x 
# #' @details Available inputs for format of input value are picoseconds, nanoseconds, microseconds, milliseconds, seconds, minutes, hours, days, weeks, years
# #' @rdname types.castDuration
# #' @export
# #' 
# types.castDuration <- function(format = "seconds", value) { #format parameter is not used   
#   
#   if (!lubridate::is.duration(value)) {
#     
#     if (!is.character(value)) return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
#     
#     result = tryCatch({
#       
#       value = Duration(as.integer(value), type = format)  # as.integer change to types.castInteger function
#       
#       if (!lubridate::is.duration(value) || is.na(value)) return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
#       else {
#         return(value)
#       }
#       
#     },
#     
#     warning = function(w) {
#       message(config::get("WARNING", file = system.file("config/config.yml", package = "tableschema.r")))
#       return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
#       
#     },
#     
#     error = function(e) {
#       return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
#       
#     },
#     
#     finally = {
#       
#     })      
#     
#     #if( not in milliseconds()) stop("Value should be in milliseconds",call. = FALSE)
#     
#     #},error= function(e) err<<-e)
#     return(result)
#     
#   }
# }