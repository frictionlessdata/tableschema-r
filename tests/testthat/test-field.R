library(stringr)
library(hash)
library(tableschema.r)
library(testthat)


testthat::context("Fields")


DESCRIPTOR_MIN <- hash(name = "height", type = "number")



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
    expect_equal(field$cast_value('1'), 1)

})

test_that("should fail to cast value", {
    field <- Field$new(DESCRIPTOR_MIN)
    expect_error(field$cast_value('string'))

})

test_that("should cast value", {
    field <- Field$new(hash(name = "name"))
    expect_equivalent(field$descriptor, hash(name="name", type="string", format="default"))

})


test_that('should parse descriptor with "enum" constraint', {
    field <- Field$new(hash(name = "status", type = "string", constraints = list(enum = list('active', 'inactive'))))
    expect_equal(field$testValue('active'), TRUE)
    expect_equal(field$testValue('inactive'), TRUE)
    expect_equal(field$testValue('activia'), FALSE)

})
   
   


test_that('should parse descriptor with "minimum" constraint', {
    field <- Field$new(hash(name = "length", type = "integer", constraints = list(minimum = 100)))
    expect_equal(field$testValue(200), TRUE)
    expect_equal(field$testValue(50), FALSE)

})

test_that('should parse descriptor with "maximum" constraint', {
    field <- Field$new(hash(name = "length", type = "integer", constraints = list(maximum = 100)))
    expect_equal(field$testValue(50), TRUE)
    expect_equal(field$testValue(200), FALSE)

})

test_that("str_length is number of characters", {
    expect_equal(str_length("a"), 1)
    expect_equal(str_length("ab"), 2)
    expect_equal(str_length("abc"), 3)
})

# test_that('str_length of factor is length of level', { expect_equal(str_length(factor('a')), 1) expect_equal(str_length(factor('ab')), 2) expect_equal(str_length(factor('abc')), 3) })

# test_that('str_length of missing is missing', { expect_equal(str_length(NA), NA_integer_) expect_equal(str_length(c(NA, 1)), c(NA, 1)) expect_equal(str_length('NA'), 2) })
