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
  
  active = list(
    
    name = function() {
      
      if (!this._jsonschema$title) NULL
      
      return (tolower(gsub(' ', '-', this._jsonschema$title)))
      
    },
    
    jsonschema = function() {
      
      return (this._jsonschema)
      
    }
  ),
  
    
  validate= function(descriptor) {
      
      errors = list()
      
      # Basic validation
      validateMultiple = jsonvalidate::json_validator(paste(readLines(this._jsonschema), collapse="")) 
      
      validation=validateMultiple(descriptor,verbose = T, greedy=TRUE,error=F)
      
      for (validationError in validation$errors) {
        
        errors = modifyList(errors, list(Error=stringr::str_interp(
          'Descriptor validation error:
            ${validationError.message}
          at "${validationError.dataPath}" in descriptor and
          at "${validationError.schemaPath}" in profile'
          )))

      }
      
      # Extra validation
      
      if (!length(errors)) {
        
        # PrimaryKey validation
        
        for (message in validatePrimaryKey(descriptor)) {
          
          errors = modifyList(errors, list(Error=message) )
          
        }
        
        # ForeignKeys validation
        
        for (message in validateForeignKeys(descriptor)) {
          
          errors = modifyList(errors, list(Error=message) )
          
        }
        
      
    }
    
    return (valid= c(!length(errors), errors) )
  },
  
  validate = function(descriptor = list()){
    return(list("valid" = TRUE))
  }
  ),

# Private
private = list(
  
  profile_ = NULL,
  
  jsonschema_ = tryCatch({
    
    load(readLines(stringr::str_interp('./inst/profiles/${profile}.json')))
    
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
          
            messages = modifyList(messages,list(stringr::str_interp("primary key ${primaryKey} must match schema field names")))
          }
          
        } else if (is.array(primaryKey)) { # or list
          
          for (pk in primaryKey ) {
            
            if (!fieldNames (pk)) {
              
              messages = modifyList(messages,list(stringr::str_interp("primary key ${pk} must match schema field names")))
              
            }
          }
        }
    }
    
    return (messages)
  },
  
  validateForeignKeys = function (descriptor) {
    
    messages = list()
    
    #const fieldNames = (descriptor.fields || []).map(field => field.name)
    
    if (!is.null(descriptor["foreignKeys"])) {
      
      foreignKeys = descriptor["foreignKeys"]

      for ( fk in foreignKeys) {
        
        if (is.character(descriptor$fields[[fk]]) ) {
          
          if (!fieldNames %in% descriptor$fields[[fk]] ) {
            
            messages = modifyList(messages,list(stringr::str_interp("foreign key ${fk.fields} must match schema field names")))
            
          }
          
          if (!is.character(reference$fields[fk])) {
            
            messages = modifyList(messages,list(stringr::str_interp("foreign key ${fk.reference.fields} must be same type as ${fk.fields}")))
            
          }
          
        } else if (is.array(fields[fk])) { #is.list
          
          for ( field in fields["fk"]) {
            
            if (!fieldNames %in% names(field) ) {
              
              messages = modifyList(messages,list(stringr::str_interp("foreign key ${field} must match schema field names")))
              
            }
            
          }
          
          if (!is.array(reference$fields[fk])) { #is.list
            
            messages = modifyList(messages,list(stringr::str_interp("foreign key ${fk.reference.fields} must be same type as ${fk.fields}")))
            
          } else if (length(reference$fields[fk]) != length(fields["fk"])) {
            
            messages = modifyList(messages,list(stringr::str_interp('foreign key fields must have the same length as reference.fields')))
            
          }
          
        }
        
        if (reference$resource[fk] == '') {
          
          if (is.character(reference$fields[fk])) {
            
            if (!fieldNames %in% reference$fields[fk]) {
              
              messages = modifyList(messages, list(stringr::str_interp("foreign key ${fk.fields} must be found in the schema field names")))
              
            }
            
          } else if (is.array(reference$fields[fk])) { # is.list
            
            for ( field in reference$fields[fk]) {
              
              if (!fieldNames %in% field) {
                
                messages = modifyList(messages, list(stringr::str_interp("foreign key ${field} must be found in the schema field names")))
                
              }
              
            }
            
          }
          
        }
        
      }

    }
    
    return (message(messages))
  }
)
)