#' evaluate value over a constraint
#' @param constraint constraint
#' @param value value
#' @return TRUE if the constraint of character pattern is met 
#' @rdname constraints.checkPattern
#' @export
#' 

constraints.checkPattern <- function (constraint, value) {
  
  any ( is.null(value) | all(grepl(value,constraint)) ) 
  
}

