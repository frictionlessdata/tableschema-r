#' @title cast geojson
#' @description cast geojson
#' @param format format
#' @param value value
#' @rdname types.castGeojson
#' @export
#' 

types.castGeojson <- function(format, value) {
  
  if (!is.object(value)) {
    
    if (!is.character(value)) return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
    
    value = tryCatch( {
      
      value = jsonlite::fromJSON(value)
    },
    
    warning = function(w) {
      
      return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
      
    },
    
    error = function(e) {
      
      return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
      
    },
    
    finally = {
      
    })
    
  }
  
  # if(value == config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))){
  #   return(value)
  # }
  
  if (format == "default") {
    
    value = tryCatch( {
      
      path_geojson <- system.file("profiles/geojson.json", package = "tableschema.r")
      
      v = jsonvalidate::json_validator(path_geojson)
      
      valid = v(value,verbose = TRUE, greedy = TRUE, error = FALSE) # ./inst/profiles/geojson.json
      
      if (!isTRUE(valid)) return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
      
      else return(value)
      
    },
    
    error = function(e) {
      
      return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
      
    },
    
    finally = {
      
    })
    
  } else if (format == "topojson") {
    
    
    if ( !is_object(value) ) return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))  #!isPlainObject(value)
    
  }
  
  return (value)
}

# path_geojson <- system.file("profiles/geojson.json", package = "tableschema.r")
# path_table_schema <- system.file("profiles/table-schema.json", package = "tableschema.r")