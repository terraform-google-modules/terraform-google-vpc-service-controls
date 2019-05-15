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


protected_project_id       = attribute('protected_project_id')
dataset_id       = attribute('dataset_id')
table_id         = attribute('table_id')
public_project_id       = attribute('public_project_id')

control "big_query_vpc_positive_test" do
  describe command("bq query --use_legacy=false --project_id=#{protected_project_id} \'select * from `#{protected_project_id}.sample_dataset.example_table` limit 10\'" ) do
    its(:exit_status) { should be 0 }

    its(:stderr) { should include "Current status: DONE" }
  end
end

control "big_query_vpc_negative_test" do
  describe command("bq query --use_legacy=false --project_id=#{public_project_id} \'select * from `#{protected_project_id}.sample_dataset.example_table` limit 10\'" ) do

    # exit_status should be 1 as this is intentionally trigerring an errror by accesing the BigQuery data from outside the perimeter.
    its(:exit_status) { should be 1 }
    its(:stderr) { should eq '' }
    its(:stdout) { should include "Request is prohibited by organization's policy." }
  end
end
