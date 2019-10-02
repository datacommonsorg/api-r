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

# Data Commons Node API - Places Convenience Function
#
# get_places_in
#
# These functions provide R access to
#   Data Commons Node API Places convenience functions.
#   These functions are designed to making adding a new column
#   to a data frame convenient!
#   www.DataCommons.org

#' Return places of a specified type contained in specified places
#'
#' Returns a mapping between the specified places
#'   and the places of a specified type contained in them.
#'
#' Assigning output to a tibble/data frame will yield a list of contained
#' places. To convert this to 1-to-1 mapping (the containing place will
#' be repeated), use \code{tidyr::unnest}.
#'
#' @param dcids required, dcid(s) identifying a containing place.
#'   This parameter will accept a vector of strings
#'   or a single-column tibble/data frame of strings.
#'   To select a single column, use \code{select(df, col)}.
#' @param place_type required, string identifying the place type to filter results
#'   by.
#' @return If dcids input is vector of strings, will return a named
#'   list mapping each dcid to places contained in it of the given place_type.
#'
#'   If \code{dcids} input is tibble/data frame, will return a new
#'   single-column tibble/data frame where the i-th entry of the output
#'   corresponds to places contained in the place identified by the dcid in
#'   i-th cell of the \code{dcids} input. The cells of output column will
#'   always contain a vector of place dcids of the given place_type.
#' @export
#' @examples
#' # Atomic vector of the dcids of Santa Clara and Montgomery County.
#' countyDcids <- c('geoId/06085', 'geoId/24031')
#' # Get towns in Santa Clara and Montgomery County.
#' towns <- get_places_in(countyDcids, 'Town')
#'
#' # Tibble of the dcids of Santa Clara and Montgomery County.
#' df <- tibble(countyDcid = c('geoId/06085', 'geoId/24031'))
#' # Get towns in Santa Clara and Montgomery County.
#' df$townDcid <- get_places_in(df, 'Town')
#' # Since get_places_in returned a mapping between counties and
#' # a list of towns, use you can use tidyr::unnest to create
#' # a 1-1 mapping between each county and its towns.
get_places_in <- function(dcids, place_type) {
  dcids = convertible_to_python(dcids)
  return(call_python(dc$get_places_in, list(dcids, place_type)))
}
