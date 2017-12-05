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
        profile =  file.path(stringr::str_interp("${profiles[[profile]]}"))
        private$jsonschema_ = jsonlite::fromJSON(profile)
        return(private$jsonschema_)
      },
      error = function(cond) {
        message = 'Can\'t load profile'
        TableSchemaError$new(message)$message
      },
      warning = function(cond) {
        field = FALSE
        
        # Choose a return value in case of warning
        return(field)
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
        for (message in validatePrimaryKey(helpers.from.json.to.list(descriptor))) {
          errors = append(errors, list(Error = message))
        }
        
        # ForeignKeys validation
        messages =  validateForeignKeys(helpers.from.json.to.list(descriptor))
        for (message in messages) {
          errors = append(errors, list(Error = message))
        }
        
      }
      return(list(valid = length(errors) < 1, errors = errors))
      }
        ),
  
  active = list(
    
    name = function() {
      
      if (is.null(private$jsonschema_$title)) return (NULL)
      
      return(tolower(gsub(' ', '-', private$jsonschema_$title)))
    },
    
    jsonschema = function() {
      return(private$jsonschema_)
    }
  ),
  
  # Private
  private = list(
    
    profile_ = NULL,
    jsonschema_ = NULL
    
  )
)

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
}

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



#' load profile
#' @param profile profile
#' @param ... other arguments to pass
#' @rdname Profile.load
#' @export

Profile.load = function(profile, ...){
  # Remote
  
  if (is.character(profile) && (startsWith("http",unlist(strsplit(profile,":")))[1] |
      startsWith("https", unlist(strsplit(profile,":")))[1]) ) {
    
    jsonschema = profile
    
    if (is.null(jsonschema)) {
      
      tryCatch( {
        response = httr::GET(profile)
        
        jsonschema = httr::content(response, as = 'text')
      },
      
      error= function(e) {
        TableSchemaError$new(stringr::str_interp("Can not retrieve remote profile '${profile}'"))$message
      })
      
      #cache_[profile] = jsonschema
      profile = jsonschema
    } else profile = urltools::host_extract(urltools::domain(basename(profile)))$host
  }
  return(Profile$new(profile))
}


profiles = list(
  
  geojson = 'inst/profiles/geojson.json',
  
  tableschema = 'inst/profiles/tableschema.json'
  
)

