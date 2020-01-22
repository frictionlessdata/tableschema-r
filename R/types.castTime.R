#' @title Cast time without a date
#' @description Cast time without a date
#' @param format available options are "default", "any", and "<pattern>" where
#' \describe{
#' \item{\code{default }}{An ISO8601 time string e.g. hh:mm:ss}
#' \item{\code{any }}{As for \code{\link{types.castDate}}}
#' \item{\code{<pattern> }}{As for \code{\link{types.castDate}}}
#' }
#' @param value time to cast
#' 
#' @rdname types.castTime
#' 
#' @export
#' 
#' @seealso \href{https://frictionlessdata.io/specs/table-schema/#time}{Types and formats specifications},
#' \code{\link[base]{strptime}}, \code{\link[base]{DateTimeClasses}},
#' \code{\link[parsedate]{parsedate-package}} and 
#' \code{\link[lubridate]{lubridate-package}}.
#' 
#' @examples
#' 
#' types.castTime(format = "default", value = '06:00:00')
#' 

types.castTime <- function(format="%H:%M:%S", value) {
  
  if (!lubridate::is.instant(value)) {
    
    if (!is.character(value)) return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
    
    value <- tryCatch( {
      
      if (format == "%H:%M:%S" | format == "default" | format == "any") {
        format <- "%H:%M:%S"
        value <- format(value, format = format)
        
        value <- as.POSIXlt(value, format = format)
        #value = strftime(value, format = format )
        
      } else if (startsWith(format,"fmt:")) {
        
        message(config::get("WARNING", file = system.file("config/config.yml", package = "tableschema.r")))
        #warning("Format ",format," is deprecated.\nPlease use ",unlist(strsplit(format,":"))[2]," without 'fmt:' prefix.", call. = FALSE) 
        
        format <- trimws(gsub("fmt:","",format),which = "both")
        
        value <- as.POSIXlt(value, format = format)
        #value = strftime(value, format = format)
          
      } else if ( format != "%H:%M:%S" & !startsWith(format,"fmt:") ) {
        format <- "%H:%M:%S"
        value <- format(value, format = format)
        
        value <- as.POSIXlt(value, format = format)
        #value = strftime(value, format = format)
      }

      if ( !lubridate::is.POSIXlt(strptime(value, format = format)) || is.na(value) ) return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
      
      value <- strftime(as.POSIXlt(value, format = format), format = format) 
      
    },
    warning = function(w) {
      return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
    },
    error = function(e) {
      return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
    },
    finally = {})
  }
  
  return(value)
}

