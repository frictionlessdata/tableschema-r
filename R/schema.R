#' @title Schema class
#'
#' @description A model of a Table Schema with helpful methods for working with the schema and supported data.
#' Schema instances can be initialized using a schema source, either as a URL to a JSON file or as a JSON object.
#' The schema is validated upon initialization (see \href{https://github.com/okgreece/tableschema-r#validate}{validate}).
#' By default, validation errors are stored in \code{$errors}, but in strict mode, they are raised immediately.
#'
#' @usage
#' # Schema$load(descriptor, strict = FALSE)
#'
#' @param descriptor A schema descriptor; can be a JSON string, URL, or local file.
#' @param strict Logical flag. If \code{TRUE}, validation errors are raised immediately; if \code{FALSE}, they are stored in \code{schema$errors}.
#'
#' @section Methods:
#' \describe{
#'   \item{\code{Schema$new(descriptor = descriptor, strict = strict)}}{Use \code{Schema$load} to instantiate a \code{Schema} class.}
#'
#'   \item{\code{getField(name)}}{Returns a schema field by name.
#'     \describe{
#'       \item{\code{name}}{String. Name of the schema field.}
#'       \item{Returns}{A \code{Field} instance if found, or \code{NULL}.}
#'     }
#'   }
#'
#'   \item{\code{addField(descriptor)}}{Adds a new field to the schema.
#'     \describe{
#'       \item{\code{descriptor}}{A list representing the field descriptor.}
#'       \item{Raises}{\code{TableSchemaError} if the field is invalid.}
#'       \item{Returns}{The added \code{Field} instance, or \code{NULL} if unsuccessful.}
#'     }
#'   }
#'
#'   \item{\code{removeField(name)}}{Removes a field by name from the schema.
#'     \describe{
#'       \item{\code{name}}{Name of the field to remove.}
#'       \item{Raises}{\code{TableSchemaError} if removal causes invalid schema.}
#'       \item{Returns}{The removed \code{Field} instance, or \code{NULL}.}
#'     }
#'   }
#'
#'   \item{\code{castRow(row)}}{Casts a row of values based on field types and formats.
#'     \describe{
#'       \item{\code{row}}{A list representing a data row.}
#'       \item{Returns}{The cast row as a list of typed values.}
#'     }
#'   }
#'
#'   \item{\code{infer(rows, headers = 1)}}{Infers schema from given data.
#'     \describe{
#'       \item{\code{rows}}{A list of lists representing data rows.}
#'       \item{\code{headers}}{Either a row number (index) of headers or a list of header names.}
#'       \item{Returns}{A schema descriptor as an object.}
#'     }
#'   }
#'
#'   \item{\code{commit(strict)}}{Finalizes schema updates.
#'     \describe{
#'       \item{\code{strict}}{Logical. Whether to enable strict validation mode.}
#'       \item{Raises}{\code{TableSchemaError} on failure.}
#'       \item{Returns}{\code{TRUE} on success; \code{FALSE} if not modified.}
#'     }
#'   }
#'
#'   \item{\code{save(target)}}{Saves schema descriptor to a file.
#'     \describe{
#'       \item{\code{target}}{File path to save the schema.}
#'       \item{Raises}{\code{TableSchemaError} on failure.}
#'       \item{Returns}{\code{TRUE} on success.}
#'     }
#'   }
#' }
#'
#' @section Properties:
#' \describe{
#'   \item{\code{valid}}{Returns \code{TRUE} if schema is valid. Always \code{TRUE} in strict mode.}
#'   \item{\code{errors}}{Returns list of validation errors. Empty in strict mode.}
#'   \item{\code{descriptor}}{Returns the full schema descriptor as a list.}
#'   \item{\code{primaryKey}}{Returns a vector of field names that compose the primary key.}
#'   \item{\code{foreignKeys}}{Returns a list of foreign key definitions.}
#'   \item{\code{fields}}{Returns list of \code{Field} instances.}
#'   \item{\code{fieldNames}}{Returns vector of field names.}
#' }
#'
#' @section Language:
#' The key words \code{MUST}, \code{MUST NOT}, \code{REQUIRED}, \code{SHALL}, \code{SHALL NOT},
#' \code{SHOULD}, \code{SHOULD NOT}, \code{RECOMMENDED}, \code{MAY}, and \code{OPTIONAL}
#' in this documentation are interpreted as described in \href{https://www.ietf.org/rfc/rfc2119.txt}{RFC 2119}.
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @include types.R
#' @include constraints.R
#' @include tableschemaerror.R
#' @include profile.R
#' @keywords data
#' @return Object of class \code{\link{R6Class}}.
#' @format \code{\link{R6Class}} object.
#'
#' @seealso \code{Schema$load},
#' \href{https://specs.frictionlessdata.io//table-schema/}{Table Schema Specifications}

