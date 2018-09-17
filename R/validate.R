#' validate descriptor
#' @description Validates whether a schema is a validate Table Schema accordingly to the specifications. 
#' It does not validate data against a schema.
#' @param descriptor schema descriptor, one of:
#' \itemize{
#' \item string with the local CSV file (path)
#' \item string with the remote CSV file (url)
#' \item list object
#' }
#' @return \code{TRUE} on valid
#' @rdname validate
#' @export
#' 

# Module API

validate <- function(descriptor) {
  
  # https://github.com/frictionlessdata/tableschema-js#infer
  def  = Schema.load(descriptor)
  schema = future::value(def)
  return(list(valid = schema$valid, errors = schema$errors))
}
