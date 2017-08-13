#' @title cast yearmonth
#' @description cast yearmonth
#' @param format format
#' @param value value
#' @rdname types.castYearmonth
#' @export
#' 

types.castYearmonth <- function (format = "%y-%m", value) {
  
  
  if (is.array(value) | is.list(value)) {
    
    if (length(value) != 2) stop ("Length of the input object should be 2")
    
  } else if (is.character(value)) {
    
    tryCatch({
      
      value = lubridate::as_date(value,format = "%Y-%m-%d")
      
      value = format(value, format = format)
      
      #if (!year || !month) stop()
      
      if (value$month < 1 | value$month > 12) stop ("Specify a true value for month")
      
    },
    
    error=function(e)  e
    
    )
    
  } else stop("Could not cast yearmonth from the input")
  
  return (value)
}

