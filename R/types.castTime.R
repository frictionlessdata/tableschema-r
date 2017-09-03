#' @title cast time
#' @description cast time
#' @param format format
#' @param value value
#' @rdname types.castTime
#' @export
#' 

types.castTime <- function (format="%H:%M:%S", value) {
  
  if (!lubridate::is.instant(value)) {
    
    if (!is.character(value)) return(config::get("ERROR"))
    
    tryCatch( {
      
      if (format == "%H:%M:%S") {
        
        value = format(value, format=format)
        
        value = as.POSIXlt(value, format = format)
        
        #value = strftime(value, format = format )
        
      } else if (startsWith(format,"fmt:") ){
        
        message(config::get("WARNING"))
        
        #warning("Format ",format," is deprecated.\nPlease use ",unlist(strsplit(format,":"))[2]," without 'fmt:' prefix.", call. = FALSE) 
        
        format = trimws(gsub("fmt:","",format),which="both")
        
        value = as.POSIXlt(value, format = format)
        
        #value = strftime(value, format = format)
          
      } else if ( format != "%H:%M:%S" & !startsWith(format,"fmt:") ) {
        
        value = format(value, format=format)
        
        value = as.POSIXlt(value, format = format)
        
        #value = strftime(value, format = format)
      }
      
      if ( !lubridate::is.POSIXlt(strptime(value, format = format)) ) return(config::get("ERROR"))
      
      value = strftime(as.POSIXlt(value, format = format), format = format) 
      
    },
    
    warning = function(w) {
      
      message(config::get("WARNING"))
      
    },
    
    error = function(e) {
      
      return(config::get("ERROR"))
      
    },
    
    finally = { 
      
    })
  }
  
  return (value)
}

