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

context("Data Commons Node API (Places Extension) - R Client")

test_that("GetPlaces gets correct containment data", {
  skip_if_no_dcpy()
  # INPUT atomic vector of the dcids of Santa Clara and Montgomery County.
  countyDcids <- c('geoId/06085', 'geoId/24031')
  # Get towns in Santa Clara and Montgomery County.
  towns <- GetPlacesIn(countyDcids, 'Town')

  expect_equal(length(towns), 2)

  expect_gt(length(towns[['geoId/06085']]), 1)
  expect_match(towns[['geoId/06085']][1], "geoId/06.*")

  expect_gt(length(towns[['geoId/24031']]), 8)
  expect_match(towns[['geoId/24031']][1], "geoId/24.*")
  expect_match(towns[['geoId/24031']][3], "geoId/24.*")
  expect_match(towns[['geoId/24031']][5], "geoId/24.*")
})

test_that("GetPlaces works with tibble/data frame input", {
  skip_if_no_dcpy()
  # INPUT tibble of the dcids of Santa Clara and Montgomery County.
  df <- tibble(countyDcid = c('geoId/06085', 'geoId/24031'))
  # Get towns in Santa Clara and Montgomery County.
  df$townDcid <- GetPlacesIn(df, 'Town')
  # Since GetPlacesIn returned a mapping between counties and
  # a list of towns, use you can use tidyr::unnest to create
  # a 1-1 mapping between each county and its towns.

  expect_equal(dim(df), c(2, 2))
  expect_true(is.data.frame(df))
  expect_true(is_tibble(df))

  # Should be at least one town in Santa Clara
  expect_gt(length(filter(df, countyDcid=='geoId/06085')$townDcid[[1]]), 1)
  expect_match(filter(df, countyDcid=='geoId/06085')$townDcid[[1]][1], "geoId/06.*")

  # Should be at least 8 towns in Montgomery
  expect_gt(length(filter(df, countyDcid=='geoId/24031')$townDcid[[1]]), 8)
  expect_match(filter(df, countyDcid=='geoId/24031')$townDcid[[1]][1], "geoId/24.*")
  expect_match(filter(df, countyDcid=='geoId/24031')$townDcid[[1]][3], "geoId/24.*")
  expect_match(filter(df, countyDcid=='geoId/24031')$townDcid[[1]][5], "geoId/24.*")
})
