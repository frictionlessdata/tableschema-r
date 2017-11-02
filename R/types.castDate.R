#' @title cast date
#' @description cast date
#' @param format specify format, default is "\%Y-\%m-\%d"
#' @param value value
#' @rdname types.castDate
#' @export
#'
types.castDate <- function(format, value) {
  if (!lubridate::is.Date(value)) {

    if (!is.character(value))
      return(config::get("ERROR"))
    withCallingHandlers(
      tryCatch({

        if (is.null(format) ||
            format == "default" || format == "any"  || format == "%Y-%m-%d") {

          value = suppressWarnings(as.Date(
            lubridate::parse_date_time(x = value, orders = "%Y-%m-%d"),
            format = "%Y-%m-%d"
          ))
          
          if (is.na(value) | is.null(value)) return(config::get("ERROR"))
          
        } else if (format != "default" &&
                   !startsWith(format, "fmt:")) {
          #format == "any"

          if (format == "invalid") {
            value = strptime(x = value, format = format)
            
          } else
            value = suppressWarnings(as.Date(lubridate::parse_date_time(value, format), format = format))
          
          if (isTRUE(is.na(value) ||
                     nchar(value) > 11))
            return(config::get("ERROR"))
          
        } else {

          if (startsWith(format, "fmt:")) {
            message(config::get("WARNING"))
            
            #warn=message("Format ",format," is deprecated.\nPlease use ",unlist(strsplit(format,":"))[2]," without 'fmt:' prefix.", call. = FALSE)
            
            format = trimws(gsub("fmt:", "", format), which = "both")
          }
          
          if (format == "invalid") {
            value = strptime(x = value, format = format)
            
          } 
          #else
          #  value = as.Date(lubridate::parse_date_time(value, format), format = format)
          

          if (isTRUE(is.na(value) ||
                     nchar(value) > 11))
            return(config::get("ERROR"))
          
        }
        
        if (!lubridate::is.Date(value)) {
          parsed_effort = suppressWarnings(lubridate::parse_date_time(value, format))
                  if ((!lubridate::is.instant(parsed_effort)) ||
            is.na(parsed_effort)) {
          return(config::get("ERROR"))
          
        } else {
          value = as.Date(lubridate::parse_date_time(value, format), format = format)
        }
      
       
        }

        
      }),
      
      warning = function(w) {
        return(config::get("ERROR"))
        
      },
      
      error = function(e) {
        return(config::get("ERROR"))
        invokeRestart("muffleWarning")
      }
    )
    
  }
  return(value)
  
}