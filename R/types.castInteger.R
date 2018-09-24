#' @title Cast integer
#' @description Cast integer. Integer values are indicated in the standard way for any valid integer.
#' @param format no options (other than the default)
#' @param value integer to cast
#' @param options named list set bareNumber \code{TRUE} or \code{FALSE}, see details
#' 
#' @details
#'  bareNumber is a boolean field with a default of \code{TRUE}. If \code{TRUE} the physical contents of this field must follow 
#'  the formatting constraints already set out. If \code{FALSE} the contents of this field may contain leading 
#'  and or trailing non-numeric characters (which implementors MUST therefore strip). 
#'  The purpose of \code{bareNumber} is to allow publishers to publish numeric data that contains trailing characters such as percentages
#'  e.g. \code{95}% or leading characters such as currencies e.g. €\code{95} or EUR \code{95}. Note that it is entirely up to implementors what, 
#'  if anything, they do with stripped text.
#'  
#' @rdname types.castInteger
#' 
#' @export
#' 
#' @seealso \href{https://frictionlessdata.io/specs/table-schema/#integer}{Types and formats specifications}
#' 
#' @examples 
#' types.castInteger(format = "default", value = 1)
#' 
#' types.castInteger(format = "default", value = "1")
#' # cast trailing non numeric character
#' types.castInteger(format = "default", value = "1$", options = list(bareNumber = FALSE))
#' 

types.castInteger <- function(format, value, options={}) {
  
  if (!is_integer(value)) {
    
    if (!is.character(value)) return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
    
    if ("bareNumber" %in% names(options)) {
      
      bareNumber <- options[["bareNumber"]]
      
      if (bareNumber == FALSE) {
        
        #value = gsub("(^\\D*)|(\\D*$)", value, "", value)
        value <- stringr::str_replace_all(string = value, pattern = "(^\\D*)|(\\D*$)", replacement = "") #gsub("\\s", "", value)
        
      }
    }
    
    value <- tryCatch({
      
      result <- as.integer(value)
      
      if (is.nan(result) || as.character(result) != value) return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
      
      value <- result
      
    },
    
    warning = function(w) {
      
      return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
      
    },
    
    error = function(e) {
      
      return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
      
    },
    
    finally = {})
    
  }
  
  return(value)
}
