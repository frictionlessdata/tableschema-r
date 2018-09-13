#' @title Cast array
#' @description Cast array is used for list objects
#' @param format no options (other than the default)
#' @param value lists, or valid JSON format arrays to cast
#' @rdname types.castArray
#' @export
#' 
#' @seealso \code{\link{types.castList}}, 
#' \href{https://frictionlessdata.io/specs/table-schema/#array}{frictionlessdata array specification} 
#' 
types.castArray <- function(format, value) {
  .Deprecated(new = "types.castList", msg = "'types.castArray' is deprecated.\n Use 'types.castList' instead.")
  types.castList(format, value)
}
