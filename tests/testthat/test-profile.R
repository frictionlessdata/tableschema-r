library(stringr)
library(tableschema.r)
library(testthat)
library(foreach)
library(lubridate)


testthat::context("profile")





test_that("table-schema is up-to-date", {
  
  
  res = readr::read_file(url('https://specs.frictionlessdata.io/schemas/table-schema.json'))
  profile = profile.load('tableschema')
  
  expect_equivalent(helpers.from.json.to.list(res), helpers.from.json.to.list(profile$jsonschema))

  
  
})


test_that("table-schema is up-to-date", {
  
  
  profile = profile.load('geojson')
  expect_failure(expect_null(profile))

  
  
})
