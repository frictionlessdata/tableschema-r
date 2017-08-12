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
    if ( !is.character(value) ) stop("1")
    if ( stringi::stri_length(value) < 1 ) stop("2")
    
    value = gsub('\\s', '', value)
    if (stringi::stri_length(decimalChar) > 0) {
      value = gsub(stringr::str_interp("[${decimalChar}]"), '.', value)
    }
    if (stringi::stri_length(groupChar) > 0) {
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
  
  if (is.nan(value)) stop(3)
  
  if (percentage) value = value / 100 
  
  return(value)
}


DEFAULT_DECIMAL_CHAR = '.'
DEFAULT_GROUP_CHAR = ''
PERCENT_CHAR = '%‰‱％﹪٪'
CURRENCY_CHAR = '$£€'