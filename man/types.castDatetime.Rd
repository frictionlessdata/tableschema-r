% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/types.castDatetime.R
\name{types.castDatetime}
\alias{types.castDatetime}
\title{Cast datetime}
\usage{
types.castDatetime(format = "\%Y-\%m-\%dT\%H:\%M:\%SZ", value)
}
\arguments{
\item{format}{available options are "default", "any", and "<pattern>" where
\describe{
\item{\code{default }}{An ISO8601 format string e.g. YYYY-MM-DDThh:mm:ssZ in UTC time}
\item{\code{any }}{As for \code{\link{types.castDate}}}
\item{\code{<pattern> }}{As for \code{\link{types.castDate}}}
}}

\item{value}{datetime to cast}
}
\description{
Cast date with time
}
\examples{

types.castDatetime(format = "default", value = "2014-01-01T06:00:00Z")

types.castDatetime(format = "\%d/\%m/\%y \%H:\%M", value = "21/11/06 16:30")
 
}
\seealso{
\href{https://specs.frictionlessdata.io//table-schema/#datetime}{Types and formats specifications}, 
\code{\link[base]{strptime}}, \code{\link[base]{DateTimeClasses}},
\code{\link[parsedate]{parsedate-package}} and 
\code{\link[lubridate]{lubridate-package}}.
}
