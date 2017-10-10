library(stringr)
library(hash)
library(tableschema.r)
library(testthat)


testthat::context("Schema")

SCHEMA_MIN <- '{
  "fields": [
    {"name": "id"},
    {"name": "height"},
  ]
}'


SCHEMA <- '{
  "fields": [
    {"name": "id", "type": "string", "constraints": {"required": true}},
    {"name": "height", "type": "number"},
    {"name": "age", "type": "integer"},
    {"name": "name", "type": "string", "constraints": {"required": true}},
    {"name": "occupation", "type": "string"}
  ]
}'




test_that("have a correct number of fields", {
  def  = schema.load(SCHEMA)
  schema = def$value()
  
    lng = length(schema$fields)
    expect_equal(5, lng)
})


test_that("have correct field names", {
  def  = schema.load(SCHEMA)
  schema = def$value()
  
  lng = length(schema$fieldNames)
  expect_equal(schema$fieldNames, list('id', 'height', 'age', 'name', 'occupation'))
})

test_that("raise exception when invalid json passed as schema in strict mode", {
  def  = schema.load('bad descriptor', list(strict =  TRUE))
  
  expect_error(def$value())
  
})

test_that("raise exception when invalid format schema passed", {
  def  = schema.load('{}', list(strict =  TRUE))
  expect_error(def$value(), ".*validation errors.*")
})





