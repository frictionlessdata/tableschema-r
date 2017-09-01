#' @title cast number
#' @description cast number
#' @param value value
#' @param format format
#' @param options options
#' @rdname types.castNumber
#' @export
#' 

types.castNumber <- function (format, value, options={}) {
  
  decimalChar = DEFAULT_DECIMAL_CHAR # or through options
  
  groupChar = DEFAULT_GROUP_CHAR
  
  if ("decimalChar" %in% names(options)) decimalChar = options[["decimalChar"]]
  
  if ("groupChar" %in% names(options)) groupChar = options[["groupChar"]]
  
  
  if ( !is.numeric(value) ) {
    
    if ( !is.character(value) )  return(config::get("ERROR"))
    
    if ( nchar(value) < 1 ) return(config::get("ERROR"))
    
    value = gsub("\\s", "", value)
    
    if (nchar(decimalChar) > 0) { #stringi::stri_length
      
      value = gsub(paste("[",paste(decimalChar,collapse=""),"]",sep=""), ".", value)
      
    }
    
    if (nchar(groupChar) > 0) { #stringi::stri_length
      
      value = gsub(paste("[",paste(groupChar,collapse=""),"]",sep=""), "", value)
      
    }
    
    if (!missing(options)){
      
      if ("bareNumber" %in% names(options)) {
        
        bareNumber = options[["bareNumber"]]
        
        value = gsub(gregexpr("((^\\D*)|(\\D*$))"), "", value)
        
      }
      
    }
    
    #tryCatch(
      
      value = as.numeric(value)#, 
      
    #  error=function(e) error<<-e
      
  #  )
    
  }
  
  if (is.nan(value)) return(config::get("ERROR"))
  
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