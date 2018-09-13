#' Check Enum
#' @description Check if the value is exactly match a constraint.
#' @param constraint numeric list,matrix or vector with the constraint values
#' @param value numeric value to meet the constraint
#' @return TRUE if value meets the constraint
#' @rdname constraints.checkEnum
#' @export
#' 
#' @seealso \href{https://frictionlessdata.io/specs/table-schema/#constraints}{frictionlessdata constraints specifications}
#' 
#' @examples 
#' 
#' constraints.checkEnum(constraint = list(1, 2), value = 1)
#' 
#' constraints.checkEnum(constraint = list(1, 2), value = 3)

constraints.checkEnum <- function(constraint, value) {
  
  if (is.null(value)) return(TRUE)
  
  if (all(value %in% constraint)) return(TRUE)
  
  return(FALSE)
  
}
