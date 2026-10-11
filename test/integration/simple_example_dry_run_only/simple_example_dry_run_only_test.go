// Copyright 2026 Google LLC
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

package simple_example_dry_run_only_test

import (
	"fmt"
	"testing"
	"time"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
)

var (
	RetryableTransientErrors = map[string]string{
		// Editing VPC Service Controls is eventually consistent.
		".*Error 403.*Request is prohibited by organization's policy.*vpcServiceControlsUniqueIdentifier.*": "Request is prohibited by organization's policy.",
	}
)

// TestSimpleExampleDryRunOnly covers a perimeter staged in dry-run mode with no
// enforced configuration at all.
//
// Every other example populates the enforced side, so this is the only test that
// exercises the path where `status` has nothing to carry. The regression it guards
// against is the module emitting an empty `status {}` regardless: the API does not
// store an empty status, so it never comes back on a read, and the perimeter never
// converges -- `terraform plan` reports a diff immediately after a clean apply, on
// every run.
func TestSimpleExampleDryRunOnly(t *testing.T) {
	bpt := tft.NewTFBlueprintTest(t,
		tft.WithRetryableTerraformErrors(RetryableTransientErrors, 6, 2*time.Minute),
	)

	bpt.DefineVerify(func(assert *assert.Assertions) {
		// DefaultVerify plans after apply and asserts the detailed exit code is
		// neither 1 (error) nor 2 (non-empty diff). This is the assertion that
		// fails without the fix, with exit code 2.
		bpt.DefaultVerify(assert)

		policyID := bpt.GetStringOutput("policy_id")

		servicePerimeterLink := fmt.Sprintf("accessPolicies/%s/servicePerimeters/%s", policyID, bpt.GetStringOutput("service_perimeter_name"))
		servicePerimeter := gcloud.Runf(t, "access-context-manager perimeters describe %s --policy %s", servicePerimeterLink, policyID)

		protectedProjectNumber := bpt.GetStringOutput("protected_project_number")

		assert.True(servicePerimeter.Get("useExplicitDryRunSpec").Bool(), "should use explicit Dry Run spec")

		// Dry-run configuration lives in `spec`.
		resourcesDryRun := servicePerimeter.Get("spec.resources").Array()
		assert.Equal(1, len(resourcesDryRun), "should have only one resource protected in Dry-run")
		assert.Equal(fmt.Sprintf("projects/%s", protectedProjectNumber), resourcesDryRun[0].String(), "project %s should be protected in Dry-run", protectedProjectNumber)

		restrictedServicesDryRun := servicePerimeter.Get("spec.restrictedServices").Array()
		assert.Equal(1, len(restrictedServicesDryRun), "should have only one service protected in Dry-run")
		assert.Equal("storage.googleapis.com", restrictedServicesDryRun[0].String(), "service 'storage.googleapis.com' should be protected in Dry-run")

		// The enforced side was never configured, so the API should report no
		// `status` at all -- not an empty one. This asserts the cause directly,
		// so a failure here distinguishes "the module sent an empty status" from
		// the more general "the plan was not empty" reported above.
		assert.False(servicePerimeter.Get("status").Exists(), "should have no enforced status when only dry-run inputs are supplied")
	})

	bpt.Test()
}
