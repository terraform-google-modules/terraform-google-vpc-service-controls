provider "google-beta" {
  version     = "~> 2.3"
  credentials = "${file("./credentials.json")}"
}

module "org-policy" {
  source      = "../.."
  parent_id   = "${var.parent_id}"
  policy_name = "${var.policy_name}"
}

module "bridge-service-perimeter-1" {
  source         = "../../modules/bridge_service_perimeter"
  policy         = "${module.org-policy.policy_id}"
  perimeter_name = "bridge_perimeter_1"
  description    = "Some description"

  resources = [
    "${module.regular-service-perimeter-1.shared_resources["all"]}",
    "${module.regular-service-perimeter-2.shared_resources["all"]}",
  ]
}

module "regular-service-perimeter-1" {
  source         = "../../modules/regular_service_perimeter"
  policy         = "${module.org-policy.policy_id}"
  perimeter_name = "regular_perimeter_1"
  description    = "Some description"
  resources      = ["${var.protected_project_ids["number"]}"]

  restricted_services = ["bigquery.googleapis.com", "storage.googleapis.com"]

  shared_resources = {
    all = ["${var.protected_project_ids["number"]}"]
  }
}

module "regular-service-perimeter-2" {
  source         = "../../modules/regular_service_perimeter"
  policy         = "${module.org-policy.policy_id}"
  perimeter_name = "regular_perimeter_2"
  description    = "Some description"
  resources      = ["${var.public_project_ids["number"]}"]

  restricted_services = ["storage.googleapis.com"]

  shared_resources = {
    all = ["${var.public_project_ids["number"]}"]
  }
}
