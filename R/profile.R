#' Profile class
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @include types.R
#' @include constraints.R
#' @include tableschemaerror.R
#' @keywords data
#' @return Object of \code{\link{R6Class}} .
#' @format \code{\link{R6Class}} object.

Profile <- R6Class(
  "Profile",
  # PUBLIC
  public = list(
    initialize = function(profile) {
      tryCatch({
        private$jsonschema_ = readr::read_file( system.file(profiles[[profile]], package = "tableschema.r"))
        return(private$jsonschema_)
      },
      error = function(cond) {
        message = 'Can\'t load profile'
        stop(TableSchemaError$new(message))
      },
      warning = function(cond) {
        field = FALSE
        
        # Choose a return value in case of warning
        return(field)
      },
      finally = {
        
      })
      
      browser()
      

      
  
    },
    
    active = list(
      name = function() {
        if (!private$jsonschema_$title)
          NULL
        
        return(tolower(gsub(' ', '-', private$jsonschema_$title)))
        
      },
      
      jsonschema = function() {
        return(private$jsonschema_)
        
      }
    ),
    
    
    validate = function(descriptor) {
      errors = list()
      # Basic validation
      
      
      
      validation = jsonlite::validate(descriptor)
      
      for (validationError in attr(validation, "err")) {
        errors = modifyList(errors, list(
          Error = stringr::str_interp(
            'Descriptor validation error:
            ${validationError}
           '
          )
          ))
        
      }
      if (validation == TRUE) {
        
         validation = jsonvalidate::json_validate(descriptor, private$jsonschema_, greedy = TRUE, verbose = TRUE)
        errs = attr(validation,"errors")
         for (i in rownames(errs) ) {
           errors = c(errors, stringr::str_interp(
            'Descriptor validation error:
            ${errs[i, "field"]} - ${errs[i, "message"]}'
           
          )
          )
           
         }
        
      }

      # Extra validation
      
      if (!length(errors)) {
        # PrimaryKey validation
        
        for (message in private$validatePrimaryKey(descriptor)) {
          errors = modifyList(errors, list(Error = message))
        }
        
        # ForeignKeys validation
        
        for (message in private$validateForeignKeys(descriptor)) {
          errors = modifyList(errors, list(Error = message))
        }
      }
      return(list(valid = length(errors) < 1, errors = errors))
    }
        ),
  
  # Private
  private = list(
    profile_ = NULL,
    
    jsonschema_ = NULL,
 
    
    # INTERNAL
    
    validatePrimaryKey = function(descriptor) {
      messages = list()
      
      # const fieldNames = (descriptor.fields || []).map(field => field.name)
      
      fieldNames = if (!"fields" %in% names(descriptor))
        list()
      else
        purrr::map(descriptor['fields']$fields, "name")
      
      if ("primaryKey" %in% names(descriptor)) {
        # is.null(descriptor["primaryKey"])
        
        primaryKey = descriptor["primaryKey"]
        
        if (is.character(primaryKey)) {
          if (!fieldNames %in% primaryKey) {
            messages = modifyList(messages, list(
              stringr::str_interp("primary key ${primaryKey} must match schema field names")
            ))
          }
          
        } else if (is.array(primaryKey)) {
          # or list
          
          for (pk in primaryKey) {
            if (!fieldNames(pk)) {
              messages = modifyList(messages, list(
                stringr::str_interp("primary key ${pk} must match schema field names")
              ))
              
            }
          }
        }
      }
      
      return(messages)
    },
    
    validateForeignKeys = function(descriptor) {
      messages = list()
      descriptor = jsonlite::fromJSON(descriptor)
      
      fieldNames = descriptor$fields[["name"]]
      return(list())
      if (!is.null(descriptor$foreignKeys)) {
        foreignKeys = descriptor$foreignKeys
        
        for (fk in foreignKeys) {
          if (is.character(descriptor$fields[[fk]])) {
            if (! descriptor$fields[[fk]] %in% fieldNames ) {
              messages = modifyList(messages, list(
                stringr::str_interp(
                  "foreign key ${fk.fields} must match schema field names"
                )
              ))
              
            }
            
            if (!is.character(desciptor$foreignKeys$reference$fields[[fk]])) {
              messages = modifyList(messages, list(
                stringr::str_interp(
                  "foreign key ${fk.reference.fields} must be same type as ${fk.fields}"
                )
              ))
              
            }
            
          } else if (is.array(descriptor$fields[[fk]])) {
            #is.list
            
            for (field in descriptor$fields[["fk"]]) {
              if (!fieldNames %in% names(field)) {
                messages = modifyList(messages, list(
                  stringr::str_interp("foreign key ${field} must match schema field names")
                ))
                
              }
              
            }
            
            if (!is.array(reference$fields[fk])) {
              #is.list
              
              messages = modifyList(messages, list(
                stringr::str_interp(
                  "foreign key ${fk.reference.fields} must be same type as ${fk.fields}"
                )
              ))
              
            } else if (length(reference$fields[fk]) != length(fields["fk"])) {
              messages = modifyList(messages, list(
                stringr::str_interp(
                  'foreign key fields must have the same length as reference.fields'
                )
              ))
              
            }
            
          }
          
          if (reference$resource[fk] == '') {
            if (is.character(reference$fields[fk])) {
              if (!fieldNames %in% reference$fields[fk]) {
                messages = modifyList(messages, list(
                  stringr::str_interp(
                    "foreign key ${fk.fields} must be found in the schema field names"
                  )
                ))
                
              }
              
            } else if (is.array(reference$fields[fk])) {
              # is.list
              
              for (field in reference$fields[fk]) {
                if (!fieldNames %in% field) {
                  messages = modifyList(messages, list(
                    stringr::str_interp(
                      "foreign key ${field} must be found in the schema field names"
                    )
                  ))
                  
                }
                
              }
              
            }
            
          }
          
        }
        
      }
      
      return(message(messages))
    }
  )
)