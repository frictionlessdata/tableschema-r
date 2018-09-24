#' @title Is valid
#' @description Validate a descriptor over a schema
#' @param descriptor descriptor, one of:
#' \itemize{
#' \item string with the local CSV file (path)
#' \item string with the remote CSV file (url)
#' \item list object
#' }
#' @param schema Contents of the json schema, or a filename containing a schema
#' @return \code{TRUE} if valid
#' @rdname is.valid
#' @export
#' 

is.valid <- function(descriptor, schema = NULL)  {
  
  if (is.null(schema)) {
    #local
    v <- jsonvalidate::json_validator(paste(readLines(system.file('profiles/tableschema.json', package = "tableschema.r"), warn = FALSE, n = -1L), collapse = ""))
  } else {
    v <- jsonvalidate::json_validator(schema)
    #validate = jsonvalidate::json_validate(descriptor, schema)
  }
  validate <- v(descriptor, verbose = TRUE, greedy = TRUE)
  
  class(validate) <- "logical"

  validation <- list(valid = validate, errors = attr(validate,"errors"))
  
  return(validation)
}
