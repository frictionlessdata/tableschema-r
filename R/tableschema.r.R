#' Table Schema Package
#' @description Table class for working with data and schema
#' @docType package
#' 
#' @section Introduction:
#' 
#' Tabular Data Package is a simple container format used for publishing and sharing tabular-style data. 
#' The format's focus is on simplicity and ease of use, especially online. In addition, the format is focused on data 
#' that can be presented in a tabular structure and in making it easy to produce (and consume) tabular data packages
#' from spreadsheets and relational databases.
#' 
#' The key features of this format are the following:
#' \itemize{
#' \item{CSV (comma separated variables) for data files}
#' \item{Single JSON file (datapackage.json) to describe the dataset including a schema for data files}
#' \item{Reuse of existing work including other Frictionless Data specifications}
#' }
#' 
#' As suggested by the name, Tabular Data Package extends and specializes the \href{http://frictionlessdata.io/specs/data-package/}{Data Package} spec for the specific case 
#' where the data is tabular.
#' 
#' 
#' @section Why CSV:
#' We chose CSV as the data format for the Tabular Data Package specification because:
#' \enumerate{
#' \item{CSV is very simple -- it is possibily the most simple data format}
#' \item{CSV is tabular-oriented. Most data structures are either tabular or can be transformed to a tabular structure by some form of normalization}
#' \item{It is open and the "standard" is well-known}
#' \item{It is widely supported - practically every spreadsheet program, relational database and programming language in existence can handle CSV in some form or other}
#' \item{It is text-based and therefore amenable to manipulation and access from a wide range of standard tools (including revision control systems such as git, mercurial and subversion)}
#' \item{It is line-oriented which means it can be incrementally processed - you do not need to read an entire file to extract a single row. For similar reasons it means that the format supports streaming.}
#' }
#' 
#' More informally:
#' 
#' \emph{CSV is the data Kalashnikov: not pretty, but many wars have been fought with it and kids can use it. [\href{https://twitter.com/pudo/status/248473299741446144}{@pudo} (Friedrich Lindenberg)]}
#' 
#' \emph{CSV is the ultimate simple, standard data format - streamable, text-based, no need for proprietary tools etc [\href{https://rufuspollock.com/}{@rufuspollock} (Rufus Pollock)]}
#' 
#' @section Specification:
#' Tabular Data Package builds directly on the \href{http://frictionlessdata.io/specs/data-package/}{Data Package} specification. 
#' Thus a Tabular Data Package \code{MUST} be a Data Package and conform to the \href{http://frictionlessdata.io/specs/data-package/#specification}{Data Package specification}.
#' 
#' Tabular Data Package has the following requirements over and above those imposed by Data Package:
#' \itemize{
#' \item{There \code{MUST} be at least one \code{resource} in the \code{resources} list object}
#' \item{There \code{MUST} be a \code{profile} property with the value \code{tabular-data-package}}
#' \item{Each \code{resource} \code{MUST} be a \href{http://frictionlessdata.io/specs/tabular-data-resource/}{Tabular Data Resource}}
#' }
#'  
#'  
#' @details
#' 
#' \href{https://CRAN.R-project.org/package=jsonlite}{Jsolite package} is internally used to convert json data to list objects. The input parameters of functions could be json strings, 
#' files or lists and the outputs are in list format to easily further process your data in R environment and exported as desired. 
#' More details about handling json you can see jsonlite documentation or vignettes \href{https://CRAN.R-project.org/package=jsonlite}{here}.
#' 
#' \href{https://CRAN.R-project.org/package=future}{Future package} is also used to load and create Table and Schema class asynchronously. 
#' To retrieve the actual result of the loaded Table or Schema you have to call \code{value(future)} to the variable you stored the loaded Table/Schema. 
#' More details about future package and sequential and parallel processing you can find \href{https://CRAN.R-project.org/package=future}{here}.
#' 
#' Examples section of each function show how to use jsonlite and future packages with tableschema.r. 
#' 
#' 
#' @name tableschema.r
#' 
#' @seealso 
#' For more details see the \code{\link{tableschema.r}} documentations,
#' or the \code{tableschema.r} vignette: \code{vignette("tableschema.r")}
NULL