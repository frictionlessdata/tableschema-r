#' is unique
#' 
#' @return TRUE if unique 
#' @rdname constraints.checkUnique
#' @export

constraints.checkUnique <- function (x) {
  all(!anyDuplicated(x))
}