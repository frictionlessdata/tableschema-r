#' infer 
#' @param source source
#' @param options options
#' @rdname infer
#' @export
#' 

# Module API

validate <- function(descriptor) {
  
  # https://github.com/frictionlessdata/tableschema-js#infer
  def  = schema.load(descriptor)
  schema = def$value()
  return(list(valid = schema$valid, errors = schema$errors))
}
