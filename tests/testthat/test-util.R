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

context("Data Commons API - R Client Utils")

test_that("Setting and unsetting API keys work correctly", {

  expect_gt(length(GetPropertyLabels("Class")[[1]]), 3)

  tmp <- Sys.getenv("API_KEY")
  SetApiKey("1234567")
  expect_error(GetPropertyLabels("Class"))

  SetApiKey(tmp)
  expect_gt(length(GetPropertyLabels("Class")[[1]]), 3)

  SetApiKey("foohahaha")
  expect_error(GetPropertyLabels("Class"))

  SetApiKey(tmp)
  expect_gt(length(GetPropertyLabels("Class")[[1]]), 3)
})

test_that("ConvertibleToPython works correctly", {
  # OK Case 1: single element unnamed list: no conversion
  expect_identical(ConvertibleToPython(list("W Apollo")), list("W Apollo"))
  expect_identical(ConvertibleToPython(list("A Scooter")), list("A Scooter"))
  expect_identical(ConvertibleToPython(list("Master Shifu")), list("Master Shifu"))

  # OK Case 2: single element atomic vector: convert to list
  expect_identical(ConvertibleToPython(c("My life")), list("My life"))
  expect_identical(ConvertibleToPython(c("In Theory")), list("In Theory"))
  expect_identical(ConvertibleToPython(c("What is your dream?")), list("What is your dream?"))

  # OK Case 3: string: convert to list
  expect_identical(ConvertibleToPython("API"), list("API"))
  expect_identical(ConvertibleToPython("IPY"), list("IPY"))
  expect_identical(ConvertibleToPython("Note book"), list("Note book"))

  # OK Case 4: multi element atomic vector: no conversion
  expect_identical(ConvertibleToPython(c("0", "1", "0", "0")), c("0", "1", "0", "0"))
  expect_identical(ConvertibleToPython(c("same", "mood", "dataR")), c("same", "mood", "dataR"))
  expect_identical(ConvertibleToPython(c("do", "or", "do not")), c("do", "or", "do not"))

  # OK Case 5: tibble: no conversion
  expect_identical(ConvertibleToPython(tibble("geoId/03")), tibble("geoId/03"))
  expect_identical(ConvertibleToPython(tibble(stateDcid = "geoId/03")), tibble(stateDcid = "geoId/03"))
  expect_identical(ConvertibleToPython(tibble(stateDcid = c("geoId/03", "geoId/23"))), tibble(stateDcid = c("geoId/03", "geoId/23")))
  expect_identical(ConvertibleToPython(tibble(c("geoId/03", "geoId/23"))), tibble(c("geoId/03", "geoId/23")))

  # OK Case 6: data frame: no conversion
  expect_identical(ConvertibleToPython(data.frame(stateDcid = "geoId/03")), data.frame(stateDcid = "geoId/03", stringsAsFactors = FALSE))
  expect_identical(ConvertibleToPython(data.frame("geoId/03")), data.frame("geoId/03", stringsAsFactors = FALSE))
  expect_identical(ConvertibleToPython(data.frame(stateDcid = c("geoId/03", "geoId/23"))), data.frame(stateDcid = c("geoId/03", "geoId/23"), stringsAsFactors = FALSE))
  expect_identical(ConvertibleToPython(data.frame(c("geoId/03", "geoId/23"))), data.frame(c("geoId/03", "geoId/23"), stringsAsFactors = FALSE))

  # WARNING Case 1: multi col tibble: take first column
  expect_warning(expect_identical(ConvertibleToPython(tibble(stateDcid = "geoId/03", stateBird = "BigBird")), tibble(stateDcid = "geoId/03")))
  expect_warning(expect_identical(ConvertibleToPython(tibble(c("geoId/03", "geoId/23"), c("BigBird", "BigBiird"))), tibble(c("geoId/03", "geoId/23"))))

  # WARNING Case 2: multi col data frame: take first column
  expect_warning(expect_identical(ConvertibleToPython(data.frame(stateDcid = "geoId/03", stateBird = "BigBird")), data.frame(stateDcid = "geoId/03", stringsAsFactors = FALSE)))
  expect_warning(expect_identical(ConvertibleToPython(data.frame(c("geoId/03", "geoId/23"), c("BigBird", "BigBiird"))), data.frame(c("geoId/03", "geoId/23"), stringsAsFactors = FALSE)))

  # BAD Case 1: multiple element unnamed list (only vector for multi elements)
  expect_error(ConvertibleToPython(list("0", "1", "0", "0")))
  expect_error(ConvertibleToPython(list("same", "mood", "data", "dataR")))
  expect_error(ConvertibleToPython(list("do", "or", "do not")))

  # BAD Case 2: named list (no names allowed)
  expect_error(ConvertibleToPython(list("0"="lose")))
  expect_error(ConvertibleToPython(list("0"="lose", "o"="oh")))
})

test_that("skip_if_no_dcpy works correctly", {
  ## Waiting on https://github.com/rstudio/reticulate/issues/580
  # system("pip uninstall datacommons --yes")
  # expect_error(skip_if_no_dcpy(), ".*python client not available for testing.*")

  system("pip install --upgrade --user --quiet git+https://github.com/datacommonsorg/api-python.git@v1.0.0")
  expect_output(skip_if_no_dcpy(), "datacommons:.*/datacommons")
})
