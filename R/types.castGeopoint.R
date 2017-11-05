#' @title cast geopoint
#' @description cast geopoint
#' @param format format
#' @param value value
#' @rdname types.castGeopoint
#' @export
#' 

types.castGeopoint <- function (format, value) {
  
tryCatch({
  
  lon_lat=list()
  
    if (format == 'default') {
      
      if (is.character(value)) {
        
        lon_lat = as.list(unlist(strsplit(value, ",")))
        
        lon_lat[[1]] = trimws(lon_lat[[1]], which = "both")
        
        lon_lat[[2]] = trimws(lon_lat[[2]], which = "both")
        
      } else if (is.array(value) | is.list(value)) {
        
        lon_lat = value
        
      } else return(config::get("ERROR"))
      
    } else if (format == 'array') {
      
      if (is.character(value)) {
        
        value = jsonlite::fromJSON('string')
        
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
    
    return(config::get("ERROR"))
    
  })
  
  
  if (is_empty(lon_lat) | is.null(lon_lat) )  return(config::get("ERROR"))
  
  if (length(lon_lat) !=2)  return(config::get("ERROR"))
  
  if (is.nan(lon_lat[[1]]) | lon_lat[[1]] > 180 | lon_lat[[1]] < -180) {
    
    return(config::get("ERROR"))
    
  }
  
  if (is.nan(lon_lat[[2]]) | lon_lat[[2]] > 90 | lon_lat[[2]] < -90) {
    
    return(config::get("ERROR"))
    
  }
  
  return(lon_lat)
  
}
