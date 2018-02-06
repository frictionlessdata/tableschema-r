library(stringr)
library(tableschema.r)
library(testthat)
library(foreach)

testthat::context("types.castTime")

Time = function(hour, minute=0, second=0) {
  value = lubridate::as_datetime(lubridate::make_datetime(0, 0, 1, hour, minute, second,tz = "UTC"))
  unlist(strsplit(as.character(value), " "))[[2]]
}

# Constants

TESTS = list(
  
  list('default', Time(6), Time(6)),
  list('default', '06:00:00', Time(6)),
  list('default', '09:00', config::get("ERROR")),
  list('default', '3 am', config::get("ERROR")),
  list('default', '3.00', config::get("ERROR")),
  list('default', 'invalid', config::get("ERROR")),
  list('default', TRUE, config::get("ERROR")),
  list('default', '', config::get("ERROR")),
  list('any', Time(6), Time(6)),
  ### list(/ ['any', '06:00:00', Time(6)),
  ### list(/ ['any', '3:00 am', Time(3)),
  list('any', 'some night', config::get("ERROR")),
  list('any', 'invalid', config::get("ERROR")),
  list('any', TRUE, config::get("ERROR")),
  list('any', '', config::get("ERROR")),
  # list('%H:%M', Time(6), Time(6)),
  # list('%H:%M', '06:00', Time(6)),
  ### list(/ ['%M:%H', '06:50', config::get("ERROR")),
  # list('%H:%M', '3:00 am', config::get("ERROR")),
  list('%H:%M', 'some night', config::get("ERROR")),
  list('%H:%M', 'invalid', config::get("ERROR")),
  list('%H:%M', TRUE, config::get("ERROR")),
  list('%H:%M', '', config::get("ERROR")),
  list('invalid', '', config::get("ERROR")),
  ### list(/ Deprecat)d
  # list('fmt:%H:%M', Time(6), Time(6)),
  # list('fmt:%H:%M', '06:00', Time(6)),
  ### list(/ ['fmt:%M:%H', '06:50', config::get("ERROR")),
  # list('fmt:%H:%M', '3:00 am', config::get("ERROR")),
  list('fmt:%H:%M', 'some night', config::get("ERROR")),
  list('fmt:%H:%M', 'invalid', config::get("ERROR")),
  list('fmt:%H:%M', TRUE, config::get("ERROR")),
  list('fmt:%H:%M', '', config::get("ERROR"))
)

# Tests

foreach(j = 1:length(TESTS) ) %do% {
  
  TESTS[[j]] = setNames(TESTS[[j]], c("format", "value", "result"))
  
  test_that(stringr::str_interp('format "${TESTS[[j]]$format}" should check "${TESTS[[j]]$value}" as "${TESTS[[j]]$result}"'), {
    
    expect_equal(types.castTime(TESTS[[j]]$format, TESTS[[j]]$value), TESTS[[j]]$result)
  })
}
