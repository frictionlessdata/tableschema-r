#' @title cast number
#' @description cast number
#' @param value value
#' @param format format
#' @param options options decimalChar,groupChar, bareNumber
#' @rdname types.castNumber
#' @export
#' 

types.castNumber <- function (format, value, options={}) {
  
  if ("decimalChar" %in% names(options)) decimalChar = options[["decimalChar"]] else decimalChar = DEFAULT_DECIMAL_CHAR 
  
  if ("groupChar" %in% names(options)) groupChar = options[["groupChar"]] else groupChar = DEFAULT_GROUP_CHAR
  
  
  if ( !is.numeric(value) ) {
    
    if ( !is.character(value) )  return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
    
    if ( isTRUE(nchar(value) < 1) ) return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
    
    value = stringr::str_replace_all(string=value, pattern="[\\s]", repl="") #gsub("\\s", "", value)
    
    if ("decimalChar" %in% names(options) ) { #stringi::stri_length
      
      #value = gsub(paste("[",paste(decimalChar,collapse=""),"]",sep=""), ".", value)
      
      value = stringr::str_replace_all(string=value, pattern=stringr::str_interp("[${decimalChar}]"), repl=".") #gsub("\\s", "", value)
      
    }
    
    if ("groupChar" %in% names(options)) { #stringi::stri_length
      
      #value = gsub(paste("[",paste(groupChar,collapse=""),"]",sep=""), "", value)
      value = stringr::str_replace_all(string=value, pattern=stringr::str_interp("[${groupChar}]"), repl="") #gsub("\\s", "", value)
      
    }
    
    if ("bareNumber" %in% names(options)) {
      
      bareNumber = options[["bareNumber"]]
      
      if (bareNumber==FALSE){
        
        #value = gsub("(^\\D*)|(\\D*$)", "", value)
        value = stringr::str_replace_all(string=value, pattern="(^\\D*)|(\\D*$)", repl="") #gsub("\\s", "", value)
        
      }
    }
    
    value = tryCatch({
      
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
  
  
  if (is.null(value) || is.nan(value)) return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
  
  return(value)
  
}

#' default decimal char
#' @export
DEFAULT_DECIMAL_CHAR = '.'

#' default group char
#' @export
DEFAULT_GROUP_CHAR = ''

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