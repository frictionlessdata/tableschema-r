#' @title cast date
#' @description cast date
#' @param format format
#' @param value value
#' @rdname types.castDate
#' @export
#' 
types.castDate <- function (format = "%y-%m-%d", value) {
  
  if ( !lubridate::is.Date(value) ) {
    
    if( !is.character(value) ) stop("Value should be character or date class",call. = FALSE)
    
    withCallingHandlers(
      
      tryCatch({
        
        
        if (format == "%y-%m-%d"){
          
          value = lubridate::as_date(lubridate::parse_date_time(value, format))
          
        } else if (startsWith(format,"fmt:") ){
          
          warning("Format ",format," is deprecated.\nPlease use ",unlist(strsplit(format,":"))[2]," without 'fmt:' prefix.", call. = FALSE) 
          
          format = trimws(gsub("fmt:","",format),which="both")
          
          value = lubridate::as_date(lubridate::parse_date_time(value, format))
          
        } else if ( format != "%y-%m-%d" & !startsWith(format,"fmt:") ) {
          
          value = lubridate::as_date(value, format) 
          
        }
        
      if ( !lubridate::is.Date(lubridate::as_date(value, format = format)) ) stop("Value is not a valid date",call. = FALSE)
    
      value = lubridate::as_date(value, format) 
      
     },
      
      error = function(e)  e
     ),
      
      warning=function(w)  w
     )
      
  }
  return(value)
}

