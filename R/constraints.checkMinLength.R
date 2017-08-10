#' Check Minimum Length of Character/s according to a constraint
#' 
#' @return TRUE if the constraint of minimum character length is met 
#' @rdname constraints.checkMinLength
#' @export

constraints.checkMinLength <- function(constraint, value){
  
  any( is.null(value) | nchar(value) >= constraint )
  
}