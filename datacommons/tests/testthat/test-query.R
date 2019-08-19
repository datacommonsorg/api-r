# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

context("Data Commons Query API - R Client")

test_that("query returns California data", {
  califQuery1 <- "SELECT  ?name
    WHERE {
     ?a typeOf Place .
     ?a name ?name .
     ?a dcid \"geoId/06\"
    }
    "
  califQuery2 <- "SELECT  ?name
    WHERE {
     ?a typeOf Place .
     ?a name ?name .
     ?a dcid 'geoId/06'
    }
    "

  expect_identical(Query(califQuery1)[[1]], "California")
  expect_identical(Query(califQuery2)[[1]], "California")
})

test_that("query returns large dataframe", {
  unemploymentQuery = "SELECT ?pop ?Unemployment
    WHERE {
      ?pop typeOf StatisticalPopulation .
      ?o typeOf Observation .
      ?pop dcid ('dc/p/qep2q2lcc3rcc' 'dc/p/gmw3cn8tmsnth' 'dc/p/92cxc027krdcd') .
      ?o observedNode ?pop .
      ?o measuredValue ?Unemployment
    }"
  df = Query(unemploymentQuery)

  expect_gt(dim(df)[1], 400)
  expect_equal(dim(df)[2], 2)
  expect_true('dc/p/qep2q2lcc3rcc' %in% df$`?pop`)
  expect_true('dc/p/gmw3cn8tmsnth' %in% df$`?pop`)
  expect_true('dc/p/92cxc027krdcd' %in% df$`?pop`)
  expect_true(3.8 %in% df$`?Unemployment`)
  expect_true(4.7 %in% df$`?Unemployment`)
})

test_that("Query fails when API key is wiped", {
  keyCopy = Sys.getenv("API_KEY")
  Sys.unsetenv("API_KEY")
  califQuery1 <- "SELECT  ?name
    WHERE {
     ?a typeOf Place .
     ?a name ?name .
     ?a dcid \"geoId/06\"
    }
    "
  expect_error(Query(califQuery1)[[1]],
               ".*Response error: An HTTP 401 code.*")
  Sys.setenv("API_KEY" = keyCopy)
})

test_that("Query fails when API key is invalid", {
  keyCopy = Sys.getenv("API_KEY")
  Sys.setenv(API_KEY = "fakekey")
  califQuery1 <- "SELECT  ?name
    WHERE {
     ?a typeOf Place .
     ?a name ?name .
     ?a dcid \"geoId/06\"
    }
    "
  expect_error(Query(califQuery1)[[1]],
               ".*Response error: An HTTP 400 code.*")
  Sys.setenv("API_KEY" = keyCopy)
})
