#' Check if minimum constraint is met
#' @description Specifies a minimum value for a field. This is different to \code{minLength} which checks the number of items in the value. 
#' A minimum value constraint checks whether a field value is greater than or equal to the specified value. 
#' The range checking depends on the type of the field. E.g. an integer field may have a minimum value of 100.
#' If a minimum value constraint is specified then the field descriptor \code{MUST} contain a type key.
#' 
#' @param constraint numeric constraint value
#' @param value numeric value to meet the constraint
#' @return TRUE if value is equal to or greater than the constraint
#' @rdname constraints.checkMinimum
#' @export
#' 
#' @seealso \href{https://frictionlessdata.io/specs/table-schema/#constraints}{frictionlessdata constraints specifications}
#' 
#' @examples 
#' 
#' constraints.checkMinimum(constraint = list(2), value = 1)
#' 
#' constraints.checkMinimum(constraint = 2, value = 3)

constraints.checkMinimum <- function(constraint, value) {
  
  if (is.null(value)) return(TRUE)
  
  if (all(value >= constraint)) return(TRUE)
  
  return(FALSE)
  
}