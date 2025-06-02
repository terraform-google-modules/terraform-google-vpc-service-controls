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

package scoped_example_with_egress_rule_test

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

func TestScopedExampleWithEgressRule(t *testing.T) {

	expectedPermissions := []string{
		"bigquery.datasets.get",
		"bigquery.models.getData",
		"bigquery.models.getMetadata",
		"bigquery.models.list",
		"bigquery.tables.get",
		"bigquery.tables.getData",
		"bigquery.tables.list",
	}

	expectedMethods := []string{
		"google.storage.objects.get",
		"google.storage.objects.list",
	}

	setup := tft.NewTFBlueprintTest(t,
		tft.WithTFDir("../../setup"),
	)
	protectedProjectNumber := terraform.OutputMap(t, setup.GetTFOptions(), "protected_project_ids")["number"]
	publicProjectNumber := terraform.OutputMap(t, setup.GetTFOptions(), "public_project_ids")["number"]

	bpt := tft.NewTFBlueprintTest(t,
		tft.WithRetryableTerraformErrors(RetryableTransientErrors, 3, 1*time.Minute),
	)

	bpt.DefineVerify(func(assert *assert.Assertions) {
		bpt.DefaultVerify(assert)

		policyID := bpt.GetStringOutput("policy_id")
        scopedPolicy := gcloud.Runf(t, "access-context-manager policies describe %s", policyID)
		assert.Equal(fmt.Sprintf("projects/%s", protectedProjectNumber), scopedPolicy.Get("scopes").Array()[0].String(), "scoped project should be %s", protectedProjectNumber)

		servicePerimeterLink := fmt.Sprintf("accessPolicies/%s/servicePerimeters/%s", policyID, bpt.GetStringOutput("service_perimeter_name"))
		servicePerimeter := gcloud.Runf(t, "access-context-manager perimeters describe %s --policy %s", servicePerimeterLink, policyID)

		egressPolicies := servicePerimeter.Get("status.egressPolicies").Array()
		for _, rule := range egressPolicies {

			from := rule.Get("egressFrom")
			assert.Equal("ANY_SERVICE_ACCOUNT", from.Get("identityType").String(), "identityType should be ANY_SERVICE_ACCOUNT")
			assert.Equal("SOURCE_RESTRICTION_ENABLED", from.Get("sourceRestriction").String(), "source restriction should be enabled")
			assert.Equal(fmt.Sprintf("projects/%s", protectedProjectNumber), from.Get("sources").Array()[0].Get("resource").String(), "source project should be %s", protectedProjectNumber)

			to := rule.Get("egressTo")
			resource := to.Get("resources").Array()[0]
			assert.Equal(fmt.Sprintf("projects/%s", publicProjectNumber), resource.String(), "to public project should be %s", publicProjectNumber)
			operation := to.Get("operations").Array()[0]
			if operation.Get("serviceName").String() == "storage.googleapis.com" {
				methods := GetResultFieldStrSlice(operation.Get("methodSelectors").Array(), "method")
				for _, expected := range expectedMethods {
					assert.Contains(methods, expected)
				}
				assert.Equal("Use permissions for Big Query access", rule.Get("title").String(), "check title")
			}

			if operation.Get("serviceName").String() == "bigquery.googleapis.com" {
				permissions := GetResultFieldStrSlice(operation.Get("methodSelectors").Array(), "permission")
				for _, expected := range expectedPermissions {
					assert.Contains(permissions, expected)
				}
				assert.Equal("Read outside buckets from project", rule.Get("title").String(), "check title")
			}
		}
	})
	bpt.Test()
}
