// Copyright 2025 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package scoped_example_access_level_dry_run_test

import (
	"fmt"
	"testing"
	"time"

	"github.com/tidwall/gjson"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

var (
	RetryableTransientErrors = map[string]string{
		// Editing VPC Service Controls is eventually consistent.
		".*Error 403.*Request is prohibited by organization's policy.*vpcServiceControlsUniqueIdentifier.*": "Request is prohibited by organization's policy.",
	}
)

// getResultFieldStrSlice parses a field of a results list into a string slice
func GetResultFieldStrSlice(rs []gjson.Result, field string) []string {
	s := make([]string, 0)
	for _, r := range rs {
		s = append(s, r.Get(field).String())
	}
	return s
}

func TestScopedExampleAccessLevelDryRun(t *testing.T) {

	setup := tft.NewTFBlueprintTest(t,
		tft.WithTFDir("../../setup"),
	)
	protectedProjectNumber := terraform.OutputMap(t, setup.GetTFOptions(), "protected_project_ids")["number"]

	bpt := tft.NewTFBlueprintTest(t,
		tft.WithRetryableTerraformErrors(RetryableTransientErrors, 6, 2*time.Minute),
	)

	bpt.DefineVerify(func(assert *assert.Assertions) {
		bpt.DefaultVerify(assert)

		policyID := bpt.GetStringOutput("policy_id")
		scopedPolicy := gcloud.Runf(t, "access-context-manager policies describe %s", policyID)
		assert.Equal(fmt.Sprintf("projects/%s", protectedProjectNumber), scopedPolicy.Get("scopes").Array()[0].String(), "scoped project should be %s", protectedProjectNumber)

		servicePerimeterLink := fmt.Sprintf("accessPolicies/%s/servicePerimeters/%s", policyID, bpt.GetStringOutput("service_perimeter_name"))
		servicePerimeter := gcloud.Runf(t, "access-context-manager perimeters describe %s --policy %s", servicePerimeterLink, policyID)

		assert.True(servicePerimeter.Get("useExplicitDryRunSpec").Bool(), "should use explicit Dry Run spec")

		// Access Level
		accessLevelsDryRunName := bpt.GetStringOutput("access_levels_dry_run")
		accessLevelsDryRun := servicePerimeter.Get("spec.accessLevels").Array()
		assert.Equal(1, len(accessLevelsDryRun), "should have only one Access Level in Dry-run")
		assert.Equal(fmt.Sprintf("accessPolicies/%s/accessLevels/%s", policyID, accessLevelsDryRunName), accessLevelsDryRun[0].String(), "project %s should be protected in Dry-run", protectedProjectNumber)

		//Resource
		resourcesDryRun := servicePerimeter.Get("spec.resources").Array()
		assert.Equal(1, len(resourcesDryRun), "should have only one resource protected in Dry-run")
		assert.Equal(fmt.Sprintf("projects/%s", protectedProjectNumber), resourcesDryRun[0].String(), "project %s should be protected in Dry-run", protectedProjectNumber)

		//Restricted Services
		restrictedServicesDryRun := servicePerimeter.Get("spec.restrictedServices").Array()
		assert.Equal(1, len(restrictedServicesDryRun), "should have only one service protected in Dry-run")
		assert.Equal("storage.googleapis.com", restrictedServicesDryRun[0].String(), "service 'storage.googleapis.com' should be protected in Dry-run")
	})
	bpt.Test()
}
