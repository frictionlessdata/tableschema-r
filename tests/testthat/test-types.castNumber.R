library(stringr)
library(tableschema.r)
library(testthat)
library(foreach)

testthat::context("types.castNumber")

# Constants

TESTS = list(
  list('default', 1, 1, {}), 
  list('default', 1, 1, {}),
  list('default', 1.0, 1, {}),
  list('default', '1', 1, {}),
  list('default', '10.00', 10, {}),
  list('default', '10.50', 10.5, {}),
  list('default', '100%', 100, list(bareNumber = FALSE) ),
  list('default', '1000‰', 1000, list(bareNumber = FALSE) ),
  list('default', '-1000', -1000, {}),
  list('default', '1,000', 1000, list(groupChar = ',') ),
  list('default', '10,000.00', 10000, list(groupChar = ',') ),
  list('default', '10,000,000.50', 10000000.5, list(groupChar = ',') ),
  list('default', '10#000.00', 10000, list(groupChar = '#') ),
  list('default', '10#000#000.50', 10000000.5, list(groupChar = '#') ),
  list('default', '10.50', 10.5, list(groupChar = '#') ),
  list('default', '1#000', 1000, list(groupChar = '#') ),
  list('default', '10#000@00', 10000, list(groupChar = '#', decimalChar = '@') ),
  list('default', '10#000#000@50', 10000000.5, list(groupChar = '#', decimalChar = '@') ),
  list('default', '10@50', 10.5, list(groupChar= '#', decimalChar= '@') ),
  list('default', '1#000', 1000, list(groupChar= '#', decimalChar= '@') ),
  
  list('default', '10,000.00', 10000, list( groupChar = ',', bareNumber= FALSE) ),
  list('default', '10,000,000.00', 10000000, list(groupChar = ',', bareNumber = FALSE) ),
  list('default', '$10000.00', 10000, list(bareNumber = FALSE) ),
  list('default', '  10,000.00 €', 10000, list(groupChar = ',', bareNumber = FALSE) ),
  list('default', '10 000,00', 10000, list(groupChar = ' ', decimalChar = ',') ),
  list('default', '10 000 000,00', 10000000, list(groupChar = ' ', decimalChar = ',') ),
  # ['default', '10000,00 ₪', 10000, {'groupChar': ' ', 'decimalChar': ',', 'bareNumber': FALSE}),
  list('default', '  10 000,00 £', 10000, list( groupChar = ' ', decimalChar = ',', bareNumber = FALSE) ),
  list('default', '10,000a.00', config::get("ERROR"), {} ),
  list('default', '10+000.00', config::get("ERROR"), {} ),
  list('default', '$10:000.00', config::get("ERROR"), {} ),
  list('default', 'string', config::get("ERROR"), {} ),
  list('default', '', config::get("ERROR"), {} )
)
# Tests

foreach(j = 1:length(TESTS) ) %do% {
  
  TESTS[[j]] = setNames(TESTS[[j]], c("format", "value", "result","options"))
  
  test_that(stringr::str_interp('format "${TESTS[[j]]$format}" should check "${TESTS[[j]]$value}" as "${TESTS[[j]]$result}"'), {
    
    expect_equal(types.castNumber(TESTS[[j]]$format, TESTS[[j]]$value, TESTS[[j]]$options), TESTS[[j]]$result)
  })
}
