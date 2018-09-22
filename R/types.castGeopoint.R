#' @title Cast geographic point
#' @description Cast geographic point
#' @param format available options are "default", "array" and "object", where
#' \describe{
#' \item{\code{default }}{A string of the pattern "lon, lat", where \code{lon} is the longitude 
#' and \code{lat} is the latitude (note the space is optional after the \code{,}). E.g. \code{"90, 45"}.}
#' \item{\code{array }}{A JSON array, or a string parsable as a JSON array, of exactly two items, 
#' where each item is a number, and the first item is \code{lon} and the second item is \code{lat} e.g. \code{[90, 45]}.}
#' \item{\code{object }}{A JSON object with exactly two keys, \code{lat} and \code{lon} and each value is a number e.g. \code{{"lon": 90, "lat": 45}}.}
#' }
#' @param value geopoint to cast
#' @rdname types.castGeopoint
#' @export
#' 
#' @seealso \href{https://frictionlessdata.io/specs/table-schema/#geopoint}{Types and formats specifications}
#' 
#' @examples 
#' 
#' types.castGeopoint(format = "default", value = list(180, 90))
#' 
#' types.castGeopoint(format = "default", value = '180,90')
#' 
#' types.castGeopoint(format = "default", value = '180, -90')
#' 
#' types.castGeopoint(format = "array", value = list(180, 90))
#' 
#' types.castGeopoint(format = "array", value =  '[180, -90]')
#' 
#' types.castGeopoint(format = "object", value = list(lon = 180, lat = 90))
#' 
#' types.castGeopoint(format = "object", value =  '{"lon": 180, "lat": 90}')
#' 

types.castGeopoint <- function(format, value) {
  
  tryCatch({
    
    lon_lat = list()
    
    if (format == 'default') {
      
      if (is.character(value)) {
        
        lon_lat = as.list(unlist(strsplit(value, ",")))
        
        lon_lat[[1]] = trimws(lon_lat[[1]], which = "both")
        lon_lat[[2]] = trimws(lon_lat[[2]], which = "both")
        
      } else if (is.array(value) | is.list(value)) {
        
        lon_lat = value
        
      } else return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
      
    } else if (format == 'array' | format == 'list') {
      
      if (is.character(value)) {
        
        value = jsonlite::fromJSON(value, simplifyVector = FALSE)
        
      }
      
      lon_lat = value
      
    } else if (format == 'object') {
      
      if (is.character(value)) {
        
        value = jsonlite::fromJSON(value)
        
      }  
      
      lon_lat[[1]] = value[[1]]
      lon_lat[[2]] = value[[2]]
      
    }
    
    lon_lat[[1]] = as.numeric(lon_lat[[1]])
    lon_lat[[2]] = as.numeric(lon_lat[[2]])
    
  },
  
  error = function(e) {
    return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
  })
  
  
  if (is_empty(lon_lat) | is.null(lon_lat) | !is.null(names(lon_lat)) )  return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
  
  if (length(lon_lat) != 2)  return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
  
  if (is.nan(lon_lat[[1]]) | lon_lat[[1]] > 180 | lon_lat[[1]] < -180) {
    
    return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
    
  }
  
  if (is.nan(lon_lat[[2]]) | lon_lat[[2]] > 90 | lon_lat[[2]] < -90) {
    
    return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
    
  }
  
  return(lon_lat)
}
