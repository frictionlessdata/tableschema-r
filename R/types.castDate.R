#' @title cast date
#' @description cast date
#' @param format specify format, default is "\%Y-\%m-\%d"
#' @param value value
#' @rdname types.castDate
#' @export
#' 
types.castDate <- function (format = "%Y-%m-%d", value) {
  
  if ( !lubridate::is.Date(value) ) {
    
    if( !is.character(value) ) return(config::get("ERROR"))
    
    tryCatch({
      
      if ( is.null(format) | format == "default" | format == "any" | format == "%Y-%m-%d" ){
        
        value = as.Date(lubridate::parse_date_time(x = value, orders = "%Y-%m-%d"), format = "%Y-%m-%d")
        
        #if (is.na(value) | is.null(value)) return(config::get("ERROR"))
        
      } else if ( format != "default" & !startsWith(format,"fmt:") ) { #format == "any"
        
        value = as.Date( x = value, format )
        
        #if (is.na(value) | is.null(value)) return(config::get("ERROR")) 
        
      } else {
        
        if ( startsWith(format,"fmt:") ) {
          
          message(config::get("WARNING"))
          
          #warn=message("Format ",format," is deprecated.\nPlease use ",unlist(strsplit(format,":"))[2]," without 'fmt:' prefix.", call. = FALSE) 
          
          format = trimws( gsub("fmt:", "", format), which = "both")
        }
        
        value = as.Date(x = value, format )
        
      }
      
      if (!lubridate::is.instant(as.Date(x = value, format = format)) | is.na(as.Date(x = value, format = format))) {
        
        return(config::get("ERROR"))
        
      } else value = as.Date(x = value, format = format) 
      
    },
    
    warning = function(w) {
      
      return(config::get("ERROR"))
      
    },
    
    error = function(e) {
      
      return(config::get("ERROR"))
      
    },
    
    finally = { 
      
    })
    
  }
  
    return (value)
}