Schema <- R6Class(
  "Schema",
  public = list(
    initialize = function(descriptor = "{}",
                          strict = FALSE,
                          caseInsensitiveHeaders = FALSE) {
      # Set attributes
      private$strict_ <- strict
      private$caseInsensitiveHeaders_ <- caseInsensitiveHeaders
      private$currentDescriptor_json <- descriptor
      private$profile_ <- Profile$new('tableschema')
      private$errors_ <- list()
      private$fields_ <- list()
      
      # Build instance
      private$build_()
      
    },
    
    getField = function(fieldName, index = 1) {
      name <- fieldName
      fields <- purrr::keep(private$fields_, function(field) {
        if (!is.null(private$caseInsensitiveHeaders_))
          return(tolower(field$name) == tolower(name))
        return(field$name == name)
      })
      if (length(fields) < 1) {
        return(NULL)
      }
      if ((index == 1)) {
        return(fields[[1]])
      }
      return(private$fields_[[index]])
    },
    
    addField = function(descriptor) {
      if (is.null(private$nextDescriptor_$fields))
        private$nextDescriptor_$fields <- list()
      private$nextDescriptor_$fields <- append(private$nextDescriptor_$fields, descriptor)
      self$commit()
      return(private$fields_[[length(private$fields_) - 1]])
    },
    
    removeField = function(name) {
      field <- self$getField(name)
      if (!is.null(field)) {
        predicat <- function(field) {
          return(field$name != name)
        }
        private$nextDescriptor_$fields <- purrr::keep(private$nextDescriptor_$fields, predicat)
        self$commit()
      }
      return(field)
    },
    
    castRow = function(items,
                       failFast = FALSE,
                       skipConstraints = FALSE) {
      # TODO: this method has to be rewritten
      headers <- self$fieldNames
      result <- list()
      errors <- list()
      
      if (length(headers) != length(items)) {
        message <- 'Row dimension doesn\'t match schema\'s fields dimension'
        stop(message)
      }
      
      for (i in 1:length(items)) {
        attempt <- tryCatch({
          field <- self$getField(headers[[i]], i)
          value <- field$cast_value(value = items[[i]],
                                   constraints = !skipConstraints)
          # TODO: reimplement
          # and it's very bad to use it for exteral (by Table) monkeypatching
          if (!skipConstraints) {
            # unique constraints available only from Resource
            if (!is.null(self$uniqueness) &&
                !is.null(self$uniqueHeaders) && self$uniqueness == TRUE &&
                self$uniqueHeaders == TRUE) {
              helpers.checkUnique(field$name,
                                  value,
                                  self$uniqueHeaders,
                                  self$uniqueness)
            }
          }
          result <- append(result, list(value))
        },
        error = function(e) {
          #TODO:  UniqueConstraintsError
          
          error <-
            stringr::str_interp("Wrong type for header: ${headers[[i]]} and value: ${items[[i]]}")
          if (failFast == TRUE) {
            stop(error)
          } else {
            attempt <- list(error = error)
            
            
          }
        })
        if (is.list(attempt) && ('error' %in% names(attempt))) {
          errors <- append(errors, list(attempt[['error']]))
        }
      }
      
      if (length(errors) > 0) {
        error_message <- paste(errors, collapse = ' | ')
        error_message <- c(
          stringr::str_interp("There are ${length(errors)} cast errors (see following"),
          ' - ',
          error_message
        )
        
        stop(error_message)
      }
      
      return(result)
    },
    
    infer = function(rows, headers = 1) {
      # Get headers
      if (!is.list(headers)) {
        headersRow <- headers
        
        
        repeat {
          headersRow <- headersRow - 1
          headers <- rows[[1]]
          rows[[1]] <- NULL
          if (!headersRow)
            break
        }
      }
      
      # Get descriptor
      descriptor <- list(fields = list())
      i <- 1
      for (entry in headers) {
        # This approach is not effective, we should go row by row
        columnValues <- purrr::map(rows, function(row) {
          return(row[[i]])
        })
        type <- private$guessType_(columnValues)
        field <- list(name = entry, type = type)
        descriptor$fields <- append(descriptor$fields, list(field))
        i <- i + 1
      }
      
      # Commit descriptor
      private$nextDescriptor_ <- descriptor
      self$commit()
      
      return(descriptor)
    },
    
    commit = function(strict = NULL) {
      if (is.logical(strict))
        private$strict_ <- strict
      else if (identical(private$currentDescriptor_, private$nextDescriptor_))
        return(FALSE)
      private$currentDescriptor_ <- private$nextDescriptor_
      private$currentDescriptor_json <- jsonlite::toJSON(private$currentDescriptor_, auto_unbox = TRUE)
      private$build_()
      return(TRUE)
    },
    
    save = function(target) {
      write_json(private$currentDescriptor_,
                 file = stringr::str_c(target, "Schema.json", sep = "/"))
      save <- stringr::str_interp('Package saved at: "${target}"')
      return(save)
    }
  ),
  
  active = list(
    fieldNames = function() {
      return(purrr::map(private$fields_, function(field) {
        return(field$name)
      }))
    },
    
    fields = function() {
      return(private$fields_)
    },
    
    foreignKeys = function() {
      foreignKeys <- private$currentDescriptor_$foreignKeys
      if (is.null(foreignKeys)) {
        foreignKeys <- list()
      }
      
      foreignKeys <- lapply(foreignKeys, function(key){
        
        if (is.null(key$fields))
          key$fields <- list()
        if (is.null(key$reference))
          key$reference <- list()
        if (is.null(key$reference$resource))
          key$reference$resource <- ''
        if (is.null(key$reference$fields))
          key$reference$fields <- list()
        
        if (!is.list(key$fields)) {
          key$fields <- list(key$fields)
        }
        if (!is.list(key$reference$fields)) {
          key$reference$fields <- list(key$reference$fields)
        }
        
        return(key)
      })
      return(foreignKeys)
    },
    
    primaryKey = function(){
      key <- private$currentDescriptor_$primaryKey
      if (is.null(key)) {
        key <- list()
      }
      if (!is.list(key)) {
        key <- list(key)
      }
      return(key)
    },
    
    
    descriptor = function(x) {
      if (!missing(x)) private$nextDescriptor_ <- x
      return(private$nextDescriptor_)
    },
    
    errors = function() {
      return(private$errors_)
    },
    
    valid = function() {
      return(length(private$errors_) == 0)
    }
    
  ),
  
  private = list(
    strict_ = NULL,
    caseInsensitiveHeaders_ = NULL,
    currentDescriptor_ = NULL,
    currentDescriptor_json = NULL,
    nextDescriptor_ = NULL,
    profile_ = NULL,
    errors_ = NULL,
    fields_ = NULL,
    build_ = function() {
      # Process descriptor
      #private$currentDescriptor_json = jsonlite::toJSON(private$currentDescriptor_, auto_unbox = TRUE)
      # Validate descriptor
      private$errors_ <- list()
      if (!is.character(private$currentDescriptor_json)) private$currentDescriptor_json <- jsonlite::toJSON(private$currentDescriptor_json)
      private$currentDescriptor_json <- future::value(helpers.retrieveDescriptor(private$currentDescriptor_json))
      if (inherits(private$currentDescriptor_json, "simpleError")) {
        stop(private$currentDescriptor_json$message)
      }
      
      descriptor <- jsonlite::fromJSON(private$currentDescriptor_json, simplifyVector = FALSE)
      current <- private$profile_$validate(private$currentDescriptor_json)
      
      if (!current[['valid']]) {
        private$errors_ <- current[['errors']]
        
        if (private$strict_ == TRUE) {
          message <- stringr::str_interp(
            "There are ${length(current[['errors']])} validation errors (see 'error$errors')"
          )
          stop((message))
        }
      }
      private$currentDescriptor_ <- helpers.expandSchemaDescriptor(descriptor)
      private$nextDescriptor_ <- private$currentDescriptor_
      # Populate fields
      private$fields_ <- list()
      for (field in private$currentDescriptor_$fields) {
        missingValues <- as.list(private$currentDescriptor_$missingValues)
        
        field2 <- tryCatch({
          Field$new(field, missingValues)
          
        },
        error = function(cond) {
          field2 <- FALSE
          
          # Choose a return value in case of error
          return(field2)
        },
        warning = function(cond) {
          field2 <- FALSE
          
          # Choose a return value in case of warning
          return(field2)
        })
        private$fields_ <- append(private$fields_, list(field2))
      }
    },
    
    GUESS_TYPE_ORDER_ = list(
      'duration',
      'geojson',
      'geopoint',
      'object',
      'array',
      'datetime',
      'time',
      'date',
      'integer',
      'number',
      'boolean',
      'string',
      'any'
    ),
    types = Types$new(),
    
    
    guessType_ = function(row) {
      
      # Get matching types
      matches <- list()
      for (value in row) {
        for (type in private$GUESS_TYPE_ORDER_) {
          cast <- private$types$casts[[stringr::str_interp("cast${stringr::str_to_title(type)}")]]
          
          result <- cast('default', value)
          if (result != config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))) {
            matches <- append(matches, list(type))
            break
          }
        }
      }
      
      # Get winner type
      winner <- 'any'
      count <- 0
      candidateTypes <- unique(purrr::map(matches, function(match){list(itemType = match,itemCount = length(Filter(function(x) x == match, matches)))}))
      
      for (entry in candidateTypes) {
        if (entry[['itemCount']] > count) {
          winner <- entry[['itemType']]
          count <- entry[['itemCount']]
        }
      }
      return(winner)
    }
  )
)

