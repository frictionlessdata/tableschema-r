#' @title Cast numbers of any kind including decimals
#' @description Cast numbers of any kind including decimals.
#' @param format no options (other than the default)
#' @param value number to cast
#' @param options available options are "decimalChar", "groupChar" and "bareNumber", where
#' \describe{
#' \item{\code{decimalChar }}{A string whose value is used to represent a decimal point within the number. The default value is ".".}
#' \item{\code{groupChar }}{A string whose value is used to group digits within the number. The default value is null. A common value is "," e.g. "100,000".}
#' \item{\code{bareNumber }}{A boolean field with a default of \code{TRUE} If \code{TRUE} the physical contents of this field must follow 
#' the formatting constraints already set out. If \code{FALSE} the contents of this field may contain leading and/or 
#' trailing non-numeric characters (which implementors MUST therefore strip). The purpose of \code{bareNumber} is to allow publishers 
#' to publish numeric data that contains trailing characters such as percentages e.g. 95% or leading characters such as currencies 
#' e.g. €95 or EUR 95. Note that it is entirely up to implementors what, if anything, they do with stripped text.}
#' }
#' @details 
#' The lexical formatting follows that of decimal in \href{https://www.w3.org/TR/xmlschema-2/#decimal}{XMLSchema}: a non-empty finite-length sequence 
#' of decimal digits separated by a period as a decimal indicator. An optional leading sign is allowed. If the sign is omitted, "+" is assumed. 
#' Leading and trailing zeroes are optional. If the fractional part is zero, the period and following zero(es) can be omitted. 
#' For example: '-1.23', '12678967.543233', '+100000.00', '210'.
#' 
#' The following special string values are permitted (case need not be respected):
#' \itemize{
#' \item{\code{NaN}: not a number}
#' \item{\code{INF}: positive infinity}
#' \item{\code{-INF}: negative infinity}
#' }
#' 
#' A number MAY also have a trailing:
#' \itemize{
#' \item{\code{exponent}: this \code{MUST} consist of an E followed by an optional + or - sign followed by one or more decimal digits (0-9)}
#' }
#' @rdname types.castNumber
#' 
#' @seealso \href{https://frictionlessdata.io/specs/table-schema/#number}{Types and formats specifications}
#' @export
#' 
#' @examples 
#' 
#' types.castNumber(format = "default", value = 1)
#' types.castNumber(format = "default", value = "1.0")
#' 
#' # cast number with  percent sign
#' types.castNumber(format = "default", value = "10.5%", options = list(bareNumber = FALSE))
#' 
#' # cast number with comma group character
#' types.castNumber(format = "default", value = "1,000", options = list(groupChar = ','))
#' types.castNumber(format = "default", value = "10,000.50", options = list(groupChar = ','))
#' 
#' # cast number with "#" group character and "&" as decimal character
#' types.castNumber(format = "default", value = "10#000&50", 
#' options = list(groupChar = '#', decimalChar = '&'))
#' 

types.castNumber <- function(format, value, options={}) {
  
  if ("decimalChar" %in% names(options)) decimalChar <- options[["decimalChar"]] else decimalChar <- DEFAULT_DECIMAL_CHAR 
  
  if ("groupChar" %in% names(options)) groupChar <- options[["groupChar"]] else groupChar <- DEFAULT_GROUP_CHAR
  
  
  if ( !is.numeric(value)) {
    
    if (!is.character(value))  return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
    
    if (isTRUE(nchar(value) < 1)) return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
    
    value <- stringr::str_replace_all(string = value, pattern = "[\\s]", replacement = "") #gsub("\\s", "", value)
    
    if ("decimalChar" %in% names(options)) { #stringi::stri_length
      #value = gsub(paste("[",paste(decimalChar,collapse=""),"]",sep=""), ".", value)
      value <- stringr::str_replace_all(string = value, pattern = stringr::str_interp("[${decimalChar}]"), replacement = ".") #gsub("\\s", "", value)
    }
    
    if ("groupChar" %in% names(options)) { #stringi::stri_length
      #value = gsub(paste("[",paste(groupChar,collapse=""),"]",sep=""), "", value)
      value <- stringr::str_replace_all(string = value, pattern = stringr::str_interp("[${groupChar}]"), replacement = "") #gsub("\\s", "", value)
    }
    
    if ("bareNumber" %in% names(options)) {
      
      bareNumber <- options[["bareNumber"]]
      
      if (bareNumber == FALSE) {
        #value = gsub("(^\\D*)|(\\D*$)", "", value)
        value <- stringr::str_replace_all(string = value, pattern = "(^\\D*)|(\\D*$)", replacement = "") #gsub("\\s", "", value)
        
      }
    }
    
    value <- tryCatch({
      
      as.numeric(value)
      
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
  
  if (is.null(value) || is.nan(value)) {
    return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
  }
  
  return(value)
}

#' default decimal char
#' @export

DEFAULT_DECIMAL_CHAR <- '.'

#' default group char
#' @export
DEFAULT_GROUP_CHAR <- ''

# #' default percent char
# #' @export
# PERCENT_CHAR = c("\u066A", # arabic percent sign	
#                  "\uFE6A", # small percent sign
#                  "\uFF05", # fullwidth percent sign
#                  "\u2031", # per thousand sign
#                  "\u2030", # per mille sign              
#                  "\u0025"  # percent sign
#                  )
# 
# #' default currecy char
# #' @export
# CURRENCY_CHAR = c("\u20AC", # euro sign
#                   "\u00A3", # pound sign
#                   "\u0024"  # dollar sign
#                   )