#' @title cast geojson
#' @description cast geojson
#' @param format format
#' @param value value
#' @rdname types.castGeojson
#' @export
#' 

types.castGeojson <- function (format, value) {
  
  if (!is.object(value)) {
    
    if (!is.character(value)) return(config::get("ERROR"))
    
    tryCatch( {
      
      value = jsonlite::fromJSON(value)
      
    },
    
    warning = function(w) {
      
      message(config::get("WARNING"))
      
    },
    
    error = function(e) {
      
      return(config::get("ERROR"))
      
    },
    
    finally = {
      
    })
    
  }
  if (format == "default") {
    
    tryCatch( {
      path_geojson <- system.file("profiles/geojson.json", package = "tableschema.r")
      
      v = jsonvalidate::json_validator(path_geojson)
      
      valid = v(value,verbose = T, greedy=TRUE,error=F) # ./inst/profiles/geojson.json
      
      if (!valid) return(config::get("ERROR"))
      
    },
    
    warning = function(w) {
      
      message(config::get("WARNING"))
      
    },
    
    error = function(e) {
      
      return(config::get("ERROR"))
      
    },
    
    finally = {
      
    })
    
  } else if (format == "topojson") {
    
    if ( !is.null(value) | !is.list(value) ) return(config::get("ERROR"))  #!isPlainObject(value)
    
  }
  return (value)
}

# path_geojson <- system.file("profiles/geojson.json", package = "tableschema.r")
# path_table_schema <- system.file("profiles/table-schema.json", package = "tableschema.r")