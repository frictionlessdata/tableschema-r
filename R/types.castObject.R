#' @title cast object
#' @description cast object
#' @param format format
#' @param value value
#' @rdname types.castObject
#' @export
#' 

types.castObject <- function(format, value) {
  
  if (!is_object(value)) {
    if (!is.character(value))  return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
  }
  
  if(is.list(value)) {
    return(value)
    
  } else if(isTRUE(jsonlite::validate(value))){
    
    value = tryCatch({
      helpers.from.json.to.list(value)
    },
    warning = function(w) {
      return(config::get("WARNING", file = system.file("config/config.yml", package = "tableschema.r")))
    },
    error = function(e) {
      return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
    },
    finally = {
    })
  }
  
  if (!is.list(value)){
    return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
  }
  if (is.null(names(value))) {
    return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
  }
  #if ( ! plain object ) stop(2,call. = FALSE)
  return(value)
}
