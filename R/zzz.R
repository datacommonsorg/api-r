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

# zzz.R
# File for setup

# global reference to Python Client(will be initialized in .onLoad)
dc <- NULL

.onLoad <- function(libname, pkgname) {
  # use superassignment to update global reference to dc
  # setting delay_load delays loading the module until it is first used
  # thus, user can first set python version in R after loading in this
  # R API Client package
  system("pip install --upgrade --user --quiet git+https://github.com/datacommonsorg/api-python.git")
  dc <<- reticulate::import("datacommons", delay_load = FALSE)
}
