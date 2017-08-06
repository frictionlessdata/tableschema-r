#' Extract the field descriptors properties
#' @param descriptor The datapackage.json 
#' 
#' @export get.field.descriptor.properties
#' @importFrom jsonlite fromJSON
#' @importFrom purrr pmap_chr
#' @importFrom purrr pmap_int
#' @importFrom tibble data_frame

get.field.descriptor.properties= function(descriptor) {
  
  if(is.valid(descriptor)==TRUE) {
    
    descriptor.object=jsonlite::fromJSON(descriptor,simplifyVector =T,flatten = F)
  
    field_descriptor_classes= purrr::pmap_chr(descriptor.object$resources$schema$fields , class )
  
    field_descriptor_classes= gsub("data.frame","array/list/object",field_descriptor_classes) # needs fix
  
    field_descriptor_classes_length = purrr::pmap_dbl(descriptor.object$resources$schema$fields , function(x) colSums(!is.na(as.data.frame(x))) )
    
    if (has_name_field_descriptor(descriptor.object)){
      
      df= tibble::data_frame(
        root  = names2(field_descriptor_classes),
        class = field_descriptor_classes,
        items = field_descriptor_classes_length
      )
      
    } else df = message("The field descriptor MUST contain a name property. More spec details in https://specs.frictionlessdata.io/table-schema/#field-descriptors.")
    
  } else df = message("This is not a valid descriptor.")
  
  return(df)
}

#' 
#' @export
#' 
has_name_field_descriptor=function(descriptor){
  "name" %in% names2(descriptor) 
  }



#' OLD
#' @rdname get.field.descriptors.properties
#' @importFrom jsonlite fromJSON
#' @export
#' 

get.field.descriptors.properties=function(descriptor){
  
  if(is.valid(descriptor)==TRUE){
    
    descriptor.object=jsonlite::fromJSON(descriptor, flatten = FALSE)
    
    fields = as.data.frame(descriptor.object[["resources"]][["schema"]][["fields"]])
    
    if ( "name" %in% names(fields) | 
         !length(fields) | 
         !any(is.null(fields$name))
         ) {
      names(fields) 
      
    } else {
      
      message("The field descriptor MUST contain a name property. More spec details in https://specs.frictionlessdata.io/table-schema/#field-descriptors.")
    }
    
  } else message("This is not a valid descriptor.")

}  
# # Test 1 - valid field descriptors
# descriptor='{
#   "description": "Country, regional and world GDP in current US Dollars ($). Regional means collections of countries e.g. Europe & Central Asia. Data is sourced from the World Bank and turned into a standard normalized CSV.",
# "image": "http://assets.okfn.org/p/opendatahandbook/img/data-wrench.png",
# "keywords": [
# "GDP",
# "World",
# "Gross Domestic Product",
# "Time series"
# ],
# "last_updated": "2011-09-21",
# "license": "PDDL-1.0",
# "name": "gdp",
# "resources": [
# {
#   "name": "gdp",
#   "path": "data/gdp.csv",
#   "schema": {
#   "fields": [
#   {
#   "name": "Country Name",
#   "type": "string"
#   },
#   {
#   "foreignkey": "iso-3-geo-codes/id",
#   "name": "Country Code",
#   "type": "string"
#   },
#   {
#   "format": "any",
#   "name": "Year",
#   "type": "date"
#   },
#   {
#   "description": "GDP in current USD",
#   "name": "Value",
#   "type": "number"
#   }
#   ]
#   }
# }
# ],
# "sources": [
# {
#   "name": "World Bank and OECD",
#   "web": "http://data.worldbank.org/indicator/NY.GDP.MKTP.CD"
# }
# ],
# "title": "Country, Regional and World GDP (Gross Domestic Product)",
# "version": "2011"
# }'
# 
#   get.field.descriptor.properties(descriptor)



# # Test 2 - NOT a valid field descriptors - name field is required
# descriptor='
# {
#   "title": "A nicer human readable label or title for the field",
#   "type": "A string specifying the type",
#   "format": "A string specifying a format",
#   "description": "A description for the field",
#   "constraints": {
#   }
#   }'
# 
#   get.field.descriptor.properties(descriptor)

