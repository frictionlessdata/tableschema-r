#' @title cast duration
#' @description cast duration
#' @param value value
#' @param format time unit of x 
#' @details Available inputs for format of input value are picoseconds, nanoseconds, microseconds, milliseconds, seconds, minutes, hours, days, weeks, years
#' @rdname types.castDuration
#' @export
#' 

types.castDuration <- function (value, format = "seconds") { #format parameter is not used   
  
  if (!lubridate::is.duration(value)) {
    
    if (!is.character(value)) return(config::get("ERROR"))
    
    tryCatch({
      
      value = Duration(as.integer(value), type = format)  # as.integer change to types.castInteger function
      
      if(!lubridate::is.duration(value) | is.na(value)) return(config::get("ERROR"))
      
    },
    
    warning = function(w) {
      
      message(config::get("WARNING"))
      
    },
    
    error = function(e) {
      
      return(config::get("ERROR"))
      
    },
    
    finally = {
      
    })      

    #if( not in milliseconds()) stop("Value should be in milliseconds",call. = FALSE)
    
    #},error= function(e) err<<-e)
    
    return(value)
    
  }
}
#' duration
#' @param x input duration
#' @param type time unit of x 
#' @details Available inputs for type of input duration are picoseconds, nanoseconds, microseconds, milliseconds, seconds, minutes, hours, days, weeks, years
#' @rdname Duration
#' @export
Duration = function(x, type="seconds") {
  
  if( type == "picoseconds" ) x = lubridate::dpicoseconds(x)
  if( type == "nanoseconds" ) x = lubridate::dnanoseconds(x)
  if( type == "microseconds" ) x = lubridate::dmicroseconds(x)
  if( type == "milliseconds" ) x = lubridate::dmilliseconds(x)
  if( type == "seconds" ) x = lubridate::dseconds(x)
  if( type == "minutes" ) x = lubridate::dminutes(x)
  if( type == "hours" ) x = lubridate::dhours(x)
  if( type == "days" ) x = lubridate::ddays(x)
  if( type == "weeks" ) x = lubridate::dweeks(x)
  if( type == "years" ) x = lubridate::dyears(x)
  
  return(x)
}
