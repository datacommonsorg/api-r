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

test_that("ConvertibleToPythonList works correctly", {
  # OK Case 1: single element unnamed list: no conversion
  expect_identical(ConvertibleToPythonList(list("W Apollo")), list("W Apollo"))
  expect_identical(ConvertibleToPythonList(list("A Scooter")), list("A Scooter"))
  expect_identical(ConvertibleToPythonList(list("Master Shifu")), list("Master Shifu"))

  # OK Case 2: single element atomic vector: convert to list
  expect_identical(ConvertibleToPythonList(c("My life")), list("My life"))
  expect_identical(ConvertibleToPythonList(c("In Theory")), list("In Theory"))
  expect_identical(ConvertibleToPythonList(c("What is your dream?")), list("What is your dream?"))

  # OK Case 3: string: convert to list
  expect_identical(ConvertibleToPythonList("API"), list("API"))
  expect_identical(ConvertibleToPythonList("IPY"), list("IPY"))
  expect_identical(ConvertibleToPythonList("Note book"), list("Note book"))

  # OK Case 4: multi element atomic vector: no conversion
  expect_identical(ConvertibleToPythonList(c("0", "1", "0", "0")), c("0", "1", "0", "0"))
  expect_identical(ConvertibleToPythonList(c("same", "mood", "dataR")), c("same", "mood", "dataR"))
  expect_identical(ConvertibleToPythonList(c("do", "or", "do not")), c("do", "or", "do not"))

  # OK Case 5: tibble: no conversion
  expect_identical(ConvertibleToPythonList(tibble("geoId/03")), tibble("geoId/03"))
  expect_identical(ConvertibleToPythonList(tibble(stateDcid = "geoId/03")), tibble(stateDcid = "geoId/03"))
  expect_identical(ConvertibleToPythonList(tibble(stateDcid = c("geoId/03", "geoId/23"))), tibble(stateDcid = c("geoId/03", "geoId/23")))
  expect_identical(ConvertibleToPythonList(tibble(c("geoId/03", "geoId/23"))), tibble(c("geoId/03", "geoId/23")))

  # OK Case 6: data frame: no conversion
  expect_identical(ConvertibleToPythonList(data.frame(stateDcid = "geoId/03")), data.frame(stateDcid = "geoId/03", stringsAsFactors = FALSE))
  expect_identical(ConvertibleToPythonList(data.frame("geoId/03")), data.frame("geoId/03", stringsAsFactors = FALSE))
  expect_identical(ConvertibleToPythonList(data.frame(stateDcid = c("geoId/03", "geoId/23"))), data.frame(stateDcid = c("geoId/03", "geoId/23"), stringsAsFactors = FALSE))
  expect_identical(ConvertibleToPythonList(data.frame(c("geoId/03", "geoId/23"))), data.frame(c("geoId/03", "geoId/23"), stringsAsFactors = FALSE))

  # WARNING Case 1: multi col tibble: take first column
  expect_warning(expect_identical(ConvertibleToPythonList(tibble(stateDcid = "geoId/03", stateBird = "BigBird")), tibble(stateDcid = "geoId/03")))
  expect_warning(expect_identical(ConvertibleToPythonList(tibble(c("geoId/03", "geoId/23"), c("BigBird", "BigBiird"))), tibble(c("geoId/03", "geoId/23"))))

  # WARNING Case 2: multi col data frame: take first column
  expect_warning(expect_identical(ConvertibleToPythonList(data.frame(stateDcid = "geoId/03", stateBird = "BigBird")), data.frame(stateDcid = "geoId/03", stringsAsFactors = FALSE)))
  expect_warning(expect_identical(ConvertibleToPythonList(data.frame(c("geoId/03", "geoId/23"), c("BigBird", "BigBiird"))), data.frame(c("geoId/03", "geoId/23"), stringsAsFactors = FALSE)))

  # BAD Case 1: multiple element unnamed list (only vector for multi elements)
  expect_error(ConvertibleToPythonList(list("0", "1", "0", "0")))
  expect_error(ConvertibleToPythonList(list("same", "mood", "data", "dataR")))
  expect_error(ConvertibleToPythonList(list("do", "or", "do not")))

  # BAD Case 2: named list (no names allowed)
  expect_error(ConvertibleToPythonList(list("0"="lose")))
  expect_error(ConvertibleToPythonList(list("0"="lose", "o"="oh")))
})

