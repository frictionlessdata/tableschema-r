library(stringr)
library(hash)
library(tableschema.r)
library(testthat)


testthat::context("Schema")

SCHEMA_MIN <- list(
  fields = list(
    list(name = 'id'),
    list(name = 'height')
  )
)


SCHEMA <- list(
  fields = list(
    list(name = 'id', type = 'string', constraints = list(required = TRUE)),
    list(name = 'height', type = 'number'),
    list(name = 'age', type = 'integer'),
    list(name = 'name', type = 'string', constraints = list(required = TRUE)),
    list(name = 'occupation', type = 'string')
  )
)




test_that("have a correct number of fields", {
  def  = schema.load2(SCHEMA)
  schema = def$value()
  
    lng = length(schema$fields)
    expect_equal(5, lng)
})
