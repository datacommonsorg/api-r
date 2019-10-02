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

# Set the default limit value
MAX_LIMIT = 100

#' Set your API Key
#'
#' Using the Data Commons API requires you to provision an API key on
#' GCP. See
#' \url{https://datacommons.readthedocs.io/en/latest/started.html#creating-an-api-key}
#'
#' @param key (string) your API Key.
#' @export
#' @examples
#' # Say you got an API Key: 12345678, in the R console:
#' set_api_key("12345678")
set_api_key = function(key) {
  # Set API key for Python dependency
  dc$set_api_key(key)
  # Set API key in R environment for query func
  # Temporary, once we re-wite R to use Python's query func, no longer needed
  Sys.setenv(API_KEY = key)
}

# Helper function to ensure that R dcids input will be converted to
# list or series for python dcids input
# https://rstudio.github.io/reticulate/articles/calling_python.html#type-conversions
convertible_to_python = function(input) {
  if (is.null(input) || length(input) < 1) {
    stop("input cannot be empty")
  }

  if (is.data.frame(input)) {
    # cast factors to string and coerce data frame to tibble
    input[] <- lapply(input, as.character)
    # input = tibble(input)

    if (dim(input)[[2]] > 1) {
      warning("input data frame should only contain one column;
              this time, we will take the first column")
    }
    return(input[1])
  }

  if (is.list(input)) {
    if (length(input) != 1) {
      stop("please use atomic vector if more than 1 element")
    }
    if (!is.null(names(input))) {
      stop("please use unnamed lists")
    }
    return(input)
  }

  if (!is.vector(input) || !is.atomic(input) || !(typeof(input) == "character")) {
    stop("input must be string, vector of strings, or list of 1 string")
  }

  # cast single string to list, else Reticulate will not convert to py list
  if (length(input) == 1) {
    return(list(input))
  }

  return(input)
}

# Helper function to call Python and convert error messages
call_python <- function(func, args) {
  tryCatch(
    expr = {
      return(do.call(func, args))
    },
    error = function(err) {
      message(paste("Error calling Python function: ", func))
      if (str_detect(conditionMessage(err),
                     'HTTP 401')) {
        # Rewrite the error message to refer to R wrapper funtion
        err$message <- "Response error: An HTTP 401 code: API key not set.
          See the set_api_key help docs for instructions on obtaining and setting
          an API key, then try again."
      } else if (str_detect(conditionMessage(err),
                            'HTTP 400')) {
        # Rewrite the error message to refer to R wrapper funtion
        err$message <- "Response error: An HTTP 400 code: API key not valid.
          Please pass a valid API key. See the set_api_key help docs for
          instructions on obtaining and setting an API key, then try again."
      }
      stop(err, call. = FALSE)
    }
  )
}

# testthat helper function to skip tests if no 'datacommons' python module
# helpful for CRAN machines that might not have datacommons
skip_if_no_dcpy <- function() {
  have_dcpy <- py_module_available("datacommons")
  print(py_config())
  if (!have_dcpy)
    skip("python client not available for testing")
}
