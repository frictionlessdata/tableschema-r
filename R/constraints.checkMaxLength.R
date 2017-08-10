#' Check Maximum Length of Character/s according to a constraint
#' 
#' @return TRUE if the constraint of maximum character length is met 
#' @rdname constraints.checkMaxLength
#' @export

constraints.checkMaxLength <- function(constraint, value){
  
  any( is.null(value) | nchar(value) <= constraint )

}