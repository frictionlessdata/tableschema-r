#' @title Cast boolean
#' @description Cast boolean values
#' @param format no options (other than the default)
#' @param value boolean to cast
#' @param options specify additioanl true values or/and falsevalues
#' @rdname types.castBoolean
#' @export
#' @details 
#' In the physical representations of data where boolean values are represented with strings, 
#' the values set in \code{trueValues} and \code{falseValues} are to be cast to their logical representation as booleans. 
#' \code{trueValues} and \code{falseValues} are lists which can be customised to user need. 
#' The default values for these are in the additional properties section below.
#' 
#' The boolean field can be customised with these additional properties:
#' \itemize{
#' \item{trueValues: ["true", "True", "TRUE", "1"]}
#' \item{falseValues: ["false", "False", "FALSE", "0"]}
#' }
#' @seealso \href{https://frictionlessdata.io/specs/table-schema/#boolean}{Types and formats specifications} 
#' 
#' @examples
#' 
#' types.castBoolean(format = "default", value =  TRUE)
#' 
#' types.castBoolean(format = "default", value = "true")
#' 
#' types.castBoolean(format = "default", value = "1")
#' 
#' types.castBoolean(format = "default", value = "0")
#' 
#' # set options with additional true value
#' types.castBoolean(format = "default", value = "yes", list(trueValues = list("yes")))
#' 
#' # set options with additional false value
#' types.castBoolean(format = "default", value = "no", list(falseValues  = list("no")))
#' 

types.castBoolean <- function(format = "default", value, options={}) { #format parameter is not used
  
  if ("trueValues" %in% names(options) || "_TRUE_VALUES" %in% names(options)) TRUE_VALUES <- options[["trueValues"]]
  
  if ("falseValues" %in% names(options)|| "_FALSE_VALUES" %in% names(options)) FALSE_VALUES <- options[["falseValues"]]
  
  
  if  (!is.logical(value)) {
    
    if (!is.character(value)) return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
    
    value <- trimws(value)
    
    if (value %in% TRUE_VALUES) {
      
      value <- TRUE
      
    } else if (value %in% FALSE_VALUES) {
      
      value <- FALSE
      
    } else  {
      
      return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
      
      }
  }
  
  return(value)
  
}



#' default true values
#' @export
 TRUE_VALUES <- c("true", "True", "TRUE", "1")

#' default false values
#' @export
 
 FALSE_VALUES <- c("false", "False", "FALSE", "0")
