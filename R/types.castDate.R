#' @title Cast date
#' @description cast date without a time
#' @param format available options are "default", "any", and "<pattern>" where
#' \describe{
#' \item{\code{default }}{An ISO8601 format string
#' \itemize{
#' \item{\code{date:}}{ This \code{MUST} be in ISO8601 format YYYY-MM-DD}
#' \item{\code{datetime:}}{ a date-time. This \code{MUST} be in ISO 8601 format of YYYY-MM-DDThh:mm:ssZ in UTC time}
#' \item{\code{time:}}{ a time without a date}
#' }}
#' \item{\code{any }}{Any parsable representation of the type. The implementing library 
#' can attempt to parse the datetime via a range of strategies, e.g. \href{https://CRAN.R-project.org/package=lubridate}{lubridate}, 
#' \href{https://CRAN.R-project.org/package=parsedate}{parsedate},\code{\link[base]{strptime}},
#' \code{\link[base]{DateTimeClasses}}.}
#' \item{\code{<pattern> }}{date/time values in this field can be parsed according to \code{pattern}.
#'  \code{<pattern>} MUST follow the syntax of \code{\link[base]{strptime}}. 
#'  (That is, values in the this field should be parseable by R using \code{<pattern>}).}
#' }
#' @param value date to cast
#' @rdname types.castDate
#' @export
#' @seealso \href{https://frictionlessdata.io/specs/table-schema/#date}{Types and formats specifications}, 
#' \code{\link[base]{strptime}}, \code{\link[base]{DateTimeClasses}},
#' \code{\link[parsedate]{parsedate-package}} and 
#' \code{\link[lubridate]{lubridate-package}}.
#' 
#' @examples 
#' types.castDate(format = "default", value =  as.Date("2019-1-1"))
#' 
#' types.castDate(format = "default", value = "2019-1-1")
#' 
#' types.castDate(format = "any", value = "2019-1-1")
#' 
#' types.castDate(format = "%d/%m/%y", value = "21/11/06")
#' 
#' types.castDate(format = "%d/%m/%y", value = as.Date("2019-1-1"))
#' 

types.castDate <- function(format = "default", value) {
  if (!lubridate::is.Date(value)) {
    
    if (!is.character(value))
      return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
    withCallingHandlers(
      tryCatch({
        
        if (is.null(format) ||
            format == "default" || format == "any"  || format == "%Y-%m-%d") {
          
          value <- suppressWarnings(as.Date(
            lubridate::parse_date_time(x = value, orders = "%Y-%m-%d"),
            format = "%Y-%m-%d"
          ))
          
          if (is.na(value) | is.null(value)) return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
          
        } else if (format != "default" &&
                   !startsWith(format, "fmt:")) {
          #format == "any"
          
          if (format == "invalid") {
            value <- strptime(x = value, format = format)
            
          } else
            value <- suppressWarnings(as.Date(lubridate::parse_date_time(value, format), format = format))
          
          if (isTRUE(is.na(value) ||
                     nchar(value) > 11))
            return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
          
        } else {
          
          if (startsWith(format, "fmt:")) {
            message(config::get("WARNING", file = system.file("config/config.yml", package = "tableschema.r")))
            
            #warn=message("Format ",format," is deprecated.\nPlease use ",unlist(strsplit(format,":"))[2]," without 'fmt:' prefix.", call. = FALSE)
            
            format <- trimws(gsub("fmt:", "", format), which = "both")
          }
          
          if (format == "invalid") {
            value <- strptime(x = value, format = format)
            
          } 
          #else
          #  value = as.Date(lubridate::parse_date_time(value, format), format = format)
          
          if (isTRUE(is.na(value) ||
                     nchar(value) > 11))
            return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
        }
        if (!lubridate::is.Date(value)) {
          parsed_effort <- suppressWarnings(lubridate::parse_date_time(value, format))
          if ((!lubridate::is.instant(parsed_effort)) ||
              is.na(parsed_effort)) {
            return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
            
          } else {
            value <- as.Date(lubridate::parse_date_time(value, format), format = format)
          }
        }
      }),
      
      warning = function(w) {
        return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
        
      },
      
      error = function(e) {
        return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
        invokeRestart("muffleWarning")
      }
    )
  }
  return(value)
}