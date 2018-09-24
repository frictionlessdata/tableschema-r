library(tableschema.r)
library(testthat)
library(future)

context("helpers")

test_that('test', {
  
 expect_equal(future::value(helpers.retrieveDescriptor(descriptor = '{"this": "that", "other": ["thing"]}')),
               '{"this": "that", "other": ["thing"]}')
})

test_that('test', {
expect_equal(future::value(helpers.retrieveDescriptor(descriptor = '[{"this": "that", "other": ["thing"]}]')),
             '[{"this": "that", "other": ["thing"]}]')
})

test_that('test', {
  expect_equal(future::value(helpers.retrieveDescriptor(descriptor = 'inst/extdata/schema_valid_full.json')),
               readLines('https://raw.githubusercontent.com/frictionlessdata/tableschema-py/master/data/schema_valid_full.json'))
})

test_that('test', {
  expect_equal(class(future::value(helpers.retrieveDescriptor(descriptor = 'https://raw.githubusercontent.com/frictionlessdata/tableschema-py/master/data/schema_valid_full.json'))),
               "character")
})

test_that('test', {
  expect_error(future::value(helpers.retrieveDescriptor(descriptor = 'https://raw.githubusercontent.com/frictionlessdata/tableschema-py/master/data/')))
})

test_that('test', {
  expect_error(future::value(helpers.retrieveDescriptor(descriptor = 'inst/extdata/data.infer.csv')))
})

test_that('test', {
  expect_error(is.uri(20))
})

test_that('test', {
  expect_error(is.uuid(20))
})

test_that('test', {
  expect_error(is.valid(20))
})

SCHEMA <- '{
  "fields": [
{"name": "id", "type": "string", "constraints": {"required": true}},
{"name": "height", "type": "number"},
{"name": "age", "type": "integer"},
{"name": "name", "type": "string", "constraints": {"required": true}},
{"name": "occupation", "type": "string"}
]
}'

test_that('test', {
  expect_true(is.valid(SCHEMA)$valid)
})

test_that("write json", {
  def <- Schema.load(SCHEMA)
  schema <- future::value(def)
  jsonchar <- helpers.from.list.to.json(schema$descriptor)
  write_json(jsonchar, "inst/extdata/jsonchar.json")
  
  expect_true(file.exists("inst/extdata/jsonchar.json"))
})
