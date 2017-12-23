library(stringr)
library(tableschema.r)
library(testthat)
library(foreach)

testthat::context("types.castBoolean")

# Constants

TESTS = list(
  
  list("default", TRUE, TRUE, {} ),
  list("default", "TRUE", TRUE, {} ),
  list("default", "TRUE", TRUE, {} ),
  list("default", "TRUE", TRUE, {} ),
  list("default", "1", TRUE,{} ),
  list("default", "yes", TRUE, list(trueValues = list("yes")) ),
  list("default", FALSE, FALSE, {} ),
  list("default", "FALSE", FALSE, {} ),
  list("default", "FALSE", FALSE, {} ),
  list("default", "FALSE", FALSE, {} ),
  list("default", "0", FALSE, {}),
  list("default", "no", FALSE, list(falseValues = list("no")) ),
  list("default", "YES", config::get("ERROR"), {} ),
  list("default", "Yes", config::get("ERROR"), {} ),
  list("default", "yes", config::get("ERROR"), {} ),
  list("default", "y", config::get("ERROR"), {} ),
  list("default", "t", config::get("ERROR"), {} ),
  list("default", "f", config::get("ERROR"), {} ),
  list("default", "no", config::get("ERROR"), {} ),
  list("default", "n", config::get("ERROR"), {} ),
  list("default", "NO", config::get("ERROR"), {} ),
  list("default", "No", config::get("ERROR"), {} ),
  list("default", 0, config::get("ERROR"), {} ),
  list("default", 1, config::get("ERROR"), {} ),
  list("default", "3.14", config::get("ERROR"), {} ),
  list("default", "", config::get("ERROR"), {} )

)

# Tests

foreach(j = 1:length(TESTS) ) %do% {
  
  TESTS[[j]] = setNames(TESTS[[j]], c("format", "value", "result", "options"))
  
  test_that(stringr::str_interp('format "${TESTS[[j]]$format}" should check "${TESTS[[j]]$value}" as "${TESTS[[j]]$result}"'), {
    
    expect_equal(types.castBoolean(TESTS[[j]]$format, TESTS[[j]]$value, TESTS[[j]]$options), TESTS[[j]]$result)
  })
}
