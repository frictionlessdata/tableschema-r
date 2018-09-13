#' @title Cast object
#' @description Cast object data which is lists or valid JSON.
#' @param format no options (other than the default)
#' @param value object to cast
#' @rdname types.castObject
#' @export
#' 
#' @seealso \href{https://frictionlessdata.io/specs/table-schema/#object}{frictionlessdata object specification}
#' 
#' @examples 
#' 
#' types.castObject(format = "default", value = list())
#' 
#' types.castObject(format = "default", value = "{}")
#' 
#' types.castObject(format = "default", value = '{"key": "value"}')
#' 
types.castObject <- function(format, value) {
  
  if (!is_object(value)) {
    if (!is.character(value))  return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
  }
  
  if (is.list(value)) {
    return(value)
    
  } else if (isTRUE(jsonlite::validate(value))) {
    
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
  
  if (!is.list(value)) {
    return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
  }
  if (is.null(names(value))) {
    return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
  }
  #if ( ! plain object ) stop(2,call. = FALSE)
  return(value)
}
