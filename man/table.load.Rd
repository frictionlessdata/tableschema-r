% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/table.R
\name{Table.load}
\alias{Table.load}
\title{Instantiate \code{Table} class}
\usage{
Table.load(source, schema = NULL, strict = FALSE, headers = 1, ...)
}
\arguments{
\item{source}{data source, one of:
\itemize{
 \item string with the path of the local CSV file
 \item string with the url of the remote CSV file
 \item list of lists representing the rows
 \item readable stream with CSV file contents
 \item function returning readable stream with CSV file contents
 }}

\item{schema}{data schema in all forms supported by \code{Schema} class}

\item{strict}{strictness option \code{TRUE} or \code{FALSE}, to pass to \code{Schema} constructor}

\item{headers}{data source headers, one of:
\itemize{
 \item row number containing headers (\code{source} should contain headers rows)
 \item list of headers (\code{source} should NOT contain headers rows)
 }}

\item{...}{options to be used by CSV parser. 
All options listed at \href{https://csv.js.org/parse/options/}{https://csv.js.org/parse/options/}. 
By default \code{ltrim} is \code{TRUE} according to the \href{https://specs.frictionlessdata.io//csv-dialect/#specification}{CSV Dialect spec}.}
}
\description{
Factory method to instantiate \code{Table} class. 
This method is async and it should be used with \code{\link[future]{value}} keyword from 
\href{https://CRAN.R-project.org/package=future}{future} package.
If \code{references} argument is provided foreign keys will be checked on any reading operation.
}
\details{
\href{https://CRAN.R-project.org/package=jsonlite}{Jsolite package} is internally used to convert json data to list objects. The input parameters of functions could be json strings, 
files or lists and the outputs are in list format to easily further process your data in R environment and exported as desired. 
Examples section show how to use jsonlite package and tableschema.r together. More details about handling json you can see jsonlite documentation or vignettes \href{https://CRAN.R-project.org/package=jsonlite}{here}.

\href{https://CRAN.R-project.org/package=future}{Future package} is also used to load and create Table and Schema classes asynchronously. 
To retrieve the actual result of the loaded Table or Schema you have to use \code{\link[future]{value}} function to the variable you stored the loaded Table/Schema. 
More details about future package and sequential and parallel processing you can find \href{https://CRAN.R-project.org/package=future}{here}.

Term array refers to json arrays which if converted in R will be \code{\link[base:list]{list objects}}.
}
\examples{

# define source
SOURCE = '[
["id", "height", "age", "name", "occupation"],
[1, "10.0", 1, "string1", "2012-06-15 00:00:00"],
[2, "10.1", 2, "string2", "2013-06-15 01:00:00"],
[3, "10.2", 3, "string3", "2014-06-15 02:00:00"],
[4, "10.3", 4, "string4", "2015-06-15 03:00:00"],
[5, "10.4", 5, "string5", "2016-06-15 04:00:00"]
]'

# define schema
SCHEMA = '{
  "fields": [
    {"name": "id", "type": "integer", "constraints": {"required": true}},
    {"name": "height", "type": "number"},
    {"name": "age", "type": "integer"},
    {"name": "name", "type": "string", "constraints": {"unique": true}},
    {"name": "occupation", "type": "datetime", "format": "any"}
    ],
  "primaryKey": "id"
}' 


def = Table.load(jsonlite::fromJSON(SOURCE, simplifyVector = FALSE), schema = SCHEMA)
table = future::value(def)

# work with list source
rows = table$read()

# read source data and limit rows
rows2 = table$read(limit = 1)

# read source data and return keyed rows
rows3 = table$read(limit = 1, keyed = TRUE)

# read source data and return extended rows
rows4 = table$read(limit = 1, extended = TRUE)


# work with Schema instance
 def1  =  Schema.load(SCHEMA)
 schema = future::value(def1)
 def2  = Table.load(jsonlite::fromJSON(SOURCE, simplifyVector = FALSE), schema = schema)
 table2 = future::value(def2)
 rows5 = table2$read()
 

}
\seealso{
\code{\link{Table}}, \href{https://specs.frictionlessdata.io//table-schema/}{Table Schema Specifications}
}
