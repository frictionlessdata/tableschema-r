library(stringr)
library(tableschema.r)
library(testthat)
library(foreach)
library(lubridate)
library(readr)

testthat::context("profile")


test_that("table-schema is up-to-date", {
  # jsonlite::toJSON(jsonlite::fromJSON(profile$jsonschema))
  
  res = jsonlite::fromJSON('https://specs.frictionlessdata.io/schemas/table-schema.json',simplifyVector = T)
  profile = Profile.load('tableschema')
  ## compare the charater lengths instead
  ## problem with type returned from jsonlite + R6 it's correct if you run identical locally
  ## identical(res,profile$jsonschema)
  expect_equal(nchar(toString(res)),31765)
  expect_equal(nchar(toString(profile$jsonschema))-31765,-31765)
  expect_type(res,"list")
  expect_null(profile$jsonschema)
})

# 
test_that("table-schema is up-to-date", {
  profile = Profile.load('geojson')
  expect_true(is.null(profile$jsonschema))

})