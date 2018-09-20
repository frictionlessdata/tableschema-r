library(stringr)
library(tableschema.r)
library(testthat)
library(foreach)
library(config)

context("types.castDuration")

# Constants

TESTS = list(
  
  list("default", durations(years = 1), durations(years = 1)),
  list("default", "P1Y10M3DT5H11M7S",  durations(years = 1, months = 10, days = 3, hours = 5, minutes = 11, seconds = 7)),
  #list("default", "P1Y", durations({years: 1})),
  #list("default", "P1M", durations(months = 1)),
  list("default", "P1M1Y", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  list("default", "P-1Y", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  list("default", "year", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  list("default", TRUE, config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  list("default", FALSE, config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  list("default", 1, config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  list("default", "", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  list("default", list(), config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  list("default", {}, config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
  
)

# Tests

foreach(j = 1:length(TESTS) ) %do% {
  
  TESTS[[j]] = setNames(TESTS[[j]], c("format", "value", "result"))
  
  test_that(str_interp('format "${TESTS[[j]]$format}" should check "${TESTS[[j]]$value}" as "${TESTS[[j]]$result}"'), {
    
    expect_equal(types.castDuration(TESTS[[j]]$format, TESTS[[j]]$value), TESTS[[j]]$result)
  })
}
