#!/bin/bash
# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

echo "#!/usr/bin/env bash" > ../env.sh

project1_id=$(terraform output project1_id)
echo "export TF_VAR_project1_id='$project1_id'" > ../env.sh

project2_id=$(terraform output project2_id)
echo "export TF_VAR_project2_id='$project2_id'" >> ../env.sh
