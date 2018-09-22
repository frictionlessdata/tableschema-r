#' Check if maximum character length constraint is met
#' @description Specify the maximum length of a character
#' @param constraint numeric constraint, maximum character length
#' @param value character to meet the constraint
#' @return TRUE if character length is equal to or less than the constraint
#' @rdname constraints.checkMaxLength
#' @export
#' 
#' @seealso \href{https://frictionlessdata.io/specs/table-schema/#constraints}{Constraints specifications}
#' 
#' @examples 
#' 
#' constraints.checkMaxLength(constraint = list(2), value = "hi")
#' 
#' constraints.checkMaxLength(constraint = 2, value = "hello")

constraints.checkMaxLength <- function(constraint, value) {
  
  if (is.null(value)) return(TRUE)
  
  if (all(nchar(value) <= constraint)) return(TRUE)
  
  return(FALSE)
}
