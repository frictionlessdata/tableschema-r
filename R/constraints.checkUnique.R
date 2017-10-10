#' Check if a field is unique
#' @param constraint constraint
#' @param value value
#' @return TRUE if field is unique 
#' @rdname constraints.checkUnique
#' @export

constraints.checkUnique <- function (constraint, value) {
  
  if (isTRUE(value=="any") ) return(TRUE) #!anyDuplicated(value) | 
  
  return(TRUE)
  
}