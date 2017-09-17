#' Profile class
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @include types.R
#' @include constraints.R
#' @keywords data
#' @return Object of \code{\link{R6Class}} .
#' @format \code{\link{R6Class}} object.

Profile <- R6Class(
"Profile",
# PUBLIC
public = list(
  initialize = function(profile) {
    # Set attributes
  
  },
  validate = function(descriptor = list()){
    return(list("valid" = TRUE))
  }
  
  
),

# Private
private = list(
  
  profile_ = NULL,
  
  jsonschema_ = tryCatch({
    
    load(readLines('./inst/profiles/${profile}.json'))
    
  },
  
  error = function(e) {
    
    message = stringr::str_interp('Can\'t load profile "${profile}"')

    return(TableSchemaError$new(message))
    
  },
  
  warning = function(w) {
    
    message(config::get("WARNING"))
    
  },
  
  finally = {
    
  }),
  
  # INTERNAL
  
  validatePrimaryKey = function (descriptor) {
  
    messages = list()
    
    # const fieldNames = (descriptor.fields || []).map(field => field.name)
    
    if (!is.null(descriptor["primaryKey"])) {
    
        #const primaryKey = descriptor["primaryKey"]
      
        if (is.character(primaryKey)) {
        
          if (!fieldNames %in% primaryKey) {
          
            messages.push("primary key ${primaryKey} must match schema field names")
          }
          
        } else if (is.array(primaryKey)) { # or list
          
          for (pk in seq_along(primaryKey)) {
            
            if (!fieldNames.includes(pk)) {
              
              messages.push("primary key ${pk} must match schema field names")
              
            }
          }
        }
    }
    
    return (messages)
  }

)

)