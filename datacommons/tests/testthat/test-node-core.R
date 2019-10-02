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

context("Data Commons Node API (Core) - R Client")

test_that("get_property_labels returns incoming and outgoing labels", {
  skip_if_no_dcpy()

  sccDcid <- list('geoId/06085')

  expect_true('containedInPlace' %in% get_property_labels(sccDcid, out = FALSE)[[1]])

  expectedOutLabels = c("ansiCode", "containedInPlace", "geoId", "kmlCoordinates",
                        "landArea", "latitude", "longitude", "name", "provenance",
                        "typeOf", "waterArea")
  actualOutLabels = get_property_labels(sccDcid)
  expect_true('geoId' %in% actualOutLabels[[1]])
  expect_true('name' %in% actualOutLabels[[1]])
  expect_true('typeOf' %in% actualOutLabels[[1]])
  expect_true('containedInPlace' %in% actualOutLabels[[1]])
  expect_gt(sum(actualOutLabels[[1]] %in% expectedOutLabels * 1), 6)

  dcids <- c('geoId/12', 'plannedParenthood-PlannedParenthoodWest',
             'politicalParty/RepublicanParty')
  inLabels <- get_property_labels(dcids, out = FALSE)
  outLabels <- get_property_labels(dcids)
  expect_equal(length(inLabels), 3)
  expect_gt(length(unlist(inLabels)), 4)
  expect_equal(length(outLabels), 3)
  expect_gt(length(unlist(outLabels)), 15)
})

test_that("get_property_labels fails with invalid API key", {
  skip_if_no_dcpy()

  tmp <- Sys.getenv("API_KEY")
  set_api_key("invalidkey")
  expect_error(get_property_labels(list('geoId/06085'), out = FALSE),
               ".*Response error: An HTTP 400 code.*")
  set_api_key(tmp)
})

test_that("get_property_values returns incoming and outgoing edges", {
  skip_if_no_dcpy()

  # INPUT atomic vector of Santa Clara County dcid
  sccDcid <- 'geoId/06085'
  landArea <- get_property_values(sccDcid, 'landArea')
  area <- get_property_values(unname(landArea), 'value')

  expect_gt(as.numeric(area), 2000000000)
  expect_lt(as.numeric(area), 5000000000)

  countyDcids <- c('geoId/06085', 'geoId/12086')
  # Get all containing Cities.
  cityDcids <- get_property_values(countyDcids, 'containedInPlace', out = FALSE, value_type = 'City')

  expect_gt(length(cityDcids['geoId/12086'][[1]]), 60)
  expect_lt(length(cityDcids['geoId/12086'][[1]]), 80)
  expect_match(cityDcids['geoId/12086'][[1]][1], 'geoId/12.*')

  expect_gt(length(cityDcids['geoId/06085'][[1]]), 15)
  expect_lt(length(cityDcids['geoId/06085'][[1]]), 35)
  expect_match(cityDcids['geoId/06085'][[1]][2], 'geoId/06.*')

  # INPUT tibble with Santa Clara and Miami-Dade County dcids
  df <- tibble(countyDcid = c('geoId/06085', 'geoId/12086'))
  # Get all containing Cities.
  df$cityDcid <- get_property_values(df$countyDcid, 'containedInPlace', out = FALSE, value_type = 'City')
  expect_setequal(df$cityDcid, cityDcids)

  # INPUT data frame with Santa Clara and Miami-Dade County dcids
  df <- data.frame(countyDcid = c('geoId/06085', 'geoId/12086'))
  # Get all containing Cities.
  df$cityDcid <- get_property_values(select(df, countyDcid), 'containedInPlace', out = FALSE, value_type = 'City')
  expect_setequal(df$cityDcid, cityDcids)
})

test_that("get_property_values fails with fake API key", {
  skip_if_no_dcpy()

  tmp <- Sys.getenv("API_KEY")
  set_api_key("fakekey")
  expect_error(get_property_values(list('geoId/06085'), 'landArea'),
               ".*Response error: An HTTP 400 code.*")
  set_api_key(tmp)
})

test_that("get_triples returns triples involving given dcid(s)", {
  skip_if_no_dcpy()

  sccDcid <- 'geoId/06085'
  triples <- get_triples(sccDcid, limit=100)

  expect_equal(length(triples), 1)
  expect_gte(length(triples[[1]]), 100)
  expect_equal(length(triples[[1]][[1]]), 3)
  expect_equal(length(triples[[1]][[23]]), 3)
  expect_equal(length(triples[[1]][[80]]), 3)

  countyDcids <- c('geoId/06085', 'geoId/12086')
  triples2 <- get_triples(countyDcids, limit=100)

  expect_equal(length(triples2), 2)
  expect_equal(length(triples2[[1]]), length(triples[[1]]))
  expect_gte(length(triples2[[2]]), 100)
  expect_equal(length(triples2[[2]][[1]]), 3)
  expect_equal(length(triples2[[2]][[23]]), 3)
  expect_equal(length(triples2[[2]][[80]]), 3)
})

test_that("get_triples fails with invalid API key", {
  skip_if_no_dcpy()

  tmp <- Sys.getenv("API_KEY")
  set_api_key("invalidkey")
  expect_error(get_triples(list('geoId/06085'), limit=100),
               ".*Response error: An HTTP 400 code*")
  set_api_key(tmp)
})
