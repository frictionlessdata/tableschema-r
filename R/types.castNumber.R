#' @title cast number
#' @description cast number
#' @param value value
#' @param format format
#' @param options options
#' @rdname types.castNumber
#' @export
#' 

types.castNumber <- function (format, value, options={}) {
  
  percentage = FALSE
  
  currency = FALSE
  
  decimalChar = DEFAULT_DECIMAL_CHAR
  
  groupChar = DEFAULT_GROUP_CHAR
  
  if ("currency" %in% names(options)) currency = options[["currency"]]
  
  if ("decimalChar" %in% names(options)) decimalChar = options[["decimalChar"]]
  
  if ("groupChar" %in% names(options)) groupChar = options[["groupChar"]]
  
  
  if ( !is.numeric(value) ) {
    
    if ( !is.character(value) ) stop("The input value should be numeric or character", call. = FALSE)
    
    if ( nchar(value) < 1 ) stop("The input value has zero length", call. = FALSE) #stringi::stri_length
    
    value = gsub('\\s', '', value)
    
    if (nchar(decimalChar) > 0) { #stringi::stri_length
      
      value = gsub(stringr::str_interp("[${decimalChar}]"), '.', value)
      
    }
    
    if (nchar(groupChar) > 0) { #stringi::stri_length
      
      value = gsub(stringr::str_interp("[${groupChar}]"), '', value)
      
    }
    
    if (!is.null(currency) && currency != FALSE) {
      
      value = gsub(stringr::str_interp("[${CURRENCY_CHAR}]"), '', value)
      
    }
    
    result = gsub(stringr::str_interp("[${PERCENT_CHAR}]"), '', value)
      
    if (value != result) {
      
      percentage = TRUE
      
      value = result
      
    }
    
    tryCatch(
      
      value = as.numeric(value), 
      
      error=function(e) e
      
    )
    
  }
  
  if (is.nan(value)) stop("Value is Not a Number", call. = FALSE)
  
  if (percentage) value = value / 100 
  
  return(value)
  
}

#' default decimal char
#' @export
DEFAULT_DECIMAL_CHAR = '.'

#' default group char
#' @export
DEFAULT_GROUP_CHAR = ''

#' default percent char
#' @export
PERCENT_CHAR = c("\u066A", # arabic percent sign	
                 "\uFE6A", # small percent sign
                 "\uFF05", # fullwidth percent sign
                 "\u2031", # per thousand sign
                 "\u2030", # per mille sign              
                 "\u0025"  # percent sign
                 )

#' default currecy char
#' @export
CURRENCY_CHAR = c("\u20AC", # euro sign
                  "\u00A3", # pound sign
                  "\u0024"  # dollar sign
                  )