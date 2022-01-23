# Terraform Provider: Snowflake

**Please note**: If you believe you have found a security issue, _please responsibly disclose_ by contacting us at [security@chanzuckerberg.com](mailto:security@chanzuckerberg.com).

----

![.github/workflows/ci.yml](https://github.com/chanzuckerberg/terraform-provider-snowflake/workflows/.github/workflows/ci.yml/badge.svg)

This is a terraform provider plugin for managing [Snowflake](https://www.snowflake.com/) accounts.

## Getting Help

If you need help, try the [discussions area](https://github.com/chanzuckerberg/terraform-provider-snowflake/discussions) of this repo.

## Install

The easiest way is to run this command:

```shell
curl https://raw.githubusercontent.com/chanzuckerberg/terraform-provider-snowflake/main/download.sh | bash -s -- -b $HOME/.terraform.d/plugins
```

**Note that this will only work with recent releases, for older releases, use the version of download.sh that corresponds to that release (replace main in that curl with the version).**

It runs a script generated by [godownloader](https://github.com/goreleaser/godownloader) which installs into the proper directory for terraform (~/.terraform.d/plugins).

You can also just download a binary from our [releases](https://github.com/chanzuckerberg/terraform-provider-snowflake/releases) and follow the [Terraform directions for installing 3rd party plugins](https://www.terraform.io/docs/configuration/providers.html#third-party-plugins).

### For Terraform v0.13+ users
You can use [Explicit Provider Source Locations](https://www.terraform.io/upgrade-guides/0-13.html#explicit-provider-source-locations).

The following maybe work well.

```terraform
terraform {
  required_providers {
    snowflake = {
      source = "chanzuckerberg/snowflake"
      version = "0.20.0"
    }
  }
}
```

TODO fogg config

## Usage

In-depth docs are available [on the Terraform registry](https://registry.terraform.io/providers/chanzuckerberg/snowflake/latest).

## Development

If you do not have Go installed:

1. Install Go `brew install golang`
2. Make a Go development directory wherever you like `mkdir go_projects`
3. Add the following config to your profile
```
export GOPATH=$HOME/../go_projects # edit with your go_projects dir
export PATH=$PATH:$GOPATH/bin
```
4. Fork this repo and clone it into `go_projects`
5. cd to `terraform-provider-snowflake` and install all the required packages with `make setup`
6. Finally install goimports with `(cd && go get golang.org/x/tools/cmd/goimports)`.
7. You should now be able to successfully run the tests with `make test`

It has not been tested on Windows, so if you find problems let us know.

If you want to build and test the provider locally there is a make target `make install-tf` that will build the provider binary and install it in a location that terraform can find.

## Testing

**Note: PRs for new resources will not be accepted without passing acceptance tests.**

For the Terraform resources, there are 3 levels of testing - internal, unit and acceptance tests.

The 'internal' tests are run in the `github.com/chanzuckerberg/terraform-provider-snowflake/pkg/resources` package so that they can test functions that are not exported. These tests are intended to be limited to unit tests for simple functions.

The 'unit' tests are run in  `github.com/chanzuckerberg/terraform-provider-snowflake/pkg/resources_test`, so they only have access to the exported methods of `resources`. These tests exercise the CRUD methods that on the terraform resources. Note that all tests here make use of database mocking and are run locally. This means the tests are fast, but are liable to be wrong in subtle ways (since the mocks are unlikely to be perfect).

You can run these first two sets of tests with `make test`.

The 'acceptance' tests run the full stack, creating, modifying and destroying resources in a live snowflake account. To run them you need a snowflake account and the proper authentication set up. These tests are slower but have higher fidelity.

To run all tests, including the acceptance tests, run `make test-acceptance`.

We also run all tests in our [Travis-CI account](https://travis-ci.com/chanzuckerberg/terraform-provider-snowflake).

### Pull Request CI

Our CI jobs run the full acceptence test suite, which involves creating and destroying resources in a live snowflake account. Travis-CI is configured with environment variables to authenticate to our test snowflake account. For security reasons, those variables are not available to forks of this repo.

If you are making a PR from a forked repo, you can create a new Snowflake trial account and set up Travis to build it by setting these environement variables:

* `SNOWFLAKE_ACCOUNT` - The account name
* `SNOWFLAKE_USER` - A snowflake user for running tests.
* `SNOWFLAKE_PASSWORD` - Password for that user.
* `SNOWFLAKE_ROLE` - Needs to be ACCOUNTADMIN or similar.
* `SNOWFLAKE_REGION` - Default is us-west-2, set this if your snowflake account is in a different region.

If you are using the Standard Snowflake plan, it's recommended you also set up the following environment variables to skip tests for features not enabled for it:

* `SKIP_DATABASE_TESTS` - to skip tests with retention time larger than 1 day
* `SKIP_WAREHOUSE_TESTS` - to skip tests with multi warehouses

## Releasing

**Note: Currently only @ryanking and @edulop91 have keys that are whitelisted in the terraform registry, so only they can do releases.**

Releases are done by [goreleaser](https://goreleaser.com/) and run by our make files. There two goreleaser configs, `.goreleaser.yml` for regular releases and `.goreleaser.prerelease.yml` for doing prereleases (for testing).

As of recently releases are also [published to the terraform registry](https://registry.terraform.io/providers/chanzuckerberg/snowflake/latest). That publishing requires that releases by signed. We do that signing via goreleaser using individual keybase keys. They key you want to use to sign must be passed in with the `KEYBASE_KEY_ID` environment variable.