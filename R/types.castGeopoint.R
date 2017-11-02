#' @title cast geopoint
#' @description cast geopoint
#' @param format format
#' @param value value
#' @rdname types.castGeopoint
#' @export
#' 

types.castGeopoint <- function (format, value) {
  
  lon_lat = list( lon=NULL, lat=NULL)
  
  lon_lat = tryCatch({
    
    if (format == "default") {
      
      if (is.character(value)) {
        
        lon_lat = unlist(strsplit(value, ","))
        
        lon_lat[["lon"]] = trimws(lon_lat$lon, which = "both")
        
        lon_lat[["lat"]] = trimws(lon_lat$lat, which = "both")
        
      } else if (is.list(value) | is.array(value)) { 
        
        lon_lat = value
        
      }
      
    } else if (format == "list" | format == "array") {
      
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
    if (is.nan(lon_lat$lon) | lon_lat$lon > 180 | lon_lat$lon < -180) return(config::get("ERROR"))
    
    if (is.nan(lon_lat$lat) | lon_lat$lat > 90 | lon_lat$lat < -90) return(config::get("ERROR"))
  },
  
  warning = function(w) {
    return(config::get("ERROR"))
    
  },
  
  error = function(e) {
    return(config::get("ERROR"))
    
  },
  
  finally = {
    
  })

  
  return(lon_lat)
  
}