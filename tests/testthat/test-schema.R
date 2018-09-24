library(stringr)
library(tableschema.r)
library(testthat)
library(future)



SCHEMA_MIN <- '{
  "fields": [
    {"name": "id"},
    {"name": "height"}
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


testthat::context("Schema")

test_that("have a correct number of fields", {
  def <- Schema.load(SCHEMA)
  schema <- future::value(def)
  lng <- length(schema$fields)
  expect_equal(5, lng)
})

# 
test_that("have correct field names", {
  def <- Schema.load(SCHEMA)
  schema <- future::value(def)

  lng <- length(schema$fieldNames)
  expect_equal(schema$fieldNames, list('id', 'height', 'age', 'name', 'occupation'))
})

test_that("raise exception when invalid json passed as schema in strict mode", {
  def <- Schema.load('bad descriptor', list(strict =  TRUE))
  expect_error(future::value(def))

})

test_that("raise exception when invalid format schema passed", {
  def <- Schema.load('[]', list(strict =  TRUE))
  expect_error(future::value(def), ".*validation errors.*")
})

test_that("set default types if not provided", {
  def <- Schema.load(SCHEMA_MIN)
  schema <- future::value(def)
  expect_equal(schema$fields[[1]]$type, 'string')
  expect_equal(schema$fields[[2]]$type, 'string')
})


test_that("fields are not required by default", {
  def <- Schema.load(SCHEMA_MIN)
  schema <- future::value(def)
  expect_equal(schema$fields[[1]]$required, FALSE)
  expect_equal(schema$fields[[2]]$required, FALSE)
})


test_that("initial descriptor should not be mutated", {
  descriptor <- '{"fields": [{ "name": "id" }]}'
  def <- Schema.load(descriptor)
  schema <- future::value(def)
  expect_failure(expect_equivalent(schema$descriptor, descriptor))
})

test_that("should return null if field name does not exists", {
  def <- Schema.load(SCHEMA)
  schema <- future::value(def)
  expect_equal(schema$getField('non-existent'), NULL)
})


test_that("should load local json file", {
  descriptor <- readLines('inst/extdata/schema2.json')
  def <- Schema.load(descriptor)
  schema <- future::value(def)
  expect_equivalent(schema$fieldNames, list('id', 'capital', 'url'))
})

test_that("convert row", {
  def <- Schema.load(SCHEMA)
  schema <- future::value(def)
  row <- list('string', '10.0', '1', 'string', 'string')
  castRow <- schema$castRow(row)
  expect_equivalent(castRow, list('string', 10, 1, 'string', 'string'))
})



test_that("shouldn\'t convert row with less items than fields count", {
  def <- Schema.load(SCHEMA)
  schema <- future::value(def)
  row <- list('string', '10.0', '1', 'string')
  expect_error(
    schema$castRow(row),
    '.*fields dimension.*'
  )

})

test_that("shouldn\'t convert row with too many items", {
  def <- Schema.load(SCHEMA)
  schema <- future::value(def)
  row <- list('string', '10.0', '1', 'string', 'string', 'string')
  expect_error(
    schema$castRow(row),
    '.*fields dimension.*'
  )

})

test_that("shouldn\'t convert row with wrong type (fail fast)", {
  def <- Schema.load(SCHEMA)
  schema <- future::value(def)
  row <- list('string', 'notdecimal', '10.6', 'string', 'string')
  expect_error(
    schema$castRow(items = row, failFast = TRUE),
    '.*type.*'
  )

})


test_that("shouldn\'t convert row with wrong type multiple errors", {
  def <- Schema.load(SCHEMA)
  schema <- future::value(def)
  row <- list('string', 'notdecimal', '10.6', 'string', 'string')
  expect_error(
    schema$castRow(items = row),
    '.*cast errors.*type.*'
  )

})

test_that("should allow pattern format for date", {
  descriptor <- '{"fields": [{"name": "year", "format": "%Y", "type": "date"}]}'
  def <- Schema.load(descriptor)
  schema <- future::value(def)
  row <- list('2005')
  castRow <- schema$castRow(row)
  expect_identical(castRow[[1]], lubridate::make_date(2005,1,1))
})

test_that("should work in strict mode", {
  descriptor <- '{"fields": [{"name": "name", "type": "string"}]}'
  def <- Schema.load(descriptor, TRUE)
  schema <- future::value(def)
  expect_identical(schema$valid, TRUE)
  expect_identical(schema$errors, list())

})



test_that("should work in non-strict mode", {
  descriptor <- '{"fields": [{"name": "name", "type": "bad"}]}'
  def <- Schema.load(descriptor)
  schema <- future::value(def)
  expect_identical(schema$valid, FALSE)
  expect_equal(length(schema$errors), 1)

})


test_that("should infer itself from given rows", {

  schema <- Schema$new()

  rows <- list(
    list('Alex', 21),
    list('Joe', 38)
  )

  schema$infer(rows, list('name', 'age'))
  expect_equal(schema$infer(rows, list('name', 'age')), 
               list(fields = list(list(name = "name",type = "string"), list(name = "age",type = "integer"))))
  expect_identical(schema$valid, TRUE)
  expect_equivalent(schema$fieldNames, list('name', 'age'))
  expect_identical(schema$getField('name')$type, 'string')
  expect_identical(schema$getField('age')$type, 'integer')
  expect_identical(schema$getField('age')$name, 'age')
  
  schema$removeField("name")
  expect_null(schema$getField('name'))
})




test_that("should work with primary/foreign keys as arrays", {

  descriptor <- '{
  "fields": [{"name": "name"}],
  "primaryKey": ["name"],
  "foreignKeys": [{
  "fields": ["parent_id"],
  "reference": {"resource": "resource", "fields": ["id"]}
  }]
}'
  def <- Schema.load(descriptor)
  schema <- future::value(def)
  expect_equivalent(schema$primaryKey, list("name"))
  expect_equivalent(schema$foreignKeys, list(list(fields = list("parent_id"), reference = list(resource = "resource", fields = list("id")))))
  })


test_that("should work with primary/foreign keys as string", {

  descriptor <- '{
    "fields": [{"name": "name"}],
    "primaryKey": "name",
    "foreignKeys": [{
      "fields": "parent_id",
      "reference": {"resource": "resource", "fields": "id"}
    }]
  }'
  def <- Schema.load(descriptor)
  schema <- future::value(def)
  expect_equivalent(schema$primaryKey, list("name"))
  expect_equivalent(schema$foreignKeys, list(list(fields = list("parent_id"), reference = list(resource = "resource", fields = list("id")))))
})


testthat::context("Schema #save")

test_that("general", {
  def <- Schema.load(SCHEMA)
  schema <- future::value(def)
  schema$save("inst/extdata")
  
  expect_true(file.exists("inst/extdata/schema.json"))
})
