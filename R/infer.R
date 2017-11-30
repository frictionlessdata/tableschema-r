#' infer 
#' @param source source
#' @param options options
#' @rdname infer
#' @export
#' 

# Module API

infer <- function(source, options = list()) {
  
  # https://github.com/frictionlessdata/tableschema-js#infer
  arguments = list(source)
  arguments = append(arguments, options)

  def2  = do.call(table.load, arguments )
  table = def2$value();
  

  descriptor = table$infer(limit = options[["limit"]])
  
  return(descriptor)
}
