#' validate descriptor
#' @param descriptor descriptor
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
