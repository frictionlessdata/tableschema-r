#' @title Cast a specific month in a specific year
#' @description  Cast a specific month in a specific year as per \href{https://www.w3.org/TR/xmlschema-2/#gYearMonth}{XMLSchema gYearMonth}. 
#' Usual lexical representation is: YYYY-MM.
#' @param format no options (other than the default)
#' @param value list or string with yearmonth to cast
#' @rdname types.castYearmonth
#' @export
#' 
#' @seealso \href{https://frictionlessdata.io/specs/table-schema/#yearmonth}{Types and formats specifications}
#' 
#' @examples 
#' 
#' types.castYearmonth(format = "default", value = list(2000, 10))
#' 
#' types.castYearmonth(format = "default", value = "2018-11")
#' 

types.castYearmonth <- function(format, value) { 
  
  if ( isTRUE(is_empty(value))) return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
  
  if (any(is.array(value) | is.list(value))) {
    
    if (length(value) != 2 | any(unlist(value) < 0) | unlist(value)[2] > 12 ) return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
    
  } else if (is.character(value) &  !isTRUE(grepl('[a-zA-Z]', value)) ) {
    
    tryCatch({
      
      value = as.list( unlist( strsplit(value, split = "-")))
      
      if ( nchar(as.integer(value[[1]])) != 4 ) return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
      
      #names(value) = c("year", "month")
      
      year = as.integer(value[[1]])
      
      month = as.integer(value[[2]])
      
      #if (!year | !month) return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
      
      if (month < 1 | month > 12) return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
      
      #value = list(year = year, month = month)
      value = list(year, month)
      
      }, 
      warning = function(w) {
        
        return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
        
      },
      
      error = function(e) {
        
        return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
        
      },
      
      finally = {
        
      })
    
  } else return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
  
  return(value)
}
