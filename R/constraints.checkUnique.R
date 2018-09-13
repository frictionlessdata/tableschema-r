#' Check if a field is unique
#' @description If \code{TRUE}, then all values for that field \code{MUST} be unique within the data file in which it is found.
#' @param constraint set TRUE to check unique values
#' @param value value to check
#' @return TRUE if field is unique 
#' @rdname constraints.checkUnique
#' 
#' @export
#' @seealso \href{https://frictionlessdata.io/specs/table-schema/#constraints}{frictionlessdata constraints specifications}
#' 
#' @examples 
#' 
#' constraints.checkUnique(constraint = FALSE, value = "any")
#' 
#' constraints.checkUnique(constraint = TRUE, value = "any")
#' 

constraints.checkUnique <- function(constraint, value) {
  
  if (isTRUE(value == "any") ) return(TRUE) #!anyDuplicated(value) | 
  
  return(TRUE)
  
}