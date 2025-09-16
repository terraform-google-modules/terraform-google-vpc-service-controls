# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this
project adheres to [Semantic Versioning](http://semver.org/).

## [7.2.0](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/compare/v7.1.3...v7.2.0) (2025-09-16)


### Features

* **deps:** Update Terraform google to v7 ([#216](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/issues/216)) ([14f11e6](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/commit/14f11e6b5e4c1c28beb752c469da4c21eb67ee90))

## [7.1.3](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/compare/v7.1.2...v7.1.3) (2025-08-07)


### Bug Fixes

* Add depends_on in ingress policies resources ([#213](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/issues/213)) ([afa2f87](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/commit/afa2f8790c20c03a66017c0fcaaeded740d036b9))

## [7.1.2](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/compare/v7.1.1...v7.1.2) (2025-07-22)


### Bug Fixes

* Directional rules after apply ([#210](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/issues/210)) ([a40c3c0](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/commit/a40c3c0dfa307030662f39d1efeb59752cc0d062))

## [7.1.1](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/compare/v7.1.0...v7.1.1) (2025-06-11)


### Bug Fixes

* use dry run resource to add resources to the perimeter ([#204](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/issues/204)) ([afa9c35](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/commit/afa9c35daa3dd468017e486cc1e03e90d1c8352f))

## [7.1.0](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/compare/v7.0.0...v7.1.0) (2025-06-03)


### Features

* Add scopes, update directional rules variable definition and dry-run lifecycle `ignore_changes` ([#199](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/issues/199)) ([8b14973](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/commit/8b14973fd700a4237944b25eedb1e2d0c292e3c3))

## [7.0.0](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/compare/v6.2.1...v7.0.0) (2025-05-14)


### ⚠ BREAKING CHANGES

* support for externally managed egress/ingress policies ([#193](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/issues/193))
* **deps:** bump Terraform v1.3+ ([#177](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/issues/177))

### Features

* support for externally managed egress/ingress policies ([#193](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/issues/193)) ([029cd98](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/commit/029cd986d3c3ec2d50dff7921244cc5c8763c1c9))


### Bug Fixes

* **deps:** bump Terraform v1.3+ ([#177](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/issues/177)) ([bc114b8](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/commit/bc114b87258883f023737a7bad79c039d5845d32))

## [6.2.1](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/compare/v6.2.0...v6.2.1) (2025-01-29)


### Bug Fixes

* fail gracefully if ingress.to.operations index does not exist ([#176](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/issues/176)) ([6cc00f9](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/commit/6cc00f955da77b88e1e666588274721c145c58a7))
* fail gracefully if sources index does not exist ([#174](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/issues/174)) ([a39c859](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/commit/a39c859d79746464a475ca2f99a4f6386b78259f))

## [6.2.0](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/compare/v6.1.0...v6.2.0) (2024-10-08)


### Features

* Support external_resources for egress policies ([#162](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/issues/162)) ([4bc0673](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/commit/4bc0673294abb72682e70743f2704df3a153bf18))

## [6.1.0](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/compare/v6.0.0...v6.1.0) (2024-10-07)


### Features

* **deps:** Update Terraform google to v6 ([#160](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/issues/160)) ([ba5b331](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/commit/ba5b331b5492399b1292ccdc450caea43216de78))


### Bug Fixes

* **variables:** fail gracefully if `sources` index does not exist ([#146](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/issues/146)) ([49973a3](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/commit/49973a3c4e2f9e57cf54b25aa83f4680980daca5))

## [6.0.0](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/compare/v5.2.1...v6.0.0) (2024-04-11)


### ⚠ BREAKING CHANGES

* **TPG>=5.4:** add vpc_network_sources in access level ([#133](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/issues/133))
* **TPG >= 4.68:** added missing features for egress policies ([#131](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/issues/131))

### Features

* **TPG>=5.4:** add vpc_network_sources in access level ([#133](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/issues/133)) ([de58006](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/commit/de58006f7f9913568b2c6bede71f02b696d515e9))


### Bug Fixes

* **TPG >= 4.68:** added missing features for egress policies ([#131](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/issues/131)) ([c6df326](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/commit/c6df32651832ea4c9f82e432c8119216a027f1b0))

## [5.2.1](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/compare/v5.2.0...v5.2.1) (2023-10-20)


### Bug Fixes

* upgraded versions.tf to include minor bumps from tpg v5 ([#123](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/issues/123)) ([bf84660](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/commit/bf84660f7ca4ed231949ec652adb5e43708f89c0))

## [5.2.0](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/compare/v5.1.0...v5.2.0) (2023-07-26)


### Features

* Support for VPCs in dry-run mode ([#117](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/issues/117)) ([38eb822](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/commit/38eb8221543a368c8a84ddb42ad5729517c5040a))

## [5.1.0](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/compare/v5.0.0...v5.1.0) (2023-06-22)


### Features

* added VPC network support to perimeter resources ([#106](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/issues/106)) ([645f42e](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/commit/645f42e50ff5026d4f03de0dc116dc28666ba032))

## [5.0.0](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/compare/v4.0.1...v5.0.0) (2022-12-29)


### ⚠ BREAKING CHANGES

* update TPG version 3.62 and address tflint/CI ([#90](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/issues/90))

### Bug Fixes

* update TPG version 3.62 and address tflint/CI ([#90](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/issues/90)) ([b33c20d](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/commit/b33c20db9f233a2b1de7781550aa95e33f7ec31a))

### [4.0.1](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/compare/v4.0.0...v4.0.1) (2022-03-17)


### Bug Fixes

* Added VPC Accessible Services configuration ([#84](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/issues/84)) ([ccc56a8](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/commit/ccc56a80995b8c0e8aa63a05dcb6b6d448a715d3))
* dry-run egress ingress operations ([#83](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/issues/83)) ([dfd0252](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/commit/dfd02529f48c5f763ce6fc71ada920c2ca0ac8d5))

## [4.0.0](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/compare/v3.2.0...v4.0.0) (2022-03-04)


### ⚠ BREAKING CHANGES

* add Terraform 0.13 constraint and module attribution (#45)
* Minimum provider version increased to 3.17
* Resources have been split out from the perimeter. See the [upgrade guide](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/blob/master/docs/upgrading_to_v4.0.md) for details.

### Features

* add regions and require_corp_owned to access level module ([#40](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/issues/40)) ([20d4ce5](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/commit/20d4ce5e062f8716c241d32109e5a614269cbe85))
* add Terraform 0.13 constraint and module attribution ([#45](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/issues/45)) ([9fab6ed](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/commit/9fab6ed2a394d6aa9d00ff510aa097816175cf22))
* Added Ingress and Egress Rules support to regular perimeters ([#55](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/issues/55)) ([f837a23](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/commit/f837a23b58065c53327a2de3236e70e57e7386e9))
* Added support for dry-run policies in VPC Service Controls ([#37](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/issues/37)) ([0e712f0](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/commit/0e712f068b000221bcdc617292e1ef98e4fb9b6c))
* Pass description attribute through in regular_service_perimeter module ([#34](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/issues/34)) ([d5ff0e3](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/commit/d5ff0e396c4f5eff197a59aafb6f3f31060fc65b))
* split resources into separate resource to allow out-of-module additions ([#61](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/issues/61)) ([03e86e3](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/commit/03e86e330cc7261608cfe48b0212b421fc6a83ec))
* update TPG version constraints to allow 4.0 ([#65](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/issues/65)) ([8f7a51c](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/commit/8f7a51cf9bd4cb4d395aca0a750d805da387c650))


### Bug Fixes

* Add perimeter info to regular perimeter outputs ([#51](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/issues/51)) ([1787b21](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/commit/1787b217a92b68cc80d057288ecb6e36dd362d63))
* add resource_keys variable to handle dynamic resources ([#81](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/issues/81)) ([9110314](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/commit/9110314179adff5510f03f73a7010fa32f5b36bc))
* Change default value for os_type to OS_UNSPECIFIED ([#30](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/issues/30)) ([20da2e0](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/commit/20da2e06f375ddcaf47a34a40c967c4644c6ade7))
* ignore excessive changes to bridge status ([#74](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/issues/74)) ([09cb2dc](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/commit/09cb2dcaeb3e3b5465404357847b41289a2ec501))
* Use dynamic block to prevent empty device policies ([#31](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/issues/31)) ([17a9329](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/commit/17a9329bd8dad4f201d759a043f82e52de8dce41))

## [3.2.0](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/compare/v3.1.0...v3.2.0) (2022-01-11)


### Features

* split resources into separate resource to allow out-of-module additions ([#61](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/issues/61)) ([03e86e3](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/commit/03e86e330cc7261608cfe48b0212b421fc6a83ec))
* update TPG version constraints to allow 4.0 ([#65](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/issues/65)) ([8f7a51c](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/commit/8f7a51cf9bd4cb4d395aca0a750d805da387c650))

## [3.1.0](https://www.github.com/terraform-google-modules/terraform-google-vpc-service-controls/compare/v3.0.1...v3.1.0) (2021-10-07)


### Features

* Added Ingress and Egress Rules support to regular perimeters ([#55](https://www.github.com/terraform-google-modules/terraform-google-vpc-service-controls/issues/55)) ([f837a23](https://www.github.com/terraform-google-modules/terraform-google-vpc-service-controls/commit/f837a23b58065c53327a2de3236e70e57e7386e9))

### [3.0.1](https://www.github.com/terraform-google-modules/terraform-google-vpc-service-controls/compare/v3.0.0...v3.0.1) (2021-05-19)


### Bug Fixes

* Add perimeter info to regular perimeter outputs ([#51](https://www.github.com/terraform-google-modules/terraform-google-vpc-service-controls/issues/51)) ([1787b21](https://www.github.com/terraform-google-modules/terraform-google-vpc-service-controls/commit/1787b217a92b68cc80d057288ecb6e36dd362d63))

## [3.0.0](https://www.github.com/terraform-google-modules/terraform-google-vpc-service-controls/compare/v2.1.0...v3.0.0) (2021-04-08)


### ⚠ BREAKING CHANGES

* add Terraform 0.13 constraint and module attribution (#45)

### Features

* add Terraform 0.13 constraint and module attribution ([#45](https://www.github.com/terraform-google-modules/terraform-google-vpc-service-controls/issues/45)) ([9fab6ed](https://www.github.com/terraform-google-modules/terraform-google-vpc-service-controls/commit/9fab6ed2a394d6aa9d00ff510aa097816175cf22))

## [2.1.0](https://www.github.com/terraform-google-modules/terraform-google-vpc-service-controls/compare/v2.0.0...v2.1.0) (2021-01-20)


### Features

* add regions and require_corp_owned to access level module ([#40](https://www.github.com/terraform-google-modules/terraform-google-vpc-service-controls/issues/40)) ([20d4ce5](https://www.github.com/terraform-google-modules/terraform-google-vpc-service-controls/commit/20d4ce5e062f8716c241d32109e5a614269cbe85))

## [2.0.0](https://www.github.com/terraform-google-modules/terraform-google-vpc-service-controls/compare/v1.1.0...v2.0.0) (2020-06-01)


### ⚠ BREAKING CHANGES

* Minimum provider version increased to 3.17

### Features

* Added support for dry-run policies in VPC Service Controls ([#37](https://www.github.com/terraform-google-modules/terraform-google-vpc-service-controls/issues/37)) ([0e712f0](https://www.github.com/terraform-google-modules/terraform-google-vpc-service-controls/commit/0e712f068b000221bcdc617292e1ef98e4fb9b6c))

## [1.1.0](https://www.github.com/terraform-google-modules/terraform-google-vpc-service-controls/compare/v1.0.3...v1.1.0) (2020-04-07)


### Features

* Pass description attribute through in regular_service_perimeter module ([#34](https://www.github.com/terraform-google-modules/terraform-google-vpc-service-controls/issues/34)) ([d5ff0e3](https://www.github.com/terraform-google-modules/terraform-google-vpc-service-controls/commit/d5ff0e396c4f5eff197a59aafb6f3f31060fc65b))

### [1.0.3](https://www.github.com/terraform-google-modules/terraform-google-vpc-service-controls/compare/v1.0.2...v1.0.3) (2020-04-06)


### Bug Fixes

* Change default value for os_type to OS_UNSPECIFIED ([#30](https://www.github.com/terraform-google-modules/terraform-google-vpc-service-controls/issues/30)) ([20da2e0](https://www.github.com/terraform-google-modules/terraform-google-vpc-service-controls/commit/20da2e06f375ddcaf47a34a40c967c4644c6ade7))
* Use dynamic block to prevent empty device policies ([#31](https://www.github.com/terraform-google-modules/terraform-google-vpc-service-controls/issues/31)) ([17a9329](https://www.github.com/terraform-google-modules/terraform-google-vpc-service-controls/commit/17a9329bd8dad4f201d759a043f82e52de8dce41))

## [Unreleased]

## [1.0.2] - 2019-12-10

### Fixed

- Fixed issue with the dependency graph for the `shared_resources` output. [#25]

## [1.0.1] - 2019-09-19

### Fixed
- Fixed issues with the dependency graph for access level outputs. [#18]

## [1.0.0] - 2019-09-04

### Changed
 - Supported version of Terraform is 0.12. [#10]

## [0.1.0] - 2019-05-15

### Added

* Initial release of module.

[Unreleased]: https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/compare/v1.0.2...HEAD
[1.0.2]: https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/releases/compare/v1.0.1...v1.0.2
[1.0.1]: https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/releases/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/releases/compare/v0.1.0...v1.0.0
[0.1.0]: https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/releases/tag/v0.1.0

[#25]: https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/issues/25
[#18]: https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/pull/18
[#10]: https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/pull/10
