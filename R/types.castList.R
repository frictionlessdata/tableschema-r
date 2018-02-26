#' @title cast list
#' @description cast list
#' @param format format
#' @param value value
#' @rdname types.castList
#' @export
#' 
types.castList <- function (format, value) {
  
  if(!is.list(value)) {
    if(!is.character(value)) {
      return(config::get("ERROR"))
    }
  }
  
  if(is.list(value)) {
    return(value)
    
  } else if(isTRUE(jsonlite::validate(value))){
    
    value = tryCatch({
      
      helpers.from.json.to.list(value)
      
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
  
  if (!is.list(value) ) return(config::get("ERROR"))
  
  return (value)
  
}
