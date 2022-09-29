#' Check if minimum character length constraint is met
#' @description Specify the minimum length of a character
#' @param constraint numeric constraint, minimum character length
#' @param value character to meet the constraint
#' @return TRUE if character length is equal to or greater than the constraint 
#' @rdname constraints.checkMinLength
#' @export
#' 
#' @seealso \href{https://specs.frictionlessdata.io//table-schema/#constraints}{Constraints specifications}
#' 
#' @examples 
#' 
#' constraints.checkMinLength(constraint = list(3), value = "hi")
#' 
#' constraints.checkMinLength(constraint = 2, value = "hello")

constraints.checkMinLength <- function(constraint, value){
  
  if (is.null(value)) return(TRUE)
  
  if (all(nchar(value) >= constraint)) return(TRUE)
  
  return(FALSE)
}