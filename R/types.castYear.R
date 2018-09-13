#' @title Cast year
#' @description Cast year. A calendar year as per \href{https://www.w3.org/TR/xmlschema-2/#gYear}{XMLSchema gYear}. 
#' Usual lexical representation is: YYYY.
#' @param format no options (other than the default)
#' @param value year to cast
#' @rdname types.castYear
#' @export
#' 
#' @seealso \href{https://frictionlessdata.io/specs/table-schema/#year}{frictionlessdata year specification}
#' 
#' @examples 
#' 
#' types.castYear(format = "default", value = 2000)
#' 
#' types.castYear(format = "default", value = "2010")
#' 

types.castYear <- function(format, value) { 
   
  if (!is_integer(value)) {
    
    if (!is.character(value)) return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
    
    if (nchar(value) != 4) return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
    
    tryCatch({
      
      result = as.integer(value)
      
      if (is.nan(result) | as.character(result) != value)  return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
      
      value = result
    },
    
    warning = function(w) {
      message(config::get("WARNING", file = system.file("config/config.yml", package = "tableschema.r")))
    },
    
    error = function(e) {
      return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
    },
    finally = {})
  }
  
  if (value < 0 | value > 9999) return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
  
  return(value)
}