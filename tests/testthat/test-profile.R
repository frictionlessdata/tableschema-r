library(stringr)
library(tableschema.r)
library(testthat)
library(foreach)
library(lubridate)
library(readr)


testthat::context("profile")

# 
# test_that("table-schema is up-to-date", {
#   
#   
#   res = jsonlite::fromJSON('https://specs.frictionlessdata.io/schemas/table-schema.json', simplifyVector = T)
#   profile = Profile.load('tableschema')
#   expect_identical(lapply(res,unlist,use.names = F), lapply(profile$jsonschema, unlist, use.names=F))
# })


# test_that("table-schema is up-to-date", {
#   profile = Profile.load('geojson')
#   expect_type(profile$jsonschema, NULL )
#   
# })
