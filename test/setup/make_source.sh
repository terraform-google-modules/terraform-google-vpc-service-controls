#!/usr/bin/env bash

# Copyright 2018 Google LLC
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

echo "#!/usr/bin/env bash" > ../source.sh

project_id=$(terraform output project_id)
echo "export TF_VAR_project_id='$project_id'" >> ../source.sh

sa_json=$(terraform output sa_key)
# shellcheck disable=SC2086
echo "export SERVICE_ACCOUNT_JSON='$(echo $sa_json | base64 --decode)'" >> ../source.sh

parent_id=$(terraform output parent_id)
echo "export TF_VAR_parent_id='$parent_id'" >> ../source.sh
echo "export TF_VAR_org_id='$parent_id'" >> ../source.sh

protected_project_ids=$(terraform output protected_project_ids)
echo "export TF_VAR_protected_project_ids='$protected_project_ids'" >> ../source.sh

public_project_ids=$(terraform output public_project_ids)
echo "export TF_VAR_public_project_ids='$public_project_ids'" >> ../source.sh

members=$(terraform output members)
echo "export TF_VAR_members='$members'" >> ../source.sh
