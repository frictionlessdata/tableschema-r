#' @title Is valid
#' @param descriptor descriptor
#' @param schema schema
#' @description is.valid
#' @rdname is.valid
#' @export

is.valid = function(descriptor, schema = NULL)  {
  
  if (is.null(schema)) {
    
    #local
    
    v = jsonvalidate::json_validator(paste(readLines('inst/profiles/tableschema.json', warn = FALSE, n=-1L), collapse=""))
    
    
  } else {
    v = jsonvalidate::json_validator(schema)
    
    #validate = jsonvalidate::json_validate(descriptor, schema)
    
  }
  validate = v(descriptor, verbose = TRUE, greedy=TRUE)
  
  class(validate)="logical"
  
  
  validation=list(valid=validate, errors=attr(validate,"errors"))
  
  return(validation)
}
