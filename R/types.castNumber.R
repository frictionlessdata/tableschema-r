#' @title cast number
#' 
#' @rdname types.castNumber
#' @export
#' @description cast number
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
      error=function(e) error<<-e
    )
  }
  
  if (is.nan(value)) stop("Value is Not a Number", call. = FALSE)
  
  if (percentage) value = value / 100 
  
  return(value)
}


DEFAULT_DECIMAL_CHAR = '.'
DEFAULT_GROUP_CHAR = ''
PERCENT_CHAR = '%‰‱％﹪٪'
CURRENCY_CHAR = '$£€'