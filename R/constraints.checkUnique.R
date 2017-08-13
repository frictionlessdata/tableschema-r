#' is unique
#' @param constraint constraint
#' @param value value
#' @return TRUE if unique 
#' @rdname constraints.checkUnique
#' @export

constraints.checkUnique <- function (x) {
  all(!anyDuplicated(x))
}