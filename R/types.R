#' Types class
#' @description R6 class with Types and Formats.
#' 
#' \code{type} and \code{format} properties are used to give the type of the field (string, number etc) - 
#' see \href{https://specs.frictionlessdata.io//table-schema/#types-and-formats}{types and formats} for more details. 
#' If type is not provided a consumer should assume a type of "string".
#' 
#' A field's \code{type} property is a string indicating the type of this field.
#' 
#' A field's \code{format} property is a string, indicating a format for the field type.
#' 
#' Both \code{type} and format are optional: in a field descriptor, the absence of a \code{type} property indicates that 
#' the field is of the type "string", and the absence of a \code{format} property indicates that the field's type \code{format} is "default".
#' 
#' Types are based on the \href{https://datatracker.ietf.org/doc/html/draft-zyp-json-schema-03#section-5.1}{type set of json-schema} 
#' with some additions and minor modifications (cf other type lists include those in 
#' \href{http://www.elasticsearch.org/guide/reference/mapping/}{Elasticsearch types}).
#' 
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @keywords data
#' @field casts see Section See also
#' @return Object of \code{\link{R6Class}} .
#' @format \code{\link{R6Class}} object.
#' @include types.castAny.R
#' @include types.castBoolean.R
#' @include types.castDate.R
#' @include types.castDatetime.R  
#' @include types.castDuration.R  
#' @include types.castGeojson.R   
#' @include types.castGeopoint.R  
#' @include types.castInteger.R   
#' @include types.castList.R
#' @include types.castNumber.R
#' @include types.castObject.R
#' @include types.castString.R
#' @include types.castTime.R
#' @include types.castYear.R
#' @include types.castYearmonth.R
#' @include types.castArray.R
#' 
#' 
#' @seealso \href{https://specs.frictionlessdata.io//table-schema/#types-and-formats}{Types and formats specifications},
#' \code{\link{types.castAny}},
#' \code{\link{types.castBoolean}},
#' \code{\link{types.castDate}},
#' \code{\link{types.castDatetime}},
#' \code{\link{types.castDuration}},
#' \code{\link{types.castGeojson}},
#' \code{\link{types.castGeopoint}},
#' \code{\link{types.castInteger}},
#' \code{\link{types.castList}},
#' \code{\link{types.castNumber}},
#' \code{\link{types.castObject}},
#' \code{\link{types.castString}},
#' \code{\link{types.castTime}},
#' \code{\link{types.castYear}},
#' \code{\link{types.castYearmonth}},
#' \code{\link{types.castArray}}
#' 

Types <- R6Class("Types", public = list(casts = list(
  
  castAny     = types.castAny,
  castArray     = types.castArray,
  castBoolean   = types.castBoolean,
  castDate      = types.castDate,
  castDatetime  = types.castDatetime,
  castDuration  = types.castDuration,
  castGeojson   = types.castGeojson,
  castGeopoint  = types.castGeopoint,
  castInteger   = types.castInteger,
  castList      = types.castList,
  castNumber    = types.castNumber,
  castObject    = types.castObject,
  castString    = types.castString,
  castTime      = types.castTime,
  castYear      = types.castYear,
  castYearmonth = types.castYearmonth
)))
