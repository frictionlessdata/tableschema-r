#' Profile class
#' @description Class to represent JSON Schema profile from \href{https://frictionlessdata.io/schemas/registry.json}{Profiles Registry}.
#' 
#' @usage # Profile.load(profile)
#' @param profile string profile name in registry or URL to JSON Schema
#' 
#' 
#' @section Methods:
#' \describe{
#' 
#' \item{\code{Profile$new(descriptor = descriptor)}}{
#' Use \code{\link{Profile.load}} to instantiate \code{Profile} class.}
#' 
#'   \item{\code{validate(descriptor)}}{
#' Validate a tabular data package descriptor against the \code{Profile}.}
#' \itemize{
#'  \item{\code{descriptor }}{Retrieved and dereferenced tabular data package descriptor.}  
#'  \item{\code{(Object) }}{Returns \code{TRUE} if descriptor is valid or \code{FALSE} with error message.}
#'  }
#'
#' }
#' 
#' @section Properties:
#' \describe{
#'   \item{\code{name}}{Returns profile name if available.}
#'   \item{\code{jsonschema}}{Returns profile JSON Schema contents.}
#' }
#' 
#' @seealso \href{http://frictionlessdata.io/specs/profiles/}{Profile Specifications}
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
#' 

Profile <- R6Class(
  "Profile",
  # PUBLIC
  public = list(
    
    initialize = function(profile) {
      
      tryCatch({
        profile <- system.file(stringr::str_interp("profiles/${profile}.json"), package = "tableschema.r")
        private$profile_ <- profile
        # private$profile_ = readLines(profile,warn = FALSE)
        private$jsonschema_ <- jsonlite::toJSON(jsonlite::fromJSON(profile, simplifyVector = TRUE))
        return(private$jsonschema_)
      },
      error = function(cond) {
        message <- 'Can\'t load profile'
        stop(message)
      },
      warning = function(cond) {
        field <- FALSE
        # Choose a return value in case of warning
        return(field)
      })
    },
    
    
    validate = function(descriptor) {
      errors <- list()
      
      # Basic validation
      
      validation <- jsonlite::validate(descriptor)
      
      for (validationError in attr(validation, "err")) {
        errors <- append(errors, list(
          Error = stringr::str_interp(
            'Descriptor validation error:
            ${validationError}
            '
          )
        ))
      }
      
      if (validation == TRUE) {
        
        validation <- is.valid(descriptor, private$profile_)
        errs <- validation$errors
        for (i in rownames(errs) ) {
          errors <- c(errors, stringr::str_interp(
            'Descriptor validation error:
            ${errs[i, "field"]} - ${errs[i, "message"]}'
            
          )
          )
        }
      }
      
      # Extra validation
      
      if (length(errors) < 1) {
        # PrimaryKey validation
        for (message in validatePrimaryKey(helpers.from.json.to.list(descriptor))) {
          errors <- append(errors, list(Error = message))
        }
        
        # ForeignKeys validation
        messages <- validateForeignKeys(helpers.from.json.to.list(descriptor))
        for (message in messages) {
          errors <- append(errors, list(Error = message))
        }
        
      }
      return(list(valid = length(errors) < 1, errors = errors))
    }
  ),
  
  active = list(
    
    name = function() {
      
      if (is.null(jsonlite::fromJSON(private$jsonschema_)$title)) return(NULL)
      
      return(tolower(gsub(' ', '-', jsonlite::fromJSON(private$jsonschema_)$title)))
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

validatePrimaryKey <- function(descriptor) {
  messages <- list()
  # const fieldNames = (descriptor.fields || []).map(field => field.name)
  
  fieldNames <- if (!("fields" %in% names(descriptor)))
    list()
  else
    purrr::map(descriptor$fields, "name")
  
  if (!is.null(descriptor$primaryKey)) {
    primaryKey <- descriptor[["primaryKey"]]
    
    if (is.character(primaryKey)) {
      if (!(primaryKey  %in% fieldNames)) {
        messages <- append(messages, list(
          stringr::str_interp("primary key ${primaryKey} must match schema field names")
        ))
      }
      
    } else if (is.list(primaryKey) && is.null(names(primaryKey))) {
      # or list
      for (pk in primaryKey) {
        if (!(pk %in% fieldNames)) {
          
          messages <- append(messages, list(
            stringr::str_interp("primary key ${pk} must match schema field names")
          ))
        }
      }
    }
  }
  return(messages[!duplicated(messages)])
}

validateForeignKeys <- function(descriptor) {
  
  messages <- list()
  
  fieldNames <- if (!("fields" %in% names(descriptor)))
    list()
  else
    purrr::map(descriptor, "name")$fields
  
  if (!is.null(descriptor$foreignKeys)) {
    foreignKeys <- descriptor$foreignKeys
    
    for (fk in foreignKeys) {
      
      if (is.character(fk$fields)) {
        
        if (!(fk$fields %in% fieldNames )) {
          messages <- append(messages, list(
            stringr::str_interp(
              "foreign key ${fk$fields} must match schema field names"
            )
          ))
        }
        
        if (!is.character(fk$reference$fields)) {
          messages <- append(messages, list(
            stringr::str_interp(
              "foreign key ${fk$reference$fields} must be same type as ${fk$fields}"
            )
          ))
        }
        
      } else if (is.list(fk$fields) && is.null(names(fk$fields))) {
        #is.list
        
        for (field in fk$fields) {
          
          if (!(field %in% fieldNames)) {
            messages <- append(messages, list(
              stringr::str_interp("foreign key ${field} must match schema field names")
            ))
          }
        }
        
        if (!(is.list(fk$reference$fields) && is.null(names(fk$reference$fields)))) {
          #is.list
          
          messages <- append(messages, list(
            stringr::str_interp(
              "foreign key ${fk$reference$fields} must be same type as ${fk$fields}"
            )
          ))
          
        } else if (length(fk$reference$fields) != length(fk$fields)) {
          messages <- append(messages, list(
            stringr::str_interp(
              'foreign key fields must have the same length as reference.fields'
            )
          ))
        }
      }
      
      if (fk$reference$resource == '') {
        if (is.character(fk$reference$fields)) {
          if (!(fk$reference$fields %in%  fieldNames)) {
            messages <- append(messages, list(
              stringr::str_interp(
                "foreign key ${fk$fields} must be found in the schema field names"
              )
            ))
          }
        } else if (is.list(fk$reference$fields) && is.null(names(fk$reference$fields))) {
          # is.list
          
          for (field in fk$reference$fields) {
            if (!(field %in% fieldNames)) {
              messages <- append(messages, list(
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
  return(messages[!duplicated(messages)])
}



#' Instantiate \code{Profile} class
#' 
#' @description Constuctor to instantiate \code{\link{Profile}} class.
#' @param profile string profile name in registry or URL to JSON Schema
#' 
#' @return \code{\link{Profile}} class object
#' 
#' @rdname Profile.load
#' 
#' @export
#' 

Profile.load <- function(profile){
  # Remote
  
  if (is.character(profile)) {
    if (startsWith("http",unlist(strsplit(profile,":")))[1] |
        startsWith("https", unlist(strsplit(profile,":")))[1])  {
      profile <- urltools::host_extract(urltools::domain(basename(profile)))$host
    } else {
      profile <- unlist(strsplit(basename(profile),".", fixed = TRUE))[1]
      stopifnot(profile %in% names(profiles))
    }}
  return(Profile$new(profile))
}


profiles <- list(
  geojson = 'profiles/geojson.json',
  tableschema = 'profiles/tableschema.json'
)
