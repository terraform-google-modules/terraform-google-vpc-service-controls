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

package scoped_example_with_ingress_rule_test

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
		".*Error 403.*Request is prohibited by organization's policy.*vpcServiceControlsUniqueIdentifier.*":                                                  "Request is prohibited by organization's policy.",
		".*Error 400.*Invalid Directional Policies set in Perimeter.*Only resources protected by this Service Perimeter can be put in IngressTo.resources.*": "Only resources protected by this Service Perimeter can be put in IngressTo.resources.",
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

func TestScopedExampleWithIngressRule(t *testing.T) {

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
		tft.WithRetryableTerraformErrors(RetryableTransientErrors, 6, 2*time.Minute),
	)

	bpt.DefineVerify(func(assert *assert.Assertions) {
		bpt.DefaultVerify(assert)

		policyID := bpt.GetStringOutput("policy_id")
		scopedPolicy := gcloud.Runf(t, "access-context-manager policies describe %s", policyID)
		assert.Equal(fmt.Sprintf("projects/%s", protectedProjectNumber), scopedPolicy.Get("scopes").Array()[0].String(), "scoped project should be %s", protectedProjectNumber)

		servicePerimeterLink := fmt.Sprintf("accessPolicies/%s/servicePerimeters/%s", policyID, bpt.GetStringOutput("service_perimeter_name"))
		servicePerimeter := gcloud.Runf(t, "access-context-manager perimeters describe %s --policy %s", servicePerimeterLink, policyID)

		ingressPoliciesDryRun := servicePerimeter.Get("spec.ingressPolicies").Array()
		for _, ruleDryRun := range ingressPoliciesDryRun {

			from := ruleDryRun.Get("ingressFrom")
			assert.NotEmpty(from.Get("identities").Array())
			assert.Equal(fmt.Sprintf("accessPolicies/%s/accessLevels/terraform_members_dry_run", policyID), from.Get("sources").Array()[0].Get("accessLevel").String(), "accessLevel should be 'terraform_members_dry_run'")

			to := ruleDryRun.Get("ingressTo")
			operation := to.Get("operations").Array()[0]
			assert.Equal("storage.googleapis.com", operation.Get("serviceName").String(), "service should be storage.googleapis.com")
			methods := GetResultFieldStrSlice(operation.Get("methodSelectors").Array(), "method")
			for _, expected := range expectedMethods {
				assert.Contains(methods, expected)
			}
			resource := to.Get("resources").Array()[0]
			assert.Equal("*", resource.String(), "should be all projects *")
		}

		ingressPolicies := servicePerimeter.Get("status.ingressPolicies").Array()
		for _, rule := range ingressPolicies {

			from := rule.Get("ingressFrom")
			// Cases
			if rule.Get("title").String() == "Allow Access from everywhere" {
				assert.Equal("*", from.Get("sources").Array()[0].Get("accessLevel").String(), "accessLevel should be '*'")
			}
			if rule.Get("title").String() == "from bucket read identity" {
				assert.NotEmpty(from.Get("identities").Array())
				assert.Equal(fmt.Sprintf("projects/%s", publicProjectNumber), from.Get("sources").Array()[0].Get("resource").String(), "source project should be %s", publicProjectNumber)
			}
			if rule.Get("title").String() == "Allow Access from project" {
				assert.Equal("ANY_SERVICE_ACCOUNT", from.Get("identityType").String(), "identityType should be ANY_SERVICE_ACCOUNT")
				assert.Equal(fmt.Sprintf("projects/%s", publicProjectNumber), from.Get("sources").Array()[0].Get("resource").String(), "source project should be %s", publicProjectNumber)
			}

			to := rule.Get("ingressTo")
			operation := to.Get("operations").Array()[0]
			assert.Equal("storage.googleapis.com", operation.Get("serviceName").String(), "service should be storage.googleapis.com")
			methods := GetResultFieldStrSlice(operation.Get("methodSelectors").Array(), "method")
			for _, expected := range expectedMethods {
				assert.Contains(methods, expected)
			}
			//cases
			resource := to.Get("resources").Array()[0]
			if rule.Get("title").String() == "Allow Access from everywhere" {
				assert.Equal("*", resource.String(), "should be all projects '*'")
			}
			if rule.Get("title").String() == "from bucket read identity" {
				assert.Equal(fmt.Sprintf("projects/%s", protectedProjectNumber), resource.String(), "to protected project should be %s", protectedProjectNumber)
			}
			if rule.Get("title").String() == "Allow Access from project" {
				assert.Equal("*", resource.String(), "should be all projects *")
			}
		}
	})
	bpt.Test()
}
