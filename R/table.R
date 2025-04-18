#' @title Table Class
#'
#' @description Table class for working with tabular data and associated schema.
#' A table is created from a data source and optionally a schema. It provides methods
#' for iteration, reading, inference, validation, and saving of tabular data.
#'
#' @usage
#' # Table$load(source, schema = NULL, strict = FALSE, headers = 1, ...)
#'
#' @param source Data source. Can be one of:
#' \describe{
#'   \item{String}{Path to a local CSV file or a URL to a remote CSV file.}
#'   \item{List of lists}{Each sublist represents a row.}
#'   \item{Connection}{A readable stream with CSV content.}
#'   \item{Function}{Function returning a readable stream.}
#' }
#' @param schema Optional. Schema object or schema descriptor as JSON, list, or URL.
#' @param strict Logical. If \code{TRUE}, validation errors raise immediately. If \code{FALSE}, errors are stored in \code{$errors}.
#' @param headers Data source headers. Can be:
#' \describe{
#'   \item{Integer}{Row number containing the headers.}
#'   \item{List}{Vector of header names if the data does not contain a header row.}
#' }
#' @param ... Additional options passed to the CSV parser.
#' See \href{https://csv.js.org/parse/options/}{CSV Parser Options}. By default, \code{ltrim} is \code{TRUE}
#' according to the \href{https://specs.frictionlessdata.io//csv-dialect/#specification}{CSV Dialect spec}.
#'
#' @docType class
#' @include field.R
#' @include schema.R
#' @include readable.array.R
#' @keywords data
#' @return Object of class \code{\link{R6Class}}.
#' @format \code{\link{R6Class}} object.
#' @importFrom R6 R6Class
#' @export
#'
#' @section Methods:
#' \describe{
#'   \item{\code{Table$new(source, schema, strict, headers)}}{Use \code{Table$load} to instantiate a Table object.}
#'
#'   \item{\code{iter(keyed, extended, cast = TRUE, relations = FALSE, stream = FALSE)}}{Iterates over table rows.
#'   \describe{
#'     \item{\code{keyed}}{Logical. Whether to return rows as named lists.}
#'     \item{\code{extended}}{Logical. Whether to include row metadata.}
#'     \item{\code{cast}}{Logical. Whether to cast data to schema types.}
#'     \item{\code{relations}}{List of foreign key references (named list of resource names with reference rows).}
#'     \item{\code{stream}}{Logical. Return an R stream if \code{TRUE}.}
#'   }}
#'
#'   \item{\code{read(keyed, extended, cast = TRUE, relations = FALSE, limit)}}{Reads and returns the entire table as rows.
#'   \describe{
#'     \item{\code{keyed}}{Logical. Whether to return keyed rows.}
#'     \item{\code{extended}}{Logical. Whether to include row metadata.}
#'     \item{\code{cast}}{Logical. Whether to cast values.}
#'     \item{\code{relations}}{List of foreign key references (see \code{iter}).}
#'     \item{\code{limit}}{Integer. Maximum number of rows to return.}
#'   }}
#'
#'   \item{\code{infer(limit = 100)}}{Infers the schema from the data.
#'   \describe{
#'     \item{\code{limit}}{Integer. Number of rows to use for inference.}
#'   }}
#'
#'   \item{\code{save(target)}}{Saves the table as a CSV file.
#'   \describe{
#'     \item{\code{target}}{File path to save to.}
#'   }}
#' }
#'
#' @section Properties:
#' \describe{
#'   \item{\code{headers}}{Returns headers detected or provided.}
#'   \item{\code{schema}}{Returns the associated Schema instance.}
#' }
#'
#' @section Details:
#' A table is a fundamental concept in tabular data management. It represents rows and columns of structured data,
#' often accompanied by a schema (metadata describing field types, constraints, etc.).
#'
#' The \emph{physical representation} of a table refers to the raw data (e.g., in CSV or JSON form).
#' The \emph{logical representation} corresponds to the parsed and typed values conforming to schema definitions.
#'
#' This class supports both representations, applying validation, constraint checking, and conversion between them.
#'
#' Internally, the package uses:
#' \itemize{
#'   \item \href{https://CRAN.R-project.org/package=jsonlite}{jsonlite} for JSON parsing to and from R lists.
#'   \item \href{https://CRAN.R-project.org/package=future}{future} for asynchronous loading (e.g., \code{future::value(future_obj)}).
#' }
#'
#' See the examples in function documentation for how to use these features with `tableschema.r`.
#'
#' @section Language:
#' The key words \code{MUST}, \code{MUST NOT}, \code{REQUIRED}, \code{SHALL}, \code{SHALL NOT},
#' \code{SHOULD}, \code{SHOULD NOT}, \code{RECOMMENDED}, \code{MAY}, and \code{OPTIONAL}
#' in this documentation are interpreted as described in \href{https://www.ietf.org/rfc/rfc2119.txt}{RFC 2119}.
#'
#' @seealso \code{Table$load},
#' \href{https://specs.frictionlessdata.io//table-schema/}{Table Schema Specifications}

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
      
      private$strict_ <- strict
      
      # Headers
      private$headers_ <- NULL
      private$headersRow_ <- NULL
      if (is.list(headers)) {
        private$headers_ <- headers
      } else if (is.numeric(headers) &&
                 as.integer(headers) == headers) {
        private$headersRow_ <- headers
      }
    },
    
    
    infer = function(limit = 100) {
      if (is.null(private$schema_) || is.null(private$headers_)) {
        #Headers
        sample <- self$read(limit = limit, cast = FALSE)
        
        # Schema
        if (is.null(private$schema_)) {
          schema <- Schema$new()
          schema$infer(sample, headers = self$headers)
          private$schema_ <- Schema$new(jsonlite::toJSON(schema$descriptor, auto_unbox = TRUE), strict = private$strict_)
        }
      }
      return(private$schema_$descriptor)
    },
    
    iter = function(keyed,
                    extended,
                    cast = TRUE,
                    relations = FALSE,
                    stream = FALSE) {
      con <- private$createRowStream_(private$src)
      
      iterable_ <- con$iterable()
      
      # Prepare unique checks
      private$uniqueFieldsCache_ <- list()
      if (cast) {
        if (!is.null(self$schema)) {
          private$uniqueFieldsCache_ <- private$createUniqueFieldsCache(self$schema)
        }
      }
      
      # Get table row stream
      private$rowNumber_ <- 0
      private$currentStream_ <- con
      
      tableRowStream <- iterators::iter(function() {
        
        row <- iterators::nextElem(iterable_)
        
        private$rowNumber_ <- private$rowNumber_ + 1
        
        # Get headers
        if (identical(private$rowNumber_ , private$headersRow_)) {
          private$headers_ <- row
          
          stop("HeadersRow")
        }
        
        # Check headers
        if (cast) {
          
          if (!is.null(self$schema) && !is.null(self$headers)) {
            if (!identical(self$headers, self$schema$fieldNames)) {
              message <- 'Table headers don\'t match schema field names'
              stop(message)
            }
          }
        }
        
        # Cast row
        if (cast) {
          
          if (!is.null(self$schema)) {
            row <- self$schema$castRow(row)
          }
        }
        
        # Check unique
        if (cast && length(private$uniqueFieldsCache_) > 0) {
          
          for (index in 1:length(private$uniqueFieldsCache_)) {
            
            if (is.list(private$uniqueFieldsCache_[[index]])) {
              if (row[[index]] %in% private$uniqueFieldsCache_[[index]]) {
                fieldName <- self$schema$fields[[index]]$name
                message <- stringr::str_interp("Field '${fieldName}' duplicates in row ${private$rowNumber_}")
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
              
              row <- table.resolveRelations(row, self$headers, relations, foreignKey)
              if (is.null(row)) {
                message <- stringr::str_interp("Foreign key '${foreignKey$fields}' violation in row '${private$rowNumber_}'")
                stop(message)
              }
            }
          }
        }
        
        # Form row
        if (keyed) {
          names(row) <- self$headers
        } else if (extended) {
          row <- list(private$rowNumber_, self$headers, row)
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
      
      iterator <- self$iter(keyed = keyed, extended = extended, cast = cast, relations = relations)
      rows <- list()
      count <- 0
      repeat {
        
        count <- count + 1
        finished <- withCallingHandlers(tryCatch({
          
          it <- iterators::nextElem(iterator)
          
          rows <- append(rows, list(it))
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
          count <- count - 1
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
      stream <- private$createRowStream_(private$src)
      
      iterable_ <- stream$iterable()
      
      tryCatch({
        it <- iterators::nextElem(iterable_)
        row <- paste(it, collapse = ',')
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
      cache <- list()
      
      for (index in 1:length(schema$fields)) {
        field <- schema$fields[[index]]
        
        if ((!is.null(field$constraints$unique) &&
             field$constraints$unique) ||
            field$name %in% schema$primaryKey) {
          cache[[index]] <- list()
          
        }
      }
      return(cache)
    } ,
    
    createRowStream_ = function(src) {
      stream <- NULL
      # Stream factory
      if ("connection" %in% class(src)) {
        stream <- ReadableConnection$new(options = list(source = src))
        # stream = stream.pipe(parser)
        
        # Inline source
      } else if (is.list(src)) {
        #con
        stream <- ReadableArray$new(options = list(source = src))
        
        # Remote source
      } else if (is.uri(src)) {
        connection <- url(src)
        stream <- ReadableConnection$new(options = list(source = connection))
        
        # Local source
      } else {
        connection <- file(src)
        stream <- ReadableConnection$new(options = list(source = connection))
      }
      return(stream)
    },
    strict_ = FALSE,
    headers_ = list(),
    headersRow_ = list(),
    rowNumber_ = 0
  )
  
)


#' Instantiate \code{Table} class
#' 
#' @description Factory method to instantiate \code{Table} class. 
#' This method is async and it should be used with \code{\link[future]{value}} keyword from 
#' \href{https://CRAN.R-project.org/package=future}{future} package.
#' If \code{references} argument is provided foreign keys will be checked on any reading operation.
#' 
#' @usage Table.load(source, schema = NULL, strict = FALSE, headers = 1, ...)
#' @param source data source, one of:
#' \itemize{
#'  \item string with the path of the local CSV file
#'  \item string with the url of the remote CSV file
#'  \item list of lists representing the rows
#'  \item readable stream with CSV file contents
#'  \item function returning readable stream with CSV file contents
#'  }
#' @param schema data schema in all forms supported by \code{Schema} class
#' @param strict strictness option \code{TRUE} or \code{FALSE}, to pass to \code{Schema} constructor
#' @param headers data source headers, one of:
#' \itemize{
#'  \item row number containing headers (\code{source} should contain headers rows)
#'  \item list of headers (\code{source} should NOT contain headers rows)
#'  }
#' @param ...  options to be used by CSV parser. 
#' All options listed at \href{https://csv.js.org/parse/options/}{https://csv.js.org/parse/options/}. 
#' By default \code{ltrim} is \code{TRUE} according to the \href{https://specs.frictionlessdata.io//csv-dialect/#specification}{CSV Dialect spec}. 
#' 
#' 
#' @details
#' \href{https://CRAN.R-project.org/package=jsonlite}{Jsolite package} is internally used to convert json data to list objects. The input parameters of functions could be json strings, 
#' files or lists and the outputs are in list format to easily further process your data in R environment and exported as desired. 
#' Examples section show how to use jsonlite package and tableschema.r together. More details about handling json you can see jsonlite documentation or vignettes \href{https://CRAN.R-project.org/package=jsonlite}{here}.
#' 
#' \href{https://CRAN.R-project.org/package=future}{Future package} is also used to load and create Table and Schema classes asynchronously. 
#' To retrieve the actual result of the loaded Table or Schema you have to use \code{\link[future]{value}} function to the variable you stored the loaded Table/Schema. 
#' More details about future package and sequential and parallel processing you can find \href{https://CRAN.R-project.org/package=future}{here}.
#' 
#' Term array refers to json arrays which if converted in R will be \code{\link[base:list]{list objects}}.
#' 
#' @seealso \code{\link{Table}}, \href{https://specs.frictionlessdata.io//table-schema/}{Table Schema Specifications}
#' @rdname Table.load
#' @export
#' 
#' @examples
#' 
#' # define source
#' SOURCE = '[
#' ["id", "height", "age", "name", "occupation"],
#' [1, "10.0", 1, "string1", "2012-06-15 00:00:00"],
#' [2, "10.1", 2, "string2", "2013-06-15 01:00:00"],
#' [3, "10.2", 3, "string3", "2014-06-15 02:00:00"],
#' [4, "10.3", 4, "string4", "2015-06-15 03:00:00"],
#' [5, "10.4", 5, "string5", "2016-06-15 04:00:00"]
#' ]'
#' 
#' # define schema
#' SCHEMA = '{
#'   "fields": [
#'     {"name": "id", "type": "integer", "constraints": {"required": true}},
#'     {"name": "height", "type": "number"},
#'     {"name": "age", "type": "integer"},
#'     {"name": "name", "type": "string", "constraints": {"unique": true}},
#'     {"name": "occupation", "type": "datetime", "format": "any"}
#'     ],
#'   "primaryKey": "id"
#' }' 
#' 
#' 
#' def = Table.load(jsonlite::fromJSON(SOURCE, simplifyVector = FALSE), schema = SCHEMA)
#' table = future::value(def)
#' 
#' # work with list source
#' rows = table$read()
#' 
#' # read source data and limit rows
#' rows2 = table$read(limit = 1)
#' 
#' # read source data and return keyed rows
#' rows3 = table$read(limit = 1, keyed = TRUE)
#' 
#' # read source data and return extended rows
#' rows4 = table$read(limit = 1, extended = TRUE)
#' 
#' 
#' # work with Schema instance
#'  def1  =  Schema.load(SCHEMA)
#'  schema = future::value(def1)
#'  def2  = Table.load(jsonlite::fromJSON(SOURCE, simplifyVector = FALSE), schema = schema)
#'  table2 = future::value(def2)
#'  rows5 = table2$read()
#'  
#'

Table.load <- function(source,
                      schema = NULL,
                      strict = FALSE,
                      headers = 1, ...) {
  return(future::future({
    # Load schema
    if (!is.null(schema) && class(schema)[[1]] != "Schema") {
      def <- Schema.load(schema, strict)
      schema <- future::value(def)
    }
    
    return(Table$new(source, schema, strict, headers))
  }))
}

table.resolveRelations <- function(row, headers, relations, foreignKey) {
  # Prepare helpers - needed data structures
  
  keyedRow <- row
  names(keyedRow) <- headers
  
  fields <- rlist::list.zip(foreignKey$fields, foreignKey$reference$fields)
  
  actualKey <- if (stringr::str_length(foreignKey$reference$resource) < 1) "$" else foreignKey$reference$resource
  
  reference <- relations[[actualKey]]
  
  if (is.null(reference) ) { #|| isTRUE(stringr::str_length(reference) < 1)) {
    return(row)
  }
  
  # Collect values - valid if all null
  valid <- TRUE
  values <- list()
  for (index in 1:length(fields)) {
    
    field <- fields[[index]][[1]]
    refField <- fields[[index]][[2]]
    
    if (!is.null(field) && !is.null(refField)) {
      
      values[[refField]] <- keyedRow[[field]]
      if (!is.null(keyedRow[[field]])) {
        valid <- FALSE
      }
    }
  }
  
  
  # Resolve values - valid if match found
  if (!valid) {
    
    for (index in 1:length(reference)) {
      
      refValues <- reference[[index]]
      
      if (all(all.equal(refValues[names(values)], values) == TRUE)) {
        for (index2 in 1:length(fields)) {
          
          field <- fields[[index2]][[1]]
          keyedRow[[field]] <- refValues
        }
        valid <- TRUE
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
