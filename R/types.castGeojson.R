#' @title cast geojson
#' @description cast geojson
#' @param format format
#' @param value value
#' @rdname types.castGeojson
#' @export
#' 

types.castGeojson <- function(format, value) {
  
  if (!is.object(value)) {
    
    if (!is.character(value)) return(config::get("ERROR"))
    
    value = tryCatch( {
      
      value = jsonlite::fromJSON(value)
    },
    
    warning = function(w) {
      
      return(config::get("ERROR"))
      
    },
    
    error = function(e) {
      
      return(config::get("ERROR"))
      
    },
    
    finally = {
      
    })
    
  }
  
  # if(value == config::get("ERROR")){
  #   return(value)
  # }
  
  if (format == "default") {
    
    value = tryCatch( {
      
      path_geojson <- system.file("profiles/geojson.json", package = "tableschema.r")
      
      v = jsonvalidate::json_validator(path_geojson)
      
      valid = v(value,verbose = TRUE, greedy = TRUE, error = FALSE) # ./inst/profiles/geojson.json
      
      if (!isTRUE(valid)) return(config::get("ERROR"))
      
      else return(value)
      
    },
    
    error = function(e) {
      
      return(config::get("ERROR"))
      
    },
    
    finally = {
      
    })
    
  } else if (format == "topojson") {
    
    
    if ( !is_object(value) ) return(config::get("ERROR"))  #!isPlainObject(value)
    
  }
  
  return (value)
}

# path_geojson <- system.file("profiles/geojson.json", package = "tableschema.r")
# path_table_schema <- system.file("profiles/table-schema.json", package = "tableschema.r")