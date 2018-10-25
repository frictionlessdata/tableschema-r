#' @title Cast datetime
#' @description Cast date with time
#' @param format available options are "default", "any", and "<pattern>" where
#' \describe{
#' \item{\code{default }}{An ISO8601 format string e.g. YYYY-MM-DDThh:mm:ssZ in UTC time}
#' \item{\code{any }}{As for \code{\link{types.castDate}}}
#' \item{\code{<pattern> }}{As for \code{\link{types.castDate}}}
#' }
#' @param value datetime to cast
#' @rdname types.castDatetime
#' @export
#' 
#' @seealso \href{https://frictionlessdata.io/specs/table-schema/#datetime}{Types and formats specifications}, 
#' \code{\link[base]{strptime}}, \code{\link[base]{DateTimeClasses}},
#' \code{\link[parsedate]{parsedate-package}} and 
#' \code{\link[lubridate]{lubridate-package}}.
#' 
#' @examples 
#' 
#' types.castDatetime(format = "default", value = "2014-01-01T06:00:00Z")
#' 
#' types.castDatetime(format = "%d/%m/%y %H:%M", value = "21/11/06 16:30")
#'  
#format.Date(strptime(value, format="%Y-%m-%dT%H:%M:%SZ"), orders = "%Y-%m-%dT%H:%M:%SZ")
types.castDatetime <- function(format = "%Y-%m-%dT%H:%M:%SZ", value) {
  
  if (!lubridate::is.Date(value)) {
    
    if (!is.character(value)) return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
    
    value <- tryCatch({
      if (format == 'default') {
        value <- lubridate::as_datetime(lubridate::fast_strptime(value, "%Y-%m-%dT%H:%M:%SZ" ))
      }
      else if (format == 'any') {
        value <- lubridate::force_tz(as.POSIXct(value, tz = 'UTC'), 'UTC')
      }
      else{
        if (startsWith(format, 'fmt:')) {
          format <- gsub('fmt:', '', format)
        }
        value <- lubridate::as_datetime(lubridate::fast_strptime(value, format))
      }
      if (is.na(value)) {
        return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
      }
      return(value)
    },
    
    warning = function(w) {
      return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
    },
    error = function(e) {
      return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
    })
  }
  return(value)
}
