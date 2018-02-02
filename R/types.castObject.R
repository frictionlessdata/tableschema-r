#' @title cast object
#' @description cast object
#' @param format format
#' @param value value
#' @rdname types.castObject
#' @export
#' 

types.castObject <- function(format, value) {
  
  if (!is_object(value)) {
    if (!is.character(value))  return(config::get("ERROR"))
  }
  
  if(is.list(value)) {
    return(value)
    
  } else if(isTRUE(jsonlite::validate(value))){
    
    value = tryCatch({
      helpers.from.json.to.list(value)
    },
    warning = function(w) {
      return(config::get("WARNING"))
    },
    error = function(e) {
      return(config::get("ERROR"))
    },
    finally = {
    })
  }
  
  if (!is.list(value)){
    return(config::get("ERROR"))
  }
  if (is.null(names(value))) {
    return(config::get("ERROR"))
  }
  #if ( ! plain object ) stop(2,call. = FALSE)
  return(value)
}
