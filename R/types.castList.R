#' @title Cast list
#' @description cast list
#' @param format no options (other than the default)
#' @param value lists, or valid JSON format arrays to cast
#' @rdname types.castList
#' @export
#' 
#' @seealso \href{https://specs.frictionlessdata.io//table-schema/#array}{Types and formats specifications} 
#' 
#' @examples 
#' 
#' types.castList(format = "default", value =  list())
#' 
#' types.castList(format = "default", value = list('key', 'value'))
#' 
#' types.castList(format = "default", value = '["key", "value"]') # cast valid json array
#' 

types.castList <- function(format, value) {
  
  if (!is.list(value)) {
    if (!is.character(value)) {
      return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
    }
  }
  
  if (is.list(value)) {
    return(value)
    
  } else if (isTRUE(jsonlite::validate(value))) {
    
    value <- tryCatch({
      
      helpers.from.json.to.list(value)
      
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
  
  if (!is.list(value) ) return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
  
  return(value)
  
}
