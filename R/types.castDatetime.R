#' @title cast date time
#' @description cast date time
#' @param format format
#' @param value value
#' @rdname types.castDatetime
#' @export
#' 

types.castDatetime <- function (format="%Y-%m-%dT%H:%M:%SZ", value) {
  
  if ( !lubridate::is.Date(value) ) {
    
    if( !is.character(value) ) stop("Value should be character or date class",call. = FALSE)  
    
    
    withCallingHandlers(
      
      tryCatch({
        
        
        if (format == "%Y-%m-%dT%H:%M:%SZ"){
          
          value = lubridate::as_datetime(lubridate::parse_date_time(value, format))
          
        } else if (startsWith(format,"fmt:") ){
          
          warning("Format ",format," is deprecated.\nPlease use ",unlist(strsplit(format,":"))[2]," without 'fmt:' prefix.", call. = FALSE) 
          
          format = trimws(gsub("fmt:","",format),which="both")
          
          value = lubridate::as_datetime(lubridate::parse_date_time(value, format))
          
        } else if ( format != "%Y-%m-%dT%H:%M:%SZ" & !startsWith(format,"fmt:") ) {
          
          value = lubridate::as_datetime(value, format) 
          
        }
        
        if ( !lubridate::is.Date(lubridate::as_datetime(value, format = format)) ) stop("Value is not a valid date",call. = FALSE)
        
        value = lubridate::as_datetime(value, format) 
        
      },
      
      error = function(e)   e
      ),
      
      warning=function(w)  w
    )
    
  }
  return(value)
}
