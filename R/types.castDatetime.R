#' @title cast date time
#' @description cast date time
#' @param format specify format, default is "\%Y-\%m-\%dT\%H:\%M:\%SZ"
#' @param value value
#' @rdname types.castDatetime
#' @export
#' 
#format.Date(strptime(value, format="%Y-%m-%dT%H:%M:%SZ"), orders = "%Y-%m-%dT%H:%M:%SZ")
types.castDatetime <- function (format = "%Y-%m-%dT%H:%M:%SZ", value) {
  
  if ( !lubridate::is.Date(value) ) {
    
    if( !is.character(value) ) return(config::get("ERROR"))
    
    withCallingHandlers(tryCatch({
      
      if ( is.null(format) | format == "default" | format=="any" | format == "%Y-%m-%dT%H:%M:%SZ" ){
        
        if (!grepl(" ", value)) {
          
          value = suppressWarnings(format.Date(strptime(value, format="%Y-%m-%dT%H:%M:%SZ"), orders = "%Y-%m-%dT%H:%M:%SZ"))
          
        } else {
        
        value =  suppressWarnings(format.Date(lubridate::as_datetime(x = value), orders = "%Y-%m-%dT%H:%M:%SZ"))
        
        }
        
        format = "%Y-%m-%dT%H:%M:%SZ"
        
        if (isTRUE(is.na(value))) return(config::get("ERROR"))
        
      } else if ( format != "default" & !startsWith(format,"fmt:") ) { #format == "any"
        
        if (format == "invalid") {
          
          return(config::get("ERROR"))
        
        } else {
          
          #text = paste0("format.Date(lubridate::as_datetime(","format(value,format=format)), origin='2006-11-21 16:30')")
          #
          #value = suppressWarnings(eval(parse(text=text)))#gsub(" ","_",text))))
          if(grepl("/",value)) {
            
            value = format(strptime(value,format=format,tz = "UTC"),origin='2003-12-20 16:30')
            
            } else value = format(value,format=format)
            
            if ( isTRUE(is.na(value) || nchar(value)>19 ) ) return(config::get("ERROR"))
            
        }
        
        #if (is.na(value) | is.null(value)) return(config::get("ERROR")) 
        
      } else {
        
        if ( startsWith(format,"fmt:") ) {
          
          message(config::get("WARNING"))
          
          #warn=message("Format ",format," is deprecated.\nPlease use ",unlist(strsplit(format,":"))[2]," without 'fmt:' prefix.", call. = FALSE) 
          
          format = trimws( gsub("fmt:", "", format), which = "both")
        }
        
        #value =  format.Date(lubridate::as_datetime(x = value), orders = format)
        
        if(grepl("/",value)) {
          
          value = format(strptime(value,format=format,tz = "UTC"),origin='2003-12-20 16:30')
          
        } else value = format(value,format=format)
        
        if ( isTRUE(is.na(value) || nchar(value)>19 ) ) return(config::get("ERROR"))
      }
      
      if (suppressWarnings(!lubridate::is.instant(lubridate::as_datetime(x = value)) | is.na(lubridate::as_datetime(x = value)))) {
        
        return(config::get("ERROR"))
        
      } #else value = strptime(x = value, format = format) 
      
    }),
    
    warning = function(w) {
      
      return(config::get("WARNING"))
      
    },
    
    error = function(e) {
      
      return(config::get("ERROR"))
      
      invokeRestart("muffleWarning")
    }
    )
    
  }
  
  return (value)
}
