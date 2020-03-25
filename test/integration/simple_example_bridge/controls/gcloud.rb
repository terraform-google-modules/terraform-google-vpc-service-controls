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

policy_name = attribute('policy_name')
org_id      = attribute('parent_id')

control "bridge_policy_test" do
  title "Access policy test"
  describe command("gcloud access-context-manager policies list --organization=#{org_id} --format=json" ) do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq '' }
    let!(:data) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout)
      else
        {}
      end
    end
    describe "policy" do
      it "has correct title" do
        expect(data[0]["title"]).to eq policy_name
      end
    end
  end
end