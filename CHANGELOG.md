# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this
project adheres to [Semantic Versioning](http://semver.org/).

### [3.2.1](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/compare/v3.2.0...v3.2.1) (2022-01-13)


### Bug Fixes

* ignore excessive changes to bridge status ([#74](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/issues/74)) ([09cb2dc](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls/commit/09cb2dcaeb3e3b5465404357847b41289a2ec501))

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
