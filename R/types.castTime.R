#' @title cast time
#' @description cast time
#' @param format format
#' @param value value
#' @rdname types.castTime
#' @export
#' 

types.castTime <- function (format="%H:%M:%S", value) {
  
  if (!lubridate::is.instant(value)) {
    
    if (!is.character(value)) return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
    
    value = tryCatch( {
      
      if (format == "%H:%M:%S" | format == "default" | format == "any") {
        format = "%H:%M:%S"
        value = format(value, format=format)
        
        value = as.POSIXlt(value, format = format)
        
        #value = strftime(value, format = format )
        
      } else if (startsWith(format,"fmt:") ){
        
        message(config::get("WARNING", file = system.file("config/config.yml", package = "tableschema.r")))
        
        #warning("Format ",format," is deprecated.\nPlease use ",unlist(strsplit(format,":"))[2]," without 'fmt:' prefix.", call. = FALSE) 
        
        format = trimws(gsub("fmt:","",format),which="both")
        
        value = as.POSIXlt(value, format = format)
        
        #value = strftime(value, format = format)
          
      } else if ( format != "%H:%M:%S" & !startsWith(format,"fmt:") ) {
        
        value = format(value, format=format)
        
        value = as.POSIXlt(value, format = format)
        
        #value = strftime(value, format = format)
      }

      if ( !lubridate::is.POSIXlt(strptime(value, format = format)) || is.na(value) ) return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
      
      value = strftime(as.POSIXlt(value, format = format), format = format) 
      
    },
    
    warning = function(w) {
      
      return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
      
    },
    
    error = function(e) {
      
      return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
      
    },
    
    finally = { 
      
    })
  }
  
  return(value)
}

