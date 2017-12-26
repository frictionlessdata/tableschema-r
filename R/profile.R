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
        stop(message)
      },
      warning = function(cond) {
        field = FALSE
        # Choose a return value in case of warning
        return(field)
      },
      finally = {
        
      })
      


      
  
    },
    
  
    
    
    validate = function(descriptor) {
      errors = list()
      # Basic validation
      
      
      
      validation = jsonlite::validate(descriptor)
      for (validationError in attr(validation, "err")) {
        errors = append(errors, list(
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
      
      if (length(errors)<1) {
        # PrimaryKey validation
        for (message in private$validatePrimaryKey(helpers.from.json.to.list(descriptor))) {
          errors = append(errors, list(Error = message))
        }

        # ForeignKeys validation
        messages =  private$validateForeignKeys(helpers.from.json.to.list(descriptor))
        for (message in messages) {
          errors = append(errors, list(Error = message))
        }

      }
      return(list(valid = length(errors) < 1, errors = errors))
    }
        ),
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
  # Private
  private = list(
    profile_ = NULL,
    
    jsonschema_ = NULL,
 
    
    # INTERNAL
    
    validatePrimaryKey = function(descriptor) {
      messages = list()
      # const fieldNames = (descriptor.fields || []).map(field => field.name)
      
      fieldNames = if (!("fields" %in% names(descriptor)))
        list()
      else
        purrr::map(descriptor$fields, "name")
      
      if (!is.null(descriptor$primaryKey)) {
        primaryKey = descriptor[["primaryKey"]]

        if (is.character(primaryKey)) {
          if (!(primaryKey  %in% fieldNames)) {
            messages = append(messages, list(
              stringr::str_interp("primary key ${primaryKey} must match schema field names")
            ))
          }
          
        } else if (is.list(primaryKey) && is.null(names(primaryKey))) {
          # or list
          for (pk in primaryKey) {
            if (!(pk %in% fieldNames)) {

              messages = append(messages, list(
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
      fieldNames = if (!("fields" %in% names(descriptor)))
        list()
      else
        purrr::map(descriptor$fields, "name")
      if (!is.null(descriptor$foreignKeys)) {
        foreignKeys = descriptor$foreignKeys
        
        for (fk in foreignKeys) {
          if (is.character(fk$fields)) {

            if (!(fk$fields %in% fieldNames )) {
              messages = append(messages, list(
                stringr::str_interp(
                  "foreign key ${fk.fields} must match schema field names"
                )
              ))
              
            }
            
            if (!is.character(fk$reference$fields)) {
              messages = append(messages, list(
                stringr::str_interp(
                  "foreign key ${fk.reference.fields} must be same type as ${fk.fields}"
                )
              ))
              
            }
            
          } else if (is.list(fk$fields) && is.null(names(fk$fields))) {
            #is.list
            
            for (field in fk$fields) {

              if (!(field %in% fieldNames)) {
                messages = append(messages, list(
                  stringr::str_interp("foreign key ${field} must match schema field names")
                ))
                
              }
              
            }
            
            if (!(is.list(fk$reference$fields) && is.null(names(fk$reference$fields)))) {
              #is.list
              
              messages = append(messages, list(
                stringr::str_interp(
                  "foreign key ${fk.reference.fields} must be same type as ${fk.fields}"
                )
              ))
              
            } else if (length(fk$reference$fields) != length(fk$fields)) {
              messages = append(messages, list(
                stringr::str_interp(
                  'foreign key fields must have the same length as reference.fields'
                )
              ))
              
            }
            
          }
          
          if (fk$reference$resource == '') {
            if (is.character(fk$reference$fields)) {
              if (!(fk$reference$fields %in%  fieldNames)) {
                messages = append(messages, list(
                  stringr::str_interp(
                    "foreign key ${fk.fields} must be found in the schema field names"
                  )
                ))
                
              }
              
            } else if (is.list(fk$reference$fields) && is.null(names(fk$reference$fields))) {
              # is.list
              
              for (field in fk$reference$fields) {
                if (!(field %in% fieldNames)) {
                  messages = append(messages, list(
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
      return(messages)
    }
  )
)

profile.load = function(profile){
  return(Profile$new(profile))
}