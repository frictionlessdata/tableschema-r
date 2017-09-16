#' Schema class
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @include types.R
#' @include constraints.R
#' @include tableschemaerror.R
#' @include profile.R
#' @keywords data
#' @return Object of \code{\link{R6Class}} .
#' @format \code{\link{R6Class}} object.

Schema <- R6Class(
  "Schema",
  public = list(
    initialize = function(descriptor,
                          strict = FALSE,
                          caseInsensitiveHeaders = FALSE) {
      # Set attributes
      private$strict_ = strict
      private$caseInsensitiveHeaders_ = caseInsensitiveHeaders
      private$currentDescriptor_ = descriptor
      private$nextDescriptor_ = descriptor
      private$profile_ = Profile$new('table-schema')
      private$errors_ = list()
      private$fields_ = list()
      
      # Build instance
      private$build_()
      
    },
    
    getField = function(fieldName, index = 0) {
      name = fieldName
      fields = purrr::keep(private$fields_, function(field) {
        if (!is.null(private$caseInsensitiveHeaders_))
          return(tolower(field$name) == tolower(name))
        return(field$name == name)
      })
      if (length(fields) < 1) {
        return(NULL)
      }
      if (is.null(index)) {
        return(fields[[0]])
      }
      return(private$fields_[[index]])
    },
    
    addField = function(descriptor) {
      if (is.null(private$nextDescriptor_$fields))
        private$nextDescriptor_$fields = list()
      private$nextDescriptor_$fields = append(private$nextDescriptor_$fields, descriptor)
      self$commit()
      return(private$fields_[[length(private$fields_) - 1]])
    },
    
    removeField = function(name) {
      field = self$getField(name)
      if (!is.null(field)) {
        predicat = function(field) {
          return(field$name != name)
        }
        private$nextDescriptor_$fields = purrr::keep(private$nextDescriptor_$fields, predicat)
        self$commit()
      }
      return(field)
    },
    
    castRow = function(items,
                       failFast = FALSE,
                       skipConstraints = FALSE) {
      # TODO: this method has to be rewritten
      headers = self$fieldNames
      result = list()
      errors = list()
      
      if (length(headers) != length(items)) {
        message = 'Row dimension doesn\'t match schema\'s fields dimension'
        stop(TableSchemaError$new(message))
      }
      
      for (i in 0:length(items)) {
        tryCatch({
          field = self$getField(headers[[i]], i)
          value = field$castValue(items[[i]], list(constraints = !skipConstraints))
          
          # TODO: reimplement
          # That's very wrong - on schema level uniqueness doesn't make sense
          # and it's very bad to use it for exteral (by Table) monkeypatching
          if (!skipConstraints) {
            # unique constraints available only from Resource
            if (self$uniqueness &&
                self$uniqueHeaders) {
              Helpers$new()$checkUnique(field$name,
                                        value,
                                        self$uniqueHeaders,
                                        self$uniqueness)
            }
          }
          result = append(result, value)
          return(value)
        },
        error = function(e) {
          switch(e$name,
                 'UniqueConstraintsError' = {
                   error <- TableSchemaError$new(message)
                 },
                 {
                   error <-
                     TableSchemaError$new(
                       stringr::str_interp(
                         "Wrong type for header: ${headers[[i]]} and value: ${items[[i]]}"
                       )
                     )
                 })
          
          if (failFast == TRUE) {
            stop(error)
          } else {
            errors = append(errors, error)
          }
        },
        warning = function(cond) {
          
        },
        finally = {
          
        })
        
      }
      
      if (length(errors) > 0) {
        message = stringr::str_interp("There are ${length(errors)} cast errors (see 'error$errors')")
        stop(TableSchemaError$new(message, errors))
      }
      
      return(result)
    },
    
    
    infer = function(rows, headers = 1) {
      # Get headers
      if (!is.list(headers)) {
        headersRow = headers
        
        
        repeat {
          headersRow = headersRow - 1
          headers = rows[[1]]
          rows[[1]] <- NULL
          if (!headersRow)
            break
        }
      }
      
      # Get descriptor
      descriptor = list(fields = list())
      for (entry in headers) {
        # This approach is not effective, we should go row by row
        columnValues = purrr::map(rows, function(row) {
          return(row[entry[["index"]]])
        })
        type = private$guessType_(columnValues)
        field = list(name = entry[["header"]], type = type)
        descriptor$fields = append(descriptor$fields, field)
      }
      
      # Commit descriptor
      private$nextDescriptor_ = descriptor
      self$commit()
      
      return(descriptor)
    },
    
    commit = function(strict = NULL) {
      if (is.logical(strict))
        private$strict_ = strict
      else if (identical(private$currentDescriptor_, private$nextDescriptor_))
        return(FALSE)
      private$currentDescriptor = private$nextDescriptor_
      private$build_()
      return(TRUE)
    },
    
    save = function(target) {
      contents <-
        jsonlite::toJSON(private$currentDescriptor_, pretty = TRUE)
      
      deferred_ = async::async(function() {
        y <- list(a = 1, b = TRUE, c = "oops")
        base::save(contents, file = target)
      })
      return(deferred_)
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
      foreignKeys = private$currentDescriptor_$foreignKeys
      for (key in foreignKeys) {
        if (is.null(key$fields))
          key$fields = list()
        if (is.null(key$reference))
          key$reference = list()
        if (is.null(key$reference$resource))
          key$reference$resource = list()
        if (is.null(key$reference$fields))
          key$reference$fields = list()
        
        if (!is.list(key$fields)) {
          key$fields = list(key$fields)
        }
        if (!is.list(key$reference$fields)) {
          key$reference$fields = list(key$reference$fields)
        }
      }
      return(foreignKeys)
    },
    
    
    descriptor = function() {
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
    nextDescriptor_ = NULL,
    profile_ = NULL,
    errors_ = NULL,
    fields_ = NULL,
    build_ = function() {
      # Process descriptor
      private$currentDescriptor_ = helpers.expandSchemaDescriptor(private$currentDescriptor_)
      private$nextDescriptor_ = private$currentDescriptor_
      
      # Validate descriptor
      private$errors_ = list()
      current = private$profile_$validate(private$currentDescriptor_)
      if (!current[['valid']]) {
        private$errors_ = current[['errors']]
        if (private$strict_) {
          message = stringr::str_interp(
            "There are ${length(current[['errors']]) validation errors (see 'error$errors')}"
          )
          stop(TableSchemaError$new(message, current[['errors']]))
          
        }
      }
      
      # Populate fields
      private$fields_ = list()
      for (field in private$currentDescriptor_$fields) {
        missingValues = private$currentDescriptor_$missingValues
        tryCatch({
          field = Field$new(field, missingValues)
          return(field)
        },
        error = function(cond) {
          field = FALSE
          
          # Choose a return value in case of error
          return(field)
        },
        warning = function(cond) {
          field = FALSE
          
          # Choose a return value in case of warning
          return(field)
        },
        finally = {
         
        })
        
        private$fields_ = append(private$fields_, list(field))

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
      matches = list()
      for (value in row) {
        for (type in private$GUESS_TYPE_ORDER_) {
          cast = private$types$casts[[stringr::str_interp("cast${stringr::str_to_title(self$type)}")]]
          result = cast('default', value)
          if (result != config::get("ERROR")) {
            matches = append(matches, type)
            break
          }
        }
      }
      
      # Get winner type
      winner = 'any'
      count = 0
      for (entry in private$countBy(matches)) {
        if (entry[['itemCount']] > count) {
          winner = entry[['itemType']]
          count = entry[['itemCount']]
        }
      }
      
      return(winner)
    }
    
  )
  
  
  
)

schema.load = function(descriptor = list(),
                       strict = FALSE,
                       caseInsensitiveHeaders = FALSE) {
  res = helpers.retrieveDescriptor(descriptor)
  af = async::await(res)$then(function(descriptor) {
    Schema$new(descriptor, strict, caseInsensitiveHeaders)
  })
  return(af())
  #async::delay(10)
  
  #  Helpers$new()$retrieveDescriptor(descriptor))
  
  
  
}
schema.load2 = function(descriptor = list(),
                       strict = FALSE,
                       caseInsensitiveHeaders = FALSE) {
  
  descriptor =  helpers.retrieveDescriptor(descriptor)$value
  
  return(future::future(function(){
    return(Schema$new(descriptor = descriptor, strict = strict, caseInsensitiveHeaders = caseInsensitiveHeaders ))
  })) 
  
  
}