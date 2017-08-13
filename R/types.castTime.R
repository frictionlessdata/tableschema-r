#' @title cast time
#' 
#' @rdname types.castTime
#' @export
#' @description cast time
#' 

types.castTime <- function (format="%H:%M:%S", value) {
  
  if (!is.POSIXct(value)|!is.POSIXt(value)) {
    
    if (!is.character(value)) stop( 1 ,call. = FALSE)
    
    tryCatch( {
      
      if (format == "%H:%M:%S") {
        
        value = format(value, format=format)
        
        value = as.POSIXlt(value, format = format)
        
        #value = strftime(value, format = format )
        
      } else if (startsWith(format,"fmt:") ){
        
          warning("Format ",format," is deprecated.\nPlease use ",unlist(strsplit(format,":"))[2]," without 'fmt:' prefix.", call. = FALSE) 
          
          format = trimws(gsub("fmt:","",format),which="both")
          
          value = as.POSIXlt(value, format = format)
          
          #value = strftime(value, format = format)
          
      } else if ( format != "%y-%m-%d" & !startsWith(format,"fmt:") ) {
        
        value = format(value, format=format)
        
        value = as.POSIXlt(value, format = format)
        
        #value = strftime(value, format = format)
      }
      
      if ( !is.POSIXlt(strptime(value, format = format)) ) stop("Value is not a valid time object",call. = FALSE)
      
      value = strftime(as.POSIXlt(value, format = format), format = format) 
      
    },
    
    error= function(e) err<<-e
    )
  }
  
  return (value)
}

