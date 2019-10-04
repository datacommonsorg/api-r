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


# Data Commons Query API
#
# query
#
# This function provides R access to
#   Data Commons Query API function.
#   www.DataCommons.org

#' Query Data Commons Using SPARQL
#'
#' This function allows you to build R dataframes using data from
#' the Data Commons Open Knowledge Graph via SPARQL queries to
#' the Data Commons Query API.
#'
#' @param query_string required, SPARQL query string.
#' @return A populated data frame with columns specified by the SPARQL query.
#' @export
#' @examples
#' query_string = "SELECT ?pop ?Unemployment
#'     WHERE {
#'       ?pop typeOf StatisticalPopulation .
#'       ?o typeOf Observation .
#'       ?pop dcid (\"dc/p/qep2q2lcc3rcc\" \"dc/p/gmw3cn8tmsnth\" \"dc/p/92cxc027krdcd\") .
#'       ?o observedNode ?pop .
#'       ?o measuredValue ?Unemployment
#'     }"
#' df = query(query_string)
query <- function(query_string) {
  # Encode the query to REST URL
  urlEncodedQuery <- URLencode(query_string, reserved = TRUE)
  reqUrl <- paste0("http://api.datacommons.org/query?sparql=",
                   URLencode(urlEncodedQuery), "&key=", Sys.getenv("DC_API_KEY"))
  resp <- GET(reqUrl)
  if (http_type(resp) != "application/json") {
    stop("API did not return json", call. = FALSE)
  }

  # Parse response
  parsedResp <- fromJSON(content(resp, "text"),
                                   simplifyVector = FALSE)
  if (http_error(resp)) {
    if (status_code(resp) == 401) {
      parsedResp$message <- "API key not set. See the set_api_key help docs for
        instructions on obtaining and setting an API key, then try again."
    }
    if (status_code(resp) == 400) {
      parsedResp$message <- "API key not valid. Please pass a valid API key. See the set_api_key
        help docs for instructions on obtaining and setting an API key, then try again."
    }
    stop(
      sprintf(
        "Data Commons API request failed. Response error: An HTTP %s code.\n%s",
        status_code(resp),
        parsedResp$message
      ),
      call. = FALSE
    )
  }

  # Prettify the response into typical JSON
  columns <- parsedResp[1]$header
  numCols <- length(columns)
  numRows <- length(parsedResp[2]$rows)
  if (numRows < 1) {
    stop("No rows in response.", call. = FALSE)
  }
  if (numCols < 1) {
    stop("No cols in response.", call. = FALSE)
  }
  objList <- vector("list", numRows)
  for (obj in 1:numRows) {
    rowKVs = parsedResp[2]$rows[[obj]]$cells

    KVList = vector("list", numCols)
    for (attr in 1:numCols) {
      KVList[[attr]] = paste0("\"", columns[attr], "\"", ":", "\"",
                              rowKVs[attr][[1]]$value, "\"")
    }
    KVText = paste(KVList, collapse=",")
    # Write JSON object
    objList[[obj]] = paste0("{", KVText, "}")
  }
  objTexts <- paste(objList, collapse = ",")
  prettyJsonResp <- paste0("[", objTexts, "]")

  # Return an R dataframe
  df <- fromJSON(prettyJsonResp)
  return(df)
}
