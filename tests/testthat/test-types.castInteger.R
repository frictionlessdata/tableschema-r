library(stringr)
library(tableschema.r)
library(testthat)
library(foreach)
library(config)

context("types.castInteger")

# Constants

TESTS <- list(
  list('default', 1, 1, {} ),
  list('default', '1', 1, {} ),
  list('default', '1$', 1, list(bareNumber = FALSE) ),
  list('default', 'ab1$', 1, list(bareNumber = FALSE) ),
  list('default', '3.14', config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")), {}),
  list('default', '', config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")), {}),
  list('default', 1.2, config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")), {}),
  list('default', types.castInteger('default', list(1:5)), config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")), {})
)
# Tests

foreach(j = seq_along(TESTS) ) %do% {
  
  TESTS[[j]] <- setNames(TESTS[[j]], c("format", "value", "result","options"))
  
  test_that(str_interp('format "${TESTS[[j]]$format}" should check "${TESTS[[j]]$value}" as "${TESTS[[j]]$result}"'), {
    
    expect_equal(types.castInteger(TESTS[[j]]$format, TESTS[[j]]$value, TESTS[[j]]$options), TESTS[[j]]$result)
  })
}

test_that('error at NULL values',{
          expect_error(types.castInteger('default', NULL))
})
