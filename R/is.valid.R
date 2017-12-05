#' @title Is valid
#' @param descriptor descriptor
#' @description is.valid
#' @rdname is.valid
#' @export

is.valid = function(descriptor)  {
  
    #local
    v = jsonvalidate::json_validator(paste(readLines("https://schemas.frictionlessdata.io/data-package.json"), collapse=""))

  validate=v(descriptor, verbose = TRUE, greedy=TRUE,error=FALSE)
  class(validate)="logical"
  
  #.print.validator(valid)
  validation=list(valid=validate, errors=attr(validate,"errors"))
  return(validation)
}

# #' @title print validator
# #' @param x x
# #' @param ... other parameters
# #' @rdname .print.validator
# #' @export
# #' 
# .print.validator = function (x, ...){
#   inherits(x,"logical")
#   cat("This is a valid input descriptor:\n")
#   x
# }
# 
# 
# 
# 
# json='{
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
