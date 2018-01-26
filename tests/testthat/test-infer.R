library(stringr)
library(tableschema.r)
library(testthat)
library(foreach)
library(lubridate)


testthat::context("infer")

test_that("respect row limit parameter", {

  source = 'inst/extdata/data_infer_row_limit.csv'
  descriptor = infer(source, options = list(limit = 4))
  expect_equivalent(descriptor$fields, list(
    list(name = 'id', type = 'integer', format = 'default'),
    list(name = 'age', type = 'integer', format = 'default'),
    list(name = 'name', type = 'string', format = 'default')
  ))
})


test_that("produce schema from a generic .csv UTF-8 encoded", {

  source = 'inst/extdata/data_infer_utf8.csv'
  descriptor = infer(source)
  expect_equivalent(descriptor$fields, list(
    list(name = 'id', type = 'integer', format = 'default'),
    list(name = 'age', type = 'integer', format = 'default'),
    list(name = 'name', type = 'string', format = 'default')
  ))
})

test_that("produce schema from a generic .csv", {

  source = 'inst/extdata/data_infer.csv'
  descriptor = infer(source)
  expect_equivalent(descriptor$fields, list(
    list(name = 'id', type = 'integer', format = 'default'),
    list(name = 'age', type = 'integer', format = 'default'),
    list(name = 'name', type = 'string', format = 'default')
  ))
})


