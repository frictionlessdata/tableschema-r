library(tableschema.r)
library(testthat)

context("Fields")


DESCRIPTOR_MIN <- list(name = "height", type = "number")

test_that("should get correct instance", {
  field <- Field$new(DESCRIPTOR_MIN,strict = FALSE)
  expect_equal(field$name, "height")
  expect_equal(field$format, "default")
  expect_equal(field$type, "number")
  expect_equal(field$constraints, list())
  expect_false(field$required)
})

test_that("should get correct instance", {
    field <- Field$new(DESCRIPTOR_MIN)
    expect_equal(field$name, "height")
    expect_equal(field$format, "default")
    expect_equal(field$type, "number")
    expect_equal(field$constraints, list())
    expect_false(field$required)
})

test_that("null field", {
  field <- Field$new(NULL)
  expect_null(field$name)
  expect_null(field$format)
  expect_null(field$type)
  expect_equal(field$constraints, list())
  expect_false(field$required)
})

test_that("should return true on test", {
    field <- Field$new(DESCRIPTOR_MIN)
    expect_true(field$testValue(1))
})


test_that("should return false on test", {
    field <- Field$new(DESCRIPTOR_MIN)
    expect_false(field$testValue('string'))
})

test_that("should cast value", {
    field <- Field$new(DESCRIPTOR_MIN)
    expect_equal(field$cast_value(1), 1)
})


test_that("should fail to cast value", {
    field <- Field$new(DESCRIPTOR_MIN)
    expect_error(field$cast_value('string'))
    expect_null(field$cast_value('',constraints = FALSE))
})

test_that("should expand descriptor by defaults", {
    field <- Field$new(list(name = "name"))
    expect_equivalent(field$descriptor, list(name = "name", type = "string", format = "default"))
})


test_that('should throw an error on incompatible value', {
  field <- Field$new(helpers.from.json.to.list('{"name": "column", "type": "integer"}'))
  expect_error(field$cast_value('bad-value'))
})

# test_that('str_length of factor is length of level', { expect_equal(str_length(factor('a')), 1) expect_equal(str_length(factor('ab')), 2) expect_equal(str_length(factor('abc')), 3) })
# test_that('str_length of missing is missing', { expect_equal(str_length(NA), NA_integer_) expect_equal(str_length(c(NA, 1)), c(NA, 1)) expect_equal(str_length('NA'), 2) })

test_that('should throw an error on incompatible value', {
  field <- Field$new(helpers.from.json.to.list('{"name": "column", "type": "integer", "constraints": {"minimum": 1}}'))
  expect_error(field$cast_value(0))
  expect_equal(field$cast_value(1),1)
})



context("Fields #constraints")

test_that('should parse descriptor with "enum" constraint', {
    field <- Field$new(list(name = "status", type = "string", constraints = list(enum = list('active', 'inactive'))))
    expect_equal(field$testValue('active'), TRUE)
    expect_equal(field$testValue('inactive'), TRUE)
    expect_equal(field$testValue('activia'), FALSE)
    expect_equal(field$cast_value('active'), 'active')
})

test_that('should parse descriptor with "minimum" constraint', {
    field <- Field$new(list(name = "length", type = "integer", constraints = list(minimum = 100)))
    expect_equal(field$testValue(200), TRUE)
    expect_equal(field$testValue(50), FALSE)
    expect_equal(field$cast_value(100), 100)
})

test_that('should parse descriptor with "minLength" constraint', {
  field <- Field$new(list(name = "name", type = "string", constraints = list(minLength = 2)))
  expect_equal(field$testValue("a"), FALSE)
  expect_equal(field$testValue("ab"), TRUE)
  expect_equal(field$testValue("abc"), TRUE)
  expect_equal(field$testValue(""), TRUE)
})

test_that('should parse descriptor with "maximum" constraint', {
    field <- Field$new(list(name = "length", type = "integer", constraints = list(maximum = 100)))
    expect_equal(field$testValue(50), TRUE)
    expect_equal(field$testValue(200), FALSE)
    expect_equal(field$cast_value(100), 100)
})

test_that('should parse descriptor with "maxLength" constraint', {
  field <- Field$new(list(name = "name", type = "string", constraints = list(maxLength = 2)))
  expect_equal(field$testValue("a"), TRUE)
  expect_equal(field$testValue("ab"), TRUE)
  expect_equal(field$testValue("abc"), FALSE)
  expect_equal(field$testValue(""), TRUE)
})

test_that('should parse descriptor with "pattern" constraint', {
  field <- Field$new(list(name = "name", type = "string", constraints = list(pattern = '^3.*')))
  expect_equal(field$testValue("3"), TRUE)
  expect_equal(field$testValue("321"), TRUE)
  expect_equal(field$testValue("123"), FALSE)
})

test_that('should parse descriptor with "unique" constraint', {
  field <- Field$new(list(name = "name", type = "integer", constraints = list(unique = TRUE)))
  expect_equal(field$testValue(30000), TRUE)
  expect_equal(field$testValue("bad"), FALSE)
})

test_that('should parse descriptor with "required" constraint', {
  field <- Field$new(list(name = "name", type = "string", constraints = list(required = TRUE)), missingValues = list("", "NA", "N/A"))
  expect_equal(field$testValue("test"), TRUE)
  expect_equal(field$testValue("NULL"), TRUE)
  expect_equal(field$testValue("none"), TRUE)
  expect_equal(field$testValue("nil"), TRUE)
  expect_equal(field$testValue("nan"), TRUE)
  expect_equal(field$testValue("NaN"), TRUE)
  expect_equal(field$testValue("NA"), FALSE)
  expect_equal(field$testValue("N/A"), FALSE)
  expect_equal(field$testValue("-"), TRUE)
  expect_equal(field$testValue(""), FALSE)
})

context("Fields #missing values")

test_that('test type string missingValues', {
  field <- Field$new(list(name = "name", type = "string"), missingValues = list("", "NA", "N/A"))
  expect_null(field$cast_value(""))
  expect_null(field$cast_value("NA"))
  expect_null(field$cast_value("N/A"))
})

test_that('test type number missingValues', {
  field <- Field$new(list(name = "name", type = "number"), missingValues = list("", "NA", "N/A"))
  expect_null(field$cast_value(""))
  expect_null(field$cast_value("NA"))
  expect_null(field$cast_value("N/A"))
})

test_that('test cast value null with missing values', {
  field <- Field$new(list(name = "name", type = "number"), missingValues = list("NULL"))
  expect_null(field$cast_value("NULL"))
})

DESCRIPTOR_MAX <- list(name = "height", type = "integer", format = "default",constraints = list(required = TRUE))

test_that("should get correct instance", {
  field <- Field$new(DESCRIPTOR_MAX)
  expect_equal(field$name, "height")
  expect_equal(field$format, "default")
  expect_equal(field$type, "integer")
  expect_equal(field$constraints, list(required = TRUE))
  expect_equal(field$cast_value(1), 1)
  expect_equal(field$cast_value("1"), 1)
  expect_error(field$cast_value(""))
  expect_true(field$testValue(1))
  expect_false(field$testValue("string"))
  expect_false(field$testValue(""))
  
})
