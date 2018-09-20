library(tableschema.r)
library(testthat)
library(jsonlite)

context("profile")


test_that("table-schema is up-to-date", {
  # res = jsonlite::toJSON(jsonlite::fromJSON( system.file(stringr::str_interp("profiles/tableschema.json"), package = "tableschema.r")))
  
  res = toJSON(fromJSON('https://specs.frictionlessdata.io/schemas/table-schema.json',simplifyVector = TRUE))
  profile = Profile.load('tableschema')

  identical(res, profile$jsonschema)
  expect_type(res, "character")
  expect_type(profile$jsonschema, "character")
})

test_that("table-schema is up-to-date", {
  profile = Profile.load('geojson')
  expect_silent(profile$jsonschema)
})
