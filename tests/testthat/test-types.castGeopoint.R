library(stringr)
library(tableschema.r)
library(testthat)
library(foreach)

testthat::context("types.castGeopoint")

# Constants

TESTS = list(
  list('default', list(180, 90), list(180, 90) ),
  list('default', '180,90', list(180, 90) ),
  list('default', '180, -90', list(180, -90) ),
  list('default', list(lon = 180, lat = 90), config::get("ERROR") ),
  list('default', list(181,90), config::get("ERROR") ),
  list('default', '0,91', config::get("ERROR") ),
  list('default', 'string', config::get("ERROR") ),
  list('default', 1, config::get("ERROR") ),
  list('default', '3.14', config::get("ERROR") ),
  list('default', '', config::get("ERROR") ),
  list('array', list(180, 90), list(180, 90) ),
  list('array', '[180, -90]', list(180, -90)),
  list('array', list(lon = 180, lat = 90), config::get("ERROR")),
  list('array', list(181, 90), config::get("ERROR")),
  list('array', list(0, 91), config::get("ERROR")),
  
  list('array', '180,90', config::get("ERROR")),
  list('array', 'string', config::get("ERROR")),
  list('array', 1, config::get("ERROR")),
  list('array', '3.14', config::get("ERROR")),
  list('array', '', config::get("ERROR")),
  
  list('object', list(lon = 180, lat = 90), list(180, 90)),
  list('object', '{"lon": 180, "lat": 90}', list(180, 90)),
  #list('object', '[180, -90]', config::get("ERROR")),
  
  list('object', "{'lon': 181, 'lat': 90}", config::get("ERROR")),
  list('object', "{'lon': 180, 'lat': -91}", config::get("ERROR")),
  
  #list('object', list(180, -90), config::get("ERROR")),
  list('object', '180,90', config::get("ERROR")),
  list('object', 'string', config::get("ERROR")),
  list('object', 1, config::get("ERROR")),
  list('object', '3.14', config::get("ERROR")),
  list('object', '', config::get("ERROR"))
  )

# Tests

foreach(j = 1:length(TESTS) ) %do% {
  
  TESTS[[j]] = setNames(TESTS[[j]], c("format", "value", "result"))
  
  test_that(stringr::str_interp('format "${TESTS[[j]]$format}" should check "${TESTS[[j]]$value}" as "${TESTS[[j]]$result}"'), {
    
    expect_equal(types.castGeopoint(TESTS[[j]]$format, TESTS[[j]]$value), TESTS[[j]]$result)
  })
}
