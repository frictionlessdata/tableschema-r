#' Check if a field is required
#' @description Indicates whether this field is allowed to be \code{NULL}. 
#' If required is \code{TRUE}, then \code{NULL} is disallowed.
#' See the section on \href{https://frictionlessdata.io/specs/table-schema/#missing-values}{missingValues} for how, 
#' in the physical representation of the data, strings can represent \code{NULL} values. 
#'  
#' @param constraint set TRUE to check required values
#' @param value value to check
#' @return TRUE if field is required
#' @rdname constraints.checkRequired
#' @export
#' 
#' @seealso \href{https://frictionlessdata.io/specs/table-schema/#constraints}{Constraints specifications}
#' 
#' @examples 
#' 
#' constraints.checkRequired(constraint = FALSE, value = 1)
#' 
#' constraints.checkRequired(constraint = TRUE, value = 0)
#' 
#' constraints.checkRequired(constraint = TRUE, value = NULL)
#' 
#' constraints.checkRequired(constraint = TRUE, value = "undefined")
#' 

constraints.checkRequired <- function(constraint, value) {
  
  if (!(isTRUE(constraint) && (is.null(value) | 
                       isTRUE(value == "undefined") | 
                       exists(deparse(substitute(value)))))) {
    return(TRUE)
  }
  
  return(FALSE)
}
