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
    
    fieldNames = if (!"fields" %in% names(descriptor)) list() else purrr::map(descriptor['fields']$fields,"name" )
    
    if ("primaryKey" %in% names(descriptor)) { # is.null(descriptor["primaryKey"])
    
        primaryKey = descriptor["primaryKey"]
      
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
  },
  
  validateForeignKeys = function (descriptor) {
    
    messages = list()
    
    #const fieldNames = (descriptor.fields || []).map(field => field.name)
    
    if (!is.null(descriptor["foreignKeys]")) {
      
      foreignKeys = descriptor["foreignKeys]")

      for ( fk in seq_along(foreignKeys)) {
        
        if (is.character(fk.fields)) {
          
          if (!fieldNames.includes(fk.fields)) {
            
            messages.push("foreign key ${fk.fields} must match schema field names")
            
          }
          
          if (!is.character(fk.reference.fields)) {
            
            messages.push("foreign key ${fk.reference.fields} must be same type as ${fk.fields}")
            
          }
          
        } else if (is.array(fk.fields)) {
          
          for ( field in seq_along(fk["fields"])) {
            
            if (!fieldNames.includes(field)) {
              
              messages.push("foreign key ${field} must match schema field names")
              
            }
            
          }
          
          if (!is.array(fk.reference.fields)) {
            
            messages.push("foreign key ${fk.reference.fields} must be same type as ${fk.fields}")
            
          } else if (fk.reference.fields.length != length(fk["fields"])) {
            
            messages.push('foreign key fields must have the same length as reference.fields')
            
          }
          
        }
        
        if (fk.reference.resource == '') {
          
          if (isString(fk.reference.fields)) {
            
            if (!fieldNames.includes(fk.reference.fields)) {
              
              messages.push("foreign key ${fk.fields} must be found in the schema field names")
              
            }
            
          } else if (is.array(fk.reference.fields)) { # is.list
            
            for ( field in fk.reference.fields) {
              
              if (!fieldNames %in% field) {
                
                messages.push("foreign key ${field} must be found in the schema field names")
                
              }
              
            }
            
          }
          
        }
        
      }

    }
    
    return (messages)
  }

)

)