#' Table class
#'
#' @docType class
#' @include  field.R
#' @include  schema.R
#' @include  readable.array.R
#' @keywords data
#' @return Object of \code{\link{R6Class}} .
#' @format \code{\link{R6Class}} object.
#' @importFrom R6 R6Class
#' @export
#'

Table <- R6Class(
  "Table",
  public = list(
    initialize = function(src,
                          schema = NULL,
                          strict = FALSE,
                          headers = 1) {
      if (missing(schema)) {
        
      }
      else {
        self$schema <- schema
      }
      
      private$src <- src
      
      private$strict_ = strict
      
      # Headers
      private$headers_ = NULL
      private$headersRow_ = NULL
      if (is.list(headers)) {
        private$headers_ = headers
      } else if (is.numeric(headers) &&
                 as.integer(headers) == headers) {
        private$headersRow_ = headers
      }
      
      
    },
    
    
    infer = function(limit = 100) {
      if (is.null(private$schema_) || is.null(private$headers_)) {
        #Headers
        sample = self$read(limit = limit, cast = FALSE)
        
        # Schema
        if (is.null(private$schema_)) {
          schema = Schema$new()
          schema$infer(sample, headers = self$headers)
          private$schema_ = Schema$new(jsonlite::toJSON(schema$descriptor, auto_unbox = TRUE), strict = private$strict_)
        }
      }
      return(private$schema_$descriptor)
    },
    
    iter = function(keyed,
                    extended,
                    cast = TRUE,
                    relations = FALSE,
                    stream = FALSE) {
      con = private$createRowStream_(private$src)
      
      iterable_ = con$iterable()
      
      # Prepare unique checks
      private$uniqueFieldsCache_ = list()
      if (cast) {
        if (!is.null(self$schema)) {
          private$uniqueFieldsCache_ = private$createUniqueFieldsCache(self$schema)
        }
      }
      
      # Get table row stream
      private$rowNumber_ = 0
      private$currentStream_ = con
      
      tableRowStream = iterators::iter(function() {
        
        row = iterators::nextElem(iterable_)
        
        private$rowNumber_ = private$rowNumber_ + 1
        
        # Get headers
        if (identical(private$rowNumber_ , private$headersRow_)) {
          private$headers_ = row
          
          stop("HeadersRow")
        }
        
        # Check headers
        if (cast) {
          
          if (!is.null(self$schema) && !is.null(self$headers)) {
            if (!identical(self$headers, self$schema$fieldNames)) {
              message = 'Table headers don\'t match schema field names'
              stop(message)
            }
          }
        }
        
        # Cast row
        if (cast) {
          
          if (!is.null(self$schema)) {
            row = self$schema$castRow(row)
          }
        }
        
        # Check unique
        if (cast && length(private$uniqueFieldsCache_) > 0) {
          
          for (index in 1:length(private$uniqueFieldsCache_)) {
            
            if (is.list(private$uniqueFieldsCache_[[index]])) {
              if (row[[index]] %in% private$uniqueFieldsCache_[[index]]) {
                fieldName = self$schema$fields[[index]]$name
                message =    stringr::str_interp("Field '${fieldName}' duplicates in row ${private$rowNumber_}")
                stop(message)
              } else if (!is.null(row[[index]])) {
                private$uniqueFieldsCache_[[index]] <-
                  append(private$uniqueFieldsCache_[[index]], list(row[[index]]))
              }
            }
            
          }
        }
        
        
      
        # Resolve relations
        if (!is.null(relations) && !isTRUE(identical(relations, FALSE))) {
          if (!is.null(self$schema)) {
            
            for (foreignKey in self$schema$foreignKeys) {
            
              row = table.resolveRelations(row, self$headers, relations, foreignKey)
              if (is.null(row)) {
                message =  stringr::str_interp("Foreign key '${foreignKey$fields}' violation in row '${private$rowNumber_}'")
                stop(message)
              }
            }
          }
        }
        
        # Form row
        if (keyed) {
          names(row) <- self$headers
        } else if (extended) {
          row = list(private$rowNumber_, self$headers, row)
        }
        
        
        
        return(row)
        
        
      })
      
      # Form stream
      # if (!stream) {
      #  tableRowStream = S2A$new(tableRowStream)
      #  }
      
      return(tableRowStream)
      
    },
    read = function(keyed = FALSE,
                    extended = FALSE,
                    cast = TRUE,
                    relations = FALSE,
                    limit = NULL) {
      
      iterator  = self$iter(keyed = keyed, extended = extended, cast = cast, relations = relations)
      rows = list()
      count = 0
      repeat {

        
        count = count + 1
        finished = withCallingHandlers(tryCatch({
          
          it = iterators::nextElem(iterator)
          
          rows = append(rows, list(it))
          0
          
        },
        error = function(cond) {
          
          if (identical(cond$message, 'StopIteration')) {
            return(1)
            
          }
          if (identical(cond$message, "HeadersRow")) {
            return(-1)
            
          }
          stop(cond)
        }),
        warning = function(cond) {
          stop(cond)
          invokeRestart('muffleWarning')
        })
        if (identical(finished, -1)) {
          count = count - 1
        }
        if (identical(finished, 1)) {
          break
        }
        if (!is.null(limit) && !missing(limit) && count >= limit) {
          private$currentStream_$destroy()
          break
        }
        
      }
      return(rows)
      
    },
    save = function(connection) {
      open(connection)
      stream = private$createRowStream_(private$src)
      
      iterable_ = stream$iterable()
      
      tryCatch({
        it = iterators::nextElem(iterable_)
        row = paste(it, collapse = ',')
        writeLines(row, con = connection, sep = "\n", useBytes = FALSE)
       
        0
        
      },
      error = function(cond) {
        if (identical(cond$message, 'StopIteration')) {
          return(1)
          
        }

      },
      warning = function(cond) {
        stop(cond)
        
      })
      
    }
    
    
  ),
  active = list(
    schema = function(value) {
      if (missing(value)) {
        private$schema_
      }
      else {
        private$schema_ <- value
      }
    },
    headers = function() {
      return(private$headers_)
    }
    
  ),
  private = list(
    src = NULL,
    schema_ = NULL,
    uniqueFieldsCache_ = list(),
    currentStream_ = NULL,
    
    createUniqueFieldsCache = function(schema) {
      cache = list()
      
      for (index in 1:length(schema$fields)) {
        field = schema$fields[[index]]
        
        if ((!is.null(field$constraints$unique) &&
             field$constraints$unique) ||
            field$name %in% schema$primaryKey) {
          cache[[index]] = list()
          
        }
      }
      return(cache)
    } ,
    
    createRowStream_ = function(src) {
      stream = NULL
      # Stream factory
      if ("connection" %in% class(src)) {
        stream = ReadableConnection$new(options = list(source = src))
        # stream = stream.pipe(parser)
        
        # Inline source
      } else if (is.list(src)) {
        #con
        stream = ReadableArray$new(options = list(source = src))
        
        # Remote source
      } else if (is.uri(src)) {
        connection = url(src)
        stream = ReadableConnection$new(options = list(source = connection))
        
        
        # Local source
      } else {
        connection = file(src)
        stream = ReadableConnection$new(options = list(source = connection))
        
        
      }
      return(stream)
    }
    
    ,
    strict_ = FALSE,
    headers_ = list(),
    headersRow_ = list(),
    rowNumber_ = 0
    
    
  )
  
)


#' load table
#' @param source source
#' @param schema schema
#' @param strict strict
#' @param headers headers
#' @param ... other arguments to pass
#' @rdname Table.load
#' @export
#' 

Table.load = function(source,
                      schema = NULL,
                      strict = FALSE,
                      headers = 1, ...) {
  return(future::future({
    # Load schema
    if (!is.null(schema) && class(schema)[[1]] != "Schema") {
      def  = Schema.load(schema, strict)
      schema = future::value(def)
    }
    
    return(Table$new(source, schema, strict, headers))
  }))
  
  
}

table.resolveRelations = function(row, headers, relations, foreignKey) {
  # Prepare helpers - needed data structures
  
  keyedRow = row
  names(keyedRow) = headers

  fields = rlist::list.zip(foreignKey$fields, foreignKey$reference$fields)

  actualKey = if (stringr::str_length(foreignKey$reference$resource) < 1) "$" else foreignKey$reference$resource
  
  reference = relations[[actualKey]]
  
  if (is.null(reference) ) { #|| isTRUE(stringr::str_length(reference) < 1)) {
    return(row)
  }
  
  # Collect values - valid if all null
  valid = TRUE
  values = list()
  for (index in 1:length(fields)) {
  
    field = fields[[index]][[1]]
    refField = fields[[index]][[2]]
    
    if (!is.null(field) && !is.null(refField)) {
      
      values[[refField]] = keyedRow[[field]]
      if (!is.null(keyedRow[[field]])) {
        valid = FALSE
      }
    }
    
    
    
  }


  # Resolve values - valid if match found
  if (!valid) {

    for (index in 1:length(reference)) {

      refValues = reference[[index]]

      if (all(all.equal(refValues[names(values)], values) == TRUE)) {
        for (index2 in 1:length(fields)) {

            field = fields[[index2]][[1]]
            keyedRow[[field]] = refValues
        }
        valid = TRUE
        break
      }
    }

  }


  if (valid) {
    return(unname(keyedRow))
  }
  else {
    return(NULL)
  }
  
  
}