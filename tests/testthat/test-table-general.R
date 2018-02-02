library(tableschema.r)
library(testthat)
library(lubridate)
library(jsonlite)

testthat::context("table-general")

SOURCE = '[
["id", "height", "age", "name", "occupation"],
[1, "10.0", 1, "string1", "2012-06-15 00:00:00"],
[2, "10.1", 2, "string2", "2013-06-15 01:00:00"],
[3, "10.2", 3, "string3", "2014-06-15 02:00:00"],
[4, "10.3", 4, "string4", "2015-06-15 03:00:00"],
[5, "10.4", 5, "string5", "2016-06-15 04:00:00"]
]'
SCHEMA = '{
"fields": [
{"name": "id", "type": "integer", "constraints": {"required": true}},
{"name": "height", "type": "number"},
{"name": "age", "type": "integer"},
{"name": "name", "type": "string", "constraints": {"unique": true}},
{"name": "occupation", "type": "datetime", "format": "any"}
],
"primaryKey": "id"
}'

test_that("should not instantiate with bad schema path", {
  def  = Table.load(SOURCE, 'bad schema path')
  expect_error(def$value(), ".*load descriptor.*")
})

test_that("should work with Schema instance", {
  def1  =  Schema.load(SCHEMA)
  schema = def1$value()
  def2  = Table.load( jsonlite::fromJSON(SOURCE, simplifyVector = FALSE), schema = schema)
  table = def2$value()
  rows = table$read()
  expect_identical(length(rows),5L)
})

test_that("should work with array source", {
  def2  = Table.load( jsonlite::fromJSON(SOURCE, simplifyVector = FALSE), schema = SCHEMA)
  table = def2$value()
  rows = table$read()
  expect_identical(length(rows),5L)
})

test_that("should work with local path", {
  def2  = Table.load('inst/extdata/data_big.csv')
  table = def2$value()
  rows = table$read()
  expect_identical(length(rows),100L)
})


test_that("should cast source data", {
  def2  = Table.load(jsonlite::fromJSON(SOURCE, simplifyVector = FALSE), schema = SCHEMA)
  table = def2$value()
  rows = table$read()
  expect_equivalent(rows[[1]], list(1, 10.0, 1, 'string1',  lubridate::make_datetime(2012,6,15) ))
})

test_that("should not cast source data with cast false", {
  def2  = Table.load(jsonlite::fromJSON(SOURCE, simplifyVector = FALSE), schema = SCHEMA)
  table = def2$value()
  rows = table$read(cast = FALSE)
  expect_equivalent(rows[[1]], list(1, '10.0', 1, 'string1',  '2012-06-15 00:00:00' ))
})

test_that("should throw on unique constraints violation", {
  source = list(
    list(1, '10.1', '1', 'string1', '2012-06-15'),
    list(2, '10.2', '2', 'string1', '2012-07-15')
  )
  def2  = Table.load(source, schema = SCHEMA, headers = FALSE)
  table = def2$value()
  expect_error(table$read(), ".*duplicates.*")
})

test_that("unique constraints violation for primary key", {
  source = list(
    list(1, '10.1', '1', 'string1', '2012-06-15'),
    list(1, '10.2', '2', 'string2', '2012-07-15')
  )
  def2  = Table.load(source, schema = SCHEMA, headers = FALSE)
  table = def2$value()
  expect_error(table$read(), ".*duplicates.*")
})


test_that("should read source data and limit rows", {
  def2  = Table.load(jsonlite::fromJSON(SOURCE, simplifyVector = FALSE), schema = SCHEMA)
  table = def2$value()
  rows = table$read(limit = 1)
  expect_identical(length(rows),1L)
})

test_that("should read source data and return keyed rows", {
  def2  = Table.load(jsonlite::fromJSON(SOURCE, simplifyVector = FALSE), schema = SCHEMA)
  table = def2$value()
  rows = table$read(limit = 1, keyed = TRUE)
  expect_equivalent(rows[[1]], list(id = 1, height = 10.0, age = 1, name = 'string1', occupation =  lubridate::make_datetime(2012,6,15) ))
})

test_that("should read source data and return extended rows", {
  def2  = Table.load(jsonlite::fromJSON(SOURCE, simplifyVector = FALSE), schema = SCHEMA)
  table = def2$value()
  rows = table$read(limit = 1, extended = TRUE)
  expect_equivalent(rows[[1]], list(2, list('id', 'height', 'age', 'name', 'occupation'), list(id = 1, height = 10.0, age = 1, name = 'string1', occupation =  lubridate::make_datetime(2012,6,15) )))
})


test_that("should infer headers and schema", {
  source = 'inst/extdata/data_infer.csv'
  def2  = Table.load(source)
  table = def2$value()
  table$infer()
  expect_equivalent(table$headers, list('id', 'age', 'name'))
  expect_identical(length(table$schema$fields), 3L)
})

test_that("should throw on read for headers/fieldNames missmatch", {
  source = list(
    list('id', 'bad', 'age', 'name', 'occupation'),
    list(1, '10.0', 1, 'string1', '2012-06-15 00:00:00')
  )
  def2  = Table.load(source, schema = SCHEMA)
  table = def2$value()
  expect_error(table$read(), ".*match schema field names.*")
})

test_that("should work with connection", {
  source = 'inst/extdata/data_big.csv'
  def2  = Table.load(source)
  table = def2$value()
  rows = table$read()
  expect_identical(length(rows),100L)
})




testthat::context("table #format")

test_that('should use csv format by default', {
  def2 = Table.load('inst/extdata/data_infer.csv')
  table= def2$value()
  rows = table$read(limit = 2)
  expect_equal(rows, jsonlite::fromJSON('[["1", "39", "Paul"], ["2", "23", "Jimmy"]]',simplifyVector = FALSE) )
})



testthat::context("table #encoding")

test_that('should use utf-8 by default', {
  def2 = Table.load('inst/extdata/data_infer.csv')
  table= def2$value()
  rows = table$read(limit = 2)
  expect_equal(rows, jsonlite::fromJSON('[["1", "39", "Paul"], ["2", "23", "Jimmy"]]',simplifyVector = FALSE) )
})

test_that('should use utf-8 by default for remote resource', {
  def2 = Table.load('https://raw.githubusercontent.com/frictionlessdata/tableschema-js/master/data/data_infer.csv')
  table= def2$value()
  rows = table$read(limit = 2)
  expect_equal(rows, jsonlite::fromJSON('[["1", "39", "Paul"], ["2", "23", "Jimmy"]]',simplifyVector = FALSE) )
})

test_that('should read correctly file with other encoding', {
  def2 = Table.load(system.file('extdata/latin1.csv', package = "tableschema.r"))
  table= def2$value()
  rows = table$read(limit = 2)
  expect_true(identical(rows, jsonlite::fromJSON('[["1", "english"], ["2", "©"]]',simplifyVector = FALSE)))
})

test_that('should support user-defined encoding', {
  def2 = Table.load(system.file('extdata/latin1.csv', package = "tableschema.r"), encoding = 'latin1')
  table= def2$value()
  rows = table$read(limit = 2)
  expect_equal(rows,jsonlite::fromJSON('[["1", "english"], ["2", "©"]]',simplifyVector = FALSE))
})

test_that('should support user-defined encoding for remote resource', {
  def2 = Table.load('https://raw.githubusercontent.com/frictionlessdata/tableschema-js/master/data/latin1.csv', encoding = 'latin1')
  table= def2$value()
  rows = table$read(limit = 2)
  expect_equal(rows,jsonlite::fromJSON('[["1", "english"], ["2", "©"]]',simplifyVector = FALSE))
})



testthat::context("table #parserOptions")

test_that('should use default limit param to parse file', {
  def2 = Table.load('inst/extdata/data_parse_options_default.csv')
  table= def2$value()
  rows = table$read(extended = TRUE, limit = 1)
  expect_equal(rows[1], list(list(2, list("id", "age", "name"), list("1", "39", "       Paul"))))
})




testthat::context("table #primaryKey")

SCHEMA =' {
"fields": [
{"name": "id1"},
{"name": "id2"}
],
"primaryKey": ["id1", "id2"]
}'
  
test_that('should fail with composity primary key not unique (issue #91)',{
  source = '[
  ["id1", "id2"],
  ["a", "1"],
  ["a", "1"]
  ]'
  def2 = Table.load(jsonlite::fromJSON(source,simplifyVector = FALSE), schema = SCHEMA)
  table= def2$value()
  expect_error(table$read())
})
