#' evaluate value over a constraint
#' @param constraint constraint
#' @param value value
#' @return TRUE if the constraint of character pattern is met 
#' @rdname constraints.checkPattern
#' @export
#' 

constraints.checkPattern <- function (constraint, value) {
  
  if( is.null(value) ) return (TRUE)
  
  if (isTRUE(grepl(value,constraint))) return (TRUE)
  
  return (FALSE)
  
}
