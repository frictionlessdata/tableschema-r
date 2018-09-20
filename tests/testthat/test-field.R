library(tableschema.r)
library(testthat)

context("Fields")


DESCRIPTOR_MIN = list(name = "height", type = "number")



test_that("should get correct instance", {
    field <- Field$new(DESCRIPTOR_MIN)
    expect_equal(field$name, "height")
    expect_equal(field$format, "default")
    expect_equal(field$type, "number")
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
})

test_that("should expand descriptor by defaults", {
    field <- Field$new(list(name = "name"))
    expect_equivalent(field$descriptor, list(name = "name", type = "string", format = "default"))
})

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

test_that('should parse descriptor with "maximum" constraint', {
    field <- Field$new(list(name = "length", type = "integer", constraints = list(maximum = 100)))
    expect_equal(field$testValue(50), TRUE)
    expect_equal(field$testValue(200), FALSE)
    expect_equal(field$cast_value(100), 100)
})

test_that("str_length is number of characters", {
    expect_equal(str_length("a"), 1)
    expect_equal(str_length("ab"), 2)
    expect_equal(str_length("abc"), 3)
})

test_that('should throw an error on incompatible value', {
  field = Field$new(helpers.from.json.to.list('{"name": "column", "type": "integer"}'))
  expect_error(field$cast_value('bad-value'))
})

# test_that('str_length of factor is length of level', { expect_equal(str_length(factor('a')), 1) expect_equal(str_length(factor('ab')), 2) expect_equal(str_length(factor('abc')), 3) })
# test_that('str_length of missing is missing', { expect_equal(str_length(NA), NA_integer_) expect_equal(str_length(c(NA, 1)), c(NA, 1)) expect_equal(str_length('NA'), 2) })

test_that('should throw an error on incompatible value', {
  field = Field$new(helpers.from.json.to.list('{"name": "column", "type": "integer", "constraints": {"minimum": 1}}'))
  expect_error(field$cast_value(0))
  expect_equal(field$cast_value(1),1)
})
