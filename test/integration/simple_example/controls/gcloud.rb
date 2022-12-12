# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

protected_project_id       = attribute('protected_project_id')
dataset_name     = attribute('dataset_name')
table_id         = attribute('table_id')
public_project_id       = attribute('public_project_id')
policy_id = attribute('policy_id')
access_level_name = attribute('access_level_name')
regions_to_allow = [
  'US',
  'CA'
]

control "big_query_vpc_positive_test" do
  describe command("bq query --use_legacy_sql=false --project_id=#{protected_project_id} \'select * from `#{protected_project_id}.#{dataset_name}.example_table` limit 10\'" ) do
    its(:exit_status) { should be 0 }
    its(:stderr) { should eq '' }
    its(:stdout) { should include "Current status: DONE" }
  end
end

control "big_query_vpc_negative_test" do
  describe command("bq query --use_legacy_sql=false --project_id=#{public_project_id} \'select * from `#{protected_project_id}.#{dataset_name}.example_table` limit 10\'" ) do

    # exit_status should be 1 as this is intentionally trigerring an errror by accesing the BigQuery data from outside the perimeter.
    its(:exit_status) { should be 1 }
    its(:stderr) { should eq '' }
    its(:stdout) { should include "Request is prohibited by organization's policy." }
  end
end

control "access_level_regions_test" do
  describe command("gcloud access-context-manager levels describe #{access_level_name} --policy #{policy_id}  --format=json" ) do
    its(:exit_status) { should be 0 }

    let(:data) do
      if subject.exit_status.zero?
        JSON.parse(subject.stdout)
      else
        {}
      end
    end

    describe 'allowed regions' do
      regions_to_allow.each do |region|
        it "#{region} should be allowed" do
          expect(data['basic']['conditions'][0]['regions']).to include(region)
        end
      end
    end

  end
end
