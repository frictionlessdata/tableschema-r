#' Types class
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @keywords data
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