#' Instantiate \code{Schema} class
#' @description Factory method to instantiate \code{Schema} class. 
#' This method is async and it should be used with \code{\link[future]{value}} keyword from 
#' \href{https://CRAN.R-project.org/package=future}{future} package.
#' 
#' @usage Schema.load(descriptor, strict=FALSE, caseInsensitiveHeaders = FALSE)
#' @param descriptor schema descriptor, a JSON string, URL or file  
#' @param strict flag to alter validation behaviour:
#' \itemize{
#' \item{if \code{FALSE} error will not be raised and all error will be collected in \code{schema$errors}}
#' \item{if \code{TRUE} any validation error will be raised immediately}
#' }
#' @param caseInsensitiveHeaders default is set to \code{FALSE}
#' @rdname Schema.load
#' 
#' @return \code{\link{Schema}} class object
#' @seealso \code{\link{Schema}}, \href{https://specs.frictionlessdata.io//table-schema/}{Table Schema Specifications}
#' 
#' @export
#' 
#' @examples
#' SCHEMA <- '{"fields": [
#'   {"name": "id", "type": "string", "constraints": {"required": true}},
#'   {"name": "height", "type": "number"},
#'   {"name": "age", "type": "integer"},
#'   {"name": "name", "type": "string", "constraints": {"required": true}},
#'   {"name": "occupation", "type": "string"}
#'   ]}'
#' 
#' # instantiate Schema class
#' def  = Schema.load(descriptor = SCHEMA)
#' schema = future::value(def)
#' 
#' # correct number of fields
#' length(schema$fields)
#' 
#' # correct field names
#' schema$fieldNames
#' 
#' # convert row
#' row = list('string', '10.0', '1', 'string', 'string')
#' castRow = schema$castRow(row)
#' castRow
#' 
#' SCHEMA_MIN <- '{
#' "fields": [
#'   {"name": "id"},
#'   {"name": "height"}
#'   ]}'
#' 
#' # load schema
#' def2  = Schema.load(descriptor = SCHEMA_MIN)
#' schema2 = future::value(def2)
#'   
#' # set default types if not provided
#' schema2$fields[[1]]$type
#' schema2$fields[[2]]$type
#' 
#' # fields are not required by default
#' schema2$fields[[1]]$required
#' schema2$fields[[2]]$required
#' 
#' 
#' #work in strict mode
#' descriptor = '{"fields": [{"name": "name", "type": "string"}]}'
#' def3  = Schema.load(descriptor = descriptor, strict = TRUE)
#' schema3 = future::value(def3)
#' schema3$valid
#' 
#' # work in non-strict mode
#' descriptor = '{"fields": [{"name": "name", "type": "string"}]}'
#' def4 = Schema.load(descriptor = descriptor, strict = FALSE)
#' schema4 = future::value(def4)
#' schema4$valid
#' 
#' # work with primary/foreign keys as arrays
#' descriptor2 = '{
#' "fields": [{"name": "name"}],
#' "primaryKey": ["name"],
#' "foreignKeys": [{
#'   "fields": ["parent_id"],
#'   "reference": {"resource": "resource", "fields": ["id"]}
#' }]}'
#' 
#' def5 = Schema.load(descriptor2)
#' schema5 = future::value(def5)
#' 
#' schema5$primaryKey
#' schema5$foreignKeys
#' 
#' 
#' # work with primary/foreign keys as string
#' descriptor3 = '{
#' "fields": [{"name": "name"}],
#' "primaryKey": "name",
#' "foreignKeys": [{
#'   "fields": "parent_id",
#'   "reference": {"resource": "resource", "fields": "id"}
#' }]}'
#' 
#' def6 = Schema.load(descriptor3)
#' schema6 = future::value(def6)
#' schema6$primaryKey
#' schema6$foreignKeys
#' 

Schema.load <- function(descriptor = "",
                       strict = FALSE,
                       caseInsensitiveHeaders = FALSE) {
  return(future::future({
    
    return(
      Schema$new(
        descriptor = descriptor,
        strict = strict,
        caseInsensitiveHeaders = caseInsensitiveHeaders
      )
    )
  }))
}