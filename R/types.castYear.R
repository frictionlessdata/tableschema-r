#' @title cast year
#' 
#' @rdname types.castYear
#' @export
#' @description cast year
#' 
types.castYear <- function (format, value) {
  
  if(!is.integer(value)){
    if (!is.character(value)) stop()
    if (nchar !=4) stop()
    
    tryCatch({
      
      if (is.nan(result) | as.character(result)!= value) stop()
    })
  }
  
  if (value < 0 | value > 9999) stop()
  
  return(value)
  
}

  if (!lodash.isInteger(value)) {
    if (!lodash.isString(value)) {
      return ERROR
    }
    if (value.length !== 4) {
      return ERROR
    }
    try {
      const result = parseInt(value, 10)
      if (lodash.isNaN(result) || result.toString() !== value) {
        return ERROR
      }
      value = result
    } catch (error) {
      return ERROR
    }
  }
  if (value < 0 || value > 9999) {
    return ERROR
  }
  return value
}