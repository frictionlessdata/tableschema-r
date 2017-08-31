#' Helpers class
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @keywords data
#' @return Object of \code{\link{R6Class}} .
#' @format \code{\link{R6Class}} object.


Helpers <- R6Class("Helpers", public = list())

Helpers$expandFieldDescriptor <- function(descriptor) {
    if (!is.hash(descriptor)) {
        stop("Field descriptor should be a hash instance.")
    }
    if (!has.key("type", descriptor)) {
        descriptor$type <- config::get("DEFAULT_FIELD_TYPE")
    }
    if (!has.key("format", descriptor)) {
        descriptor$format <- config::get("DEFAULT_FIELD_FORMAT")
    }
    return(descriptor)
}



#' Extract the field descriptors properties
#' @param descriptor The datapackage.json 
#' @rdname get.field.descriptor.properties
#' @export 


get.field.descriptor.properties= function(descriptor) {
  
  if(is.valid(descriptor)==TRUE) {
    
    descriptor.object=jsonlite::fromJSON(descriptor,simplifyVector =T,flatten = F)
    
    field_descriptor_classes= purrr::pmap_chr(descriptor.object$resources$schema$fields , class )
    
    field_descriptor_classes= gsub("data.frame","array/list/object",field_descriptor_classes) # needs fix
    
    field_descriptor_classes_length = purrr::pmap_dbl(descriptor.object$resources$schema$fields , function(x) colSums(!is.na(as.data.frame(x))) )
    
    field_descriptor_classes_missing = purrr::pmap_dbl(descriptor.object$resources$schema$fields , function(x) colSums(is.na(as.data.frame(x))) )
    
    if (has_name_field_descriptor(descriptor.object)){
      
      df= data.frame(
        root  = rlang::names2(field_descriptor_classes),
        class = field_descriptor_classes,
        items = field_descriptor_classes_length,
        missing = field_descriptor_classes_missing,
        
        fix.empty.names = FALSE,stringsAsFactors = FALSE
      )
      rownames(df)=NULL
      
    } else df = message("The field descriptor MUST contain a name property. More spec details in https://specs.frictionlessdata.io/table-schema/#field-descriptors.")
    
  } else df = message("This is not a valid descriptor.")
  
  return(df)
}

#' check if name property is missing 
#' @param descriptor descriptor
#' @rdname has_name_field_descriptor
#' @export
#' 
has_name_field_descriptor=function(descriptor){
  "name" %in% rlang::names2(descriptor) | all(!is.na(as.data.frame(descriptor$resources$schema$fields)[,"name"]))
}

#' check binary inputs
#' @rdname is.binary
#' @return TRUE if binary
#' @export

is.binary = function (x) length(unique(na.omit(x)))<=2
