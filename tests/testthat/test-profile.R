library(stringr)
library(tableschema.r)
library(testthat)
library(foreach)
library(jsonlite)

context("profile")


test_that("table-schema is up-to-date", {
  # res = jsonlite::toJSON(jsonlite::fromJSON( system.file(stringr::str_interp("profiles/tableschema.json"), package = "tableschema.r")))
  
  res = jsonlite::toJSON(jsonlite::fromJSON('https://specs.frictionlessdata.io/schemas/table-schema.json',simplifyVector = TRUE))
  profile = Profile.load('tableschema')

  identical(res,profile$jsonschema)
  expect_type(res,"character")
  expect_type(profile$jsonschema,"character")
  expect_true(profile$validate(readLines('inst/extdata/schema.json'))$valid)
  expect_true(profile$validate('{"fields": [{"name": "year", "format": "%Y", "type": "date"}]}')$valid)
  expect_false(profile$validate('{
  "fields": [{"name": "name"}],
  "primaryKey": ["name"],
  "foreignKeys": [{
  "fields": ["parent_id"],
  "reference": {"resource": "resource", "fields": ["id"]}
  }]
}')$valid)
  expect_equal(profile$name, "table-schema")
})

# 
test_that("table-schema is up-to-date", {
  profile = Profile.load('geojson')
  expect_silent(profile$jsonschema)
})

test_that("error", {
  expect_error(Profile.load('geo-json'))
  expect_error(Profile.load(''))
})

test_that("url profile", {
  expect_equal(Profile.load('tableschema')$jsonschema,
               Profile.load('https://raw.githubusercontent.com/frictionlessdata/tableschema-r/master/inst/profiles/tableschema.json')$jsonschema)
})

test_that("local file profile", {
  expect_equal(Profile.load('inst/profiles/tableschema.json')$jsonschema, 
               Profile.load('https://raw.githubusercontent.com/frictionlessdata/tableschema-r/master/inst/profiles/tableschema.json')$jsonschema)
  expect_equal(Profile.load('inst/profiles/tableschema.json')$jsonschema, Profile.load('tableschema')$jsonschema)
})
