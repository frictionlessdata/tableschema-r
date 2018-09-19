#' Pattern matching
#' @description Search for pattern matches (value) within a character vector (constraint).
#' A regular expression is used to test field values. 
#' If the regular expression matches then the value is valid. 
#' The values of this field \code{MUST} conform to the standard 
#' \href{http://www.w3.org/TR/xmlschema-2/#regexs}{XML Schema regular expression syntax}.
#' 
#' @param constraint character vector where matches are sought
#' @param value character string to be matched
#' @return TRUE if the pattern constraint is met 
#' @rdname constraints.checkPattern
#' @export
#' 
#' @seealso \href{https://frictionlessdata.io/specs/table-schema/#constraints}{Constraints specifications}
#' 
#' @examples 
#' 
#' constraints.checkPattern(constraint = '^test$', value = 'test')
#' 
#' constraints.checkPattern(constraint = '^test$', value = 'TEST')

constraints.checkPattern <- function(constraint, value) {
  
  if (is.null(value)) return(TRUE)
  
  if (isTRUE(grepl(value, constraint))) return(TRUE)
  
  return(FALSE)
  
}
