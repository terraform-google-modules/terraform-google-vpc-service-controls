# Copyright 2019 Google LLC
# 
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
# 
#        http://www.apache.org/licenses/LICENSE-2.0
# 
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
# 
SHELL := /usr/bin/env bash

#.PHONY: plan_projects
plan_projects:
	pushd projects && \
		terraform init && \
		terraform plan && \
		popd

#.PHONY: plan
plan:
	source env.sh && \
		terraform init && \
		terraform plan -var-file terraform.tfvars

#.PHONY apply_projects
apply_projects:
	pushd projects && \
		terraform apply && \
		./make_env.sh && \
		popd

#.PHONY: apply
apply:
	source env.sh && terraform apply -var-file terraform.tfvars
