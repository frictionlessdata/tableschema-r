library(stringr)
library(hash)
library(tableschema.r)
library(testthat)



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
  def  = schema.load(SCHEMA)
  schema = def$value()
  lng = length(schema$fields)
  expect_equal(5, lng)
})

# 
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
# 
# test_that("set default types if not provided", {
#   def  = schema.load(SCHEMA_MIN)
#   schema = def$value()
#   expect_equal(schema$fields[[1]]$type, 'string')
#   expect_equal(schema$fields[[2]]$type, 'string')
# })
# 
# 
# test_that("fields are not required by default", {
#   def  = schema.load(SCHEMA_MIN)
#   schema = def$value()
#   expect_equal(schema$fields[[1]]$required, FALSE)
#   expect_equal(schema$fields[[2]]$required, FALSE)
# })
# 
# 
# test_that("initial descriptor should not be mutated", {
#   descriptor = '{"fields": [{ "name": "id" }]}';
#   def  = schema.load(descriptor)
#   schema = def$value()
#   expect_failure(expect_equivalent(schema$descriptor, descriptor))
# })
# 
# test_that("should return null if field name does not exists", {
#   def  = schema.load(SCHEMA)
#   schema = def$value()
#   expect_equal(schema$getField('non-existent'), NULL)
# })
# 
# 
# test_that("should load local json file", {
#   descriptor = system.file('inst/extdata/schema.json', package = 'tableschema.r')
#   def  = schema.load(descriptor)
#   schema = def$value()
#   expect_equivalent(schema$fieldNames, list('id', 'capital', 'url'))
# })
# 
# test_that("convert row", {
#   def  = schema.load(SCHEMA)
#   schema = def$value()
#   row = list('string', '10.0', '1', 'string', 'string')
#   castRow = schema$castRow(row)
#   expect_equivalent(castRow, list('string', 10, 1, 'string', 'string'))
# })
# 
# 
# 
# test_that("shouldn\'t convert row with less items than fields count", {
#   def  = schema.load(SCHEMA)
#   schema = def$value()
#   row = list('string', '10.0', '1', 'string')
#   expect_error(
#     schema$castRow(row),
#     '.*fields dimension.*'
#   )
# 
# })
# 
# test_that("shouldn\'t convert row with too many items", {
#   def  = schema.load(SCHEMA)
#   schema = def$value()
#   row = list('string', '10.0', '1', 'string', 'string', 'string')
#   expect_error(
#     schema$castRow(row),
#     '.*fields dimension.*'
#   )
#   
# })
# 
# test_that("shouldn\'t convert row with wrong type (fail fast)", {
#   def  = schema.load(SCHEMA)
#   schema = def$value()
#   row = list('string', 'notdecimal', '10.6', 'string', 'string')
#   expect_error(
#     schema$castRow(items = row, failFast = TRUE),
#     '.*type.*'
#   )
#   
# })
# 
# 
# test_that("shouldn\'t convert row with wrong type multiple errors", {
#   def  = schema.load(SCHEMA)
#   schema = def$value()
#   row = list('string', 'notdecimal', '10.6', 'string', 'string')
#   expect_error(
#     schema$castRow(items = row),
#     '.*cast errors.*type.*'
#   )
#   
# })
# 
# test_that("should allow pattern format for date", {
#   descriptor = '{"fields": [{"name": "year", "format": "%Y", "type": "date"}]}'
#   def  = schema.load(descriptor)
#   schema = def$value()
#   row = list('2005')
#   castRow = schema$castRow(row)
#   expect_identical(castRow[[1]], lubridate::make_date(2005,1,1))
# })
# 
# test_that("should work in strict mode", {
#   descriptor = '{"fields": [{"name": "name", "type": "string"}]}'
#   def  = schema.load(descriptor, TRUE)
#   schema = def$value()
#   expect_identical(schema$valid, TRUE)
#   expect_identical(schema$errors, list())
#   
# })
# 
# 
# 
# test_that("should work in non-strict mode", {
#   descriptor = '{"fields": [{"name": "name", "type": "bad"}]}'
#   def  = schema.load(descriptor)
#   schema = def$value()
#   expect_identical(schema$valid, FALSE)
#   expect_equal(length(schema$errors), 1)
#   
# })
# 
# 
# test_that("should infer itself from given rows", {
#   
#   schema = Schema$new();
#   
#   rows = list(
#     list('Alex', 21),
#     list('Joe', 38)
#   )
#   
#   schema$infer(rows, list('name', 'age'))
#   expect_identical(schema$valid, TRUE)
#   expect_equivalent(schema$fieldNames, list('name', 'age'))
#   expect_identical(schema$getField('name')$type, 'string')
#   expect_identical(schema$getField('age')$type, 'integer')
#   
# })
# 
# 
# 
# 
# test_that("should work with primary/foreign keys as arrays", {
#   
#   descriptor = '{
#   "fields": [{"name": "name"}],
#   "primaryKey": ["name"],
#   "foreignKeys": [{
#   "fields": ["parent_id"],
#   "reference": {"resource": "resource", "fields": ["id"]}
#   }]
# }';
#   def  = schema.load(descriptor)
#   schema = def$value()
#   expect_equivalent(schema$primaryKey, list("name"))
#   expect_equivalent(schema$foreignKeys, list(list(fields = list("parent_id"), reference = list(resource = "resource", fields = list("id")))))
#   
#   
#   })
# 
# 
# test_that("sould work with primary/foreign keys as string", {
#   
#   descriptor = '{
#     "fields": [{"name": "name"}],
#     "primaryKey": "name",
#     "foreignKeys": [{
#       "fields": "parent_id",
#       "reference": {"resource": "resource", "fields": "id"}
#     }]
#   }';
#   def  = schema.load(descriptor)
#   schema = def$value()
#   expect_equivalent(schema$primaryKey, list("name"))
#   expect_equivalent(schema$foreignKeys, list(list(fields = list("parent_id"), reference = list(resource = "resource", fields = list("id")))))
#   
#   
# })
# 
