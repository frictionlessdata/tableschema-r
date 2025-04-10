#' @title Cast date
#' @description Cast date without a time.
#'
#' @param format Available options are \code{"default"}, \code{"any"}, and \code{"<pattern>"}, where:
#' \describe{
#'   \item{\code{default}}{An ISO8601 format string:
#'     \describe{
#'       \item{\code{date:}}{This \code{MUST} be in ISO8601 format \code{YYYY-MM-DD}.}
#'       \item{\code{datetime:}}{A date-time. This \code{MUST} be in ISO 8601 format \code{YYYY-MM-DDThh:mm:ssZ} in UTC time.}
#'       \item{\code{time:}}{A time without a date.}
#'     }
#'   }
#'   \item{\code{any}}{Any parsable representation of the type. The implementing library 
#'   may attempt to parse the datetime using various strategies, e.g., 
#'   \href{https://CRAN.R-project.org/package=lubridate}{lubridate}, 
#'   \href{https://CRAN.R-project.org/package=parsedate}{parsedate}, 
#'   \code{\link[base]{strptime}}, or \code{\link[base]{DateTimeClasses}}.}
#'   \item{\code{<pattern>}}{Date/time values in this field can be parsed according to the specified \code{pattern}.
#'   \code{<pattern>} MUST follow the syntax of \code{\link[base]{strptime}}. That is, values in this field should be parseable by R using the given pattern.}
#' }
#'
#' @param value Date to cast.
#'
#' @rdname types.castDate
#' @export
#'
#' @seealso 
#'   \href{https://specs.frictionlessdata.io//table-schema/#date}{Types and formats specifications}, 
#'   \code{\link[base]{strptime}}, 
#'   \code{\link[base]{DateTimeClasses}}, 
#'   \code{\link[parsedate]{parsedate-package}}, 
#'   \code{\link[lubridate]{lubridate-package}}.
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