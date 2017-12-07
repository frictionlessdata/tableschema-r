library(stringr)
library(tableschema.r)
library(testthat)
library(foreach)
library(lubridate)

testthat::context("types.castDuration")

# Constants

TESTS = list(

  # list("default", moment.duration({years: 1}), moment.duration({years: 1})),
  # list("default", "P1Y10M3DT5H11M7S",  moment.duration({years: 1, months: 10, days: 3, hours: 5, minutes: 11, seconds: 7})),
  # list("default", "P1Y", moment.duration({years: 1})),
  # list("default", "P1M", moment.duration({months: 1})),
  list("default", "P1M1Y", config::get("ERROR")),
  list("default", "P-1Y", config::get("ERROR")),
  list("default", "year", config::get("ERROR")),
  list("default", TRUE, config::get("ERROR")),
  list("default", FALSE, config::get("ERROR")),
  list("default", 1, config::get("ERROR")),
  list("default", "", config::get("ERROR")),
  list("default", list(), config::get("ERROR")),
  list("default", {}, config::get("ERROR"))

)

# Tests

foreach(j = 1:length(TESTS) ) %do% {

  TESTS[[j]] = setNames(TESTS[[j]], c("format", "value", "result"))

  test_that(stringr::str_interp('format "${TESTS[[j]]$format}" should check "${TESTS[[j]]$value}" as "${TESTS[[j]]$result}"'), {

    expect_equal(types.castDuration(TESTS[[j]]$format, TESTS[[j]]$value), TESTS[[j]]$result)
  })
}
