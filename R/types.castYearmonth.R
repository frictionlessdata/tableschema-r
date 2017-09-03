#' @title cast yearmonth
#' @description cast yearmonth
#' @param format format
#' @param value value
#' @rdname types.castYearmonth
#' @export
#' 

types.castYearmonth <- function (value) { #format parameter is not used
  
  if (is.array(value) | is.list(value)) {
    
    if (length(value) != 2) return(config::get("ERROR"))
    
  } else if (is.character(value)) {
    
    tryCatch({
      
      value = as.list( unlist( strsplit(value, split = "-")))
      
      names(value) = c("year", "month")
      
      year = as.integer(value$year)
      
      month = as.integer(value$month)
      
      if (!year | !month) return(config::get("ERROR"))
      
      if (month < 1 | month > 12) return(config::get("ERROR"))
      
      value = list(year = year, month = month)
      
      }, 
      warning = function(w) {
        
        message(config::get("WARNING"))
        
      },
      
      error = function(e) {
        
        return(config::get("ERROR"))
        
      },
      
      finally = {
        
      })
    
  } else return(config::get("ERROR"))
  
  return (value)
}

# types.castYearmonth <- function (format = "%y-%m", value) {
#   
#   
#   if (is.array(value) | is.list(value)) {
#     
#     if (length(value) != 2) stop ("Length of the input object should be 2")
#     
#   } else if (is.character(value)) {
#     
#     tryCatch({
#       
#       value = lubridate::as_date(value,format = "%Y-%m-%d")
#       
#       value = format(value, format = format)
#       
#       #if (!year || !month) stop()
#       
#       if (value$month < 1 | value$month > 12) stop ("Specify a true value for month")
#       
#     },
#     
#     error=function(e)  e
#     
#     )
#     
#   } else stop("Could not cast yearmonth from the input")
#   
#   return (value)
# }