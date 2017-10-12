#' @title cast yearmonth
#' @description cast yearmonth
#' @param value value
#' @param format format
#' @rdname types.castYearmonth
#' @export
#' 

types.castYearmonth <- function (format, value) { 
  
  if ( isTRUE(is_empty(value))) return(config::get("ERROR"))
  
  if (is.array(value) | is.list(value) ) {
    
    if (length(value) != 2) return(config::get("ERROR"))
    
  } else if (is.character(value)) {
    
    tryCatch({
      
      value = as.list( unlist( strsplit(value, split = "-")))
      
      if ( nchar(as.integer(value[[1]])) != 4 ) return(config::get("ERROR"))
      
      #names(value) = c("year", "month")
      
      year = as.integer(value[[1]])
      
      month = as.integer(value[[2]])
      
      #if (!year | !month) return(config::get("ERROR"))
      
      if (month < 1 | month > 12) return(config::get("ERROR"))
      
      #value = list(year = year, month = month)
      value = list(year, month)
      
      }, 
      warning = function(w) {
        
        return(config::get("ERROR"))
        
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