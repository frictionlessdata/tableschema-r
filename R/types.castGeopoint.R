#' @title cast geopoint
#' @description cast geopoint
#' @param format format
#' @param value value
#' @rdname types.castGeopoint
#' @export
#' 

types.castGeopoint <- function (format, value) {
  
  lon_lat = list( lon=NULL, lat=NULL)
  
  tryCatch({
    
    if (format == "default") {
      
      if (is.character(value)) {
        
        lon_lat = unlist(strsplit(value, ","))
        
        lon_lat$lon = trimws(lon_lat$lon, which = "both")
        
        lon_lat$lon = trimws(lon_lat$lat, which = "both")
        
      } else if (is.list(value) | is.array(value)) { 
        
        lon_lat = value
        
      }
      
    } else if (format == "array") {
      
      if (is.character(value)) {
        
        value = jsonlite::fromJSON(value)
      }
      
      lon_lat = value
      
    } else if (format == "object") {
      
      if (is.character(value)) {
        
        value = jsonlite::fromJSON(value)
        
      }
      
      lon_lat$lon = value$lon
      
      lon_lat$lat = value$lat
      
    }
    
    lon_lat$lon = as.numeric(lon_lat$lon) # or types.castNumber
    
    lon_lat$lat = as.numeric(lon_lat$lat) # or types.castNumber
    
  },
  
  warning = function(w) {
    
    message(config::get("WARNING"))
    
  },
  
  error = function(e) {
    
    return(config::get("ERROR"))
    
  },
  
  finally = {
    
  })
  
  if (is.nan(lon_lat$lon) | lon_lat$lon > 180 | lon_lat$lon < -180) return(config::get("ERROR"))
  
  if (is.nan(lon_lat$lat) | lon_lat$lat > 90 | lon_lat$lat < -90) return(config::get("ERROR"))
  
  return (lon_lat)
  
}