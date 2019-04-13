provider "google-beta" {
  version = "~> 2.3"
  #region  = "${var.region}"
  credentials = "${file("./credentials.json")}"
}

module "org-policy" {
  source      = "../../modules/policy"
  parent_id   = "${var.parent_id}"
  policy_name = "${var.policy_name}"
}

module "regular-service-perimeter-1" {
  source         = "../../modules/regular_service_perimeter"
  policy         = "${module.org-policy.policy_id}"
  perimeter_name = "regular_perimeter_1"
  description    = "Some description"
  resources      = ["743286545054"]

  restricted_services = ["bigquery.googleapis.com", "storage.googleapis.com"]
  #access_levels = ["${module.access-level-device-lock.link}”, "${module.access_level_2.link}”]
  shared_resources = {
    all     = ["743286545054"]
  }
}

module "regular-service-perimeter-2" {
  source         = "../../modules/regular_service_perimeter"
  policy         = "${module.org-policy.policy_id}"
  perimeter_name = "regular_perimeter_2"
  description    = "Some description"
  resources      = ["743286545054"]

  restricted_services = ["bigquery.googleapis.com", "storage.googleapis.com"]
  #access_levels = ["${module.access-level-device-lock.link}”, "${module.access_level_2.link}”]
  shared_resources = {
    all     = ["743286545054"]
  }
}

module "bridge-service-perimeter-1" {
    source = "../../modules/bridge_service_perimeter"
    policy         = "${module.org-policy.policy_id}"
    perimeter_name = "bridge_perimeter_1"
    description    = "Some description"
    resources      = ["${module.regular-service-perimeter-1.shared_resources["all"]}", 
    "${module.regular-service-perimeter-2.shared_resources["all"]}"]
}
