#' Check if maximum constraint is met
#' @description Specifies a maximum value for a field. This is different to \code{maxLength} which checks the number of items in the value. 
#' A maximum value constraint checks whether a field value is equal to or less than the specified value. 
#' The range checking depends on the type of the field. E.g. an integer field may have a maximum value of 100.
#' If a maximum value constraint is specified then the field descriptor \code{MUST} contain a type key.
#' 
#' @param constraint numeric constraint value
#' @param value numeric value to meet the constraint
#' @return TRUE if value is equal to or less than the constraint
#' @rdname constraints.checkMaximum
#' @export
#' 
#' @seealso \href{https://frictionlessdata.io/specs/table-schema/#constraints}{frictionlessdata constraints specifications}
#' 
#' @examples 
#' 
#' constraints.checkMaximum(constraint = list(2), value = 1)
#' 
#' constraints.checkMaximum(constraint = 2, value = 3)
#' 

constraints.checkMaximum <- function(constraint, value) {
  
  if (is.null(value)) return(TRUE)
  
  if (all(value <= constraint)) return(TRUE)
  
  return(FALSE)
  
}