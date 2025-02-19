# tf-azurerm-module_reference-signalr

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![License: CC BY-NC-ND 4.0](https://img.shields.io/badge/License-CC_BY--NC--ND_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-nd/4.0/)

## Overview

This terraform reference module will provision a SignalR service in the Azure cloud.

## Pre-Commit hooks

[.pre-commit-config.yaml](.pre-commit-config.yaml) file defines certain `pre-commit` hooks that are relevant to terraform, golang and common linting tasks. There are no custom hooks added.

`commitlint` hook enforces commit message in certain format. The commit contains the following structural elements, to communicate intent to the consumers of your commit messages:

- **fix**: a commit of the type `fix` patches a bug in your codebase (this correlates with PATCH in Semantic Versioning).
- **feat**: a commit of the type `feat` introduces a new feature to the codebase (this correlates with MINOR in Semantic Versioning).
- **BREAKING CHANGE**: a commit that has a footer `BREAKING CHANGE:`, or appends a `!` after the type/scope, introduces a breaking API change (correlating with MAJOR in Semantic Versioning). A BREAKING CHANGE can be part of commits of any type.
footers other than BREAKING CHANGE: <description> may be provided and follow a convention similar to git trailer format.
- **build**: a commit of the type `build` adds changes that affect the build system or external dependencies (example scopes: gulp, broccoli, npm)
- **chore**: a commit of the type `chore` adds changes that don't modify src or test files
- **ci**: a commit of the type `ci` adds changes to our CI configuration files and scripts (example scopes: Travis, Circle, BrowserStack, SauceLabs)
- **docs**: a commit of the type `docs` adds documentation only changes
- **perf**: a commit of the type `perf` adds code change that improves performance
- **refactor**: a commit of the type `refactor` adds code change that neither fixes a bug nor adds a feature
- **revert**: a commit of the type `revert` reverts a previous commit
- **style**: a commit of the type `style` adds code changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
- **test**: a commit of the type `test` adds missing tests or correcting existing tests

Base configuration used for this project is [commitlint-config-conventional (based on the Angular convention)](https://github.com/conventional-changelog/commitlint/tree/master/@commitlint/config-conventional#type-enum)

If you are a developer using vscode, [this](https://marketplace.visualstudio.com/items?itemName=joshbolduc.commitlint) plugin may be helpful.

`detect-secrets-hook` prevents new secrets from being introduced into the baseline. TODO: INSERT DOC LINK ABOUT HOOKS

In order for `pre-commit` hooks to work properly

- You need to have the pre-commit package manager installed. [Here](https://pre-commit.com/#install) are the installation instructions.
- `pre-commit` would install all the hooks when commit message is added by default except for `commitlint` hook. `commitlint` hook would need to be installed manually using the command below

```
pre-commit install --hook-type commit-msg
```

## To test the resource group module locally

1. For development/enhancements to this module locally, you'll need to install all of its components. This is controlled by the `configure` target in the project's [`Makefile`](./Makefile). Before you can run `configure`, familiarize yourself with the variables in the `Makefile` and ensure they're pointing to the right places.

```
make configure
```

This adds in several files and directories that are ignored by `git`. They expose many new Make targets.

2. _THIS STEP APPLIES ONLY TO MICROSOFT AZURE. IF YOU ARE USING A DIFFERENT PLATFORM PLEASE SKIP THIS STEP._ The first target you care about is `env`. This is the common interface for setting up environment variables. The values of the environment variables will be used to authenticate with cloud provider from local development workstation.

`make configure` command will bring down `azure_env.sh` file on local workstation. Devloper would need to modify this file, replace the environment variable values with relevant values.

These environment variables are used by `terratest` integration suit.

Service principle used for authentication(value of ARM_CLIENT_ID) should have below privileges on resource group within the subscription.

```
"Microsoft.Resources/subscriptions/resourceGroups/write"
"Microsoft.Resources/subscriptions/resourceGroups/read"
"Microsoft.Resources/subscriptions/resourceGroups/delete"
```

Then run this make target to set the environment variables on developer workstation.

```
make env
```

3. The first target you care about is `check`.

**Pre-requisites**
Before running this target it is important to ensure that, developer has created files mentioned below on local workstation under root directory of git repository that contains code for primitives/segments. Note that these files are `azure` specific. If primitive/segment under development uses any other cloud provider than azure, this section may not be relevant.

- A file named `provider.tf` with contents below

```
provider "azurerm" {
  features {}
}
```

- A file named `terraform.tfvars` which contains key value pair of variables used.

Note that since these files are added in `gitignore` they would not be checked in into primitive/segment's git repo.

After creating these files, for running tests associated with the primitive/segment, run

```
make check
```

If `make check` target is successful, developer is good to commit the code to primitive/segment's git repo.

`make check` target

- runs `terraform commands` to `lint`,`validate` and `plan` terraform code.
- runs `conftests`. `conftests` make sure `policy` checks are successful.
- runs `terratest`. This is integration test suit.
- runs `opa` tests
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.117 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resource_names"></a> [resource\_names](#module\_resource\_names) | terraform.registry.launch.nttdata.com/module_library/resource_name/launch | ~> 2.0 |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | terraform.registry.launch.nttdata.com/module_primitive/resource_group/azurerm | ~> 1.0 |
| <a name="module_signalr"></a> [signalr](#module\_signalr) | terraform.registry.launch.nttdata.com/module_primitive/signalr/azurerm | ~> 1.0 |
| <a name="module_log_analytics_workspace"></a> [log\_analytics\_workspace](#module\_log\_analytics\_workspace) | terraform.registry.launch.nttdata.com/module_primitive/log_analytics_workspace/azurerm | ~> 1.0 |
| <a name="module_diagnostic_setting"></a> [diagnostic\_setting](#module\_diagnostic\_setting) | terraform.registry.launch.nttdata.com/module_primitive/monitor_diagnostic_setting/azurerm | ~> 1.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_signalr_location"></a> [signalr\_location](#input\_signalr\_location) | Location of the SignalR Service | `string` | n/a | yes |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Indicates whether public network access is allowed | `bool` | `true` | no |
| <a name="input_connectivity_logs_enabled"></a> [connectivity\_logs\_enabled](#input\_connectivity\_logs\_enabled) | Indicates whether to enable connectivity logs | `bool` | `false` | no |
| <a name="input_http_request_logs_enabled"></a> [http\_request\_logs\_enabled](#input\_http\_request\_logs\_enabled) | Indicates whether to enable http request logs | `bool` | `false` | no |
| <a name="input_live_trace_enabled"></a> [live\_trace\_enabled](#input\_live\_trace\_enabled) | Indicates whether to enable live traces | `bool` | `false` | no |
| <a name="input_messaging_logs_enabled"></a> [messaging\_logs\_enabled](#input\_messaging\_logs\_enabled) | Indicates whether to enable messaging logs | `bool` | `false` | no |
| <a name="input_service_mode"></a> [service\_mode](#input\_service\_mode) | The service mode of the SignalR Service. Possible values are Default, Classic, and Serverless | `string` | `"Default"` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | The SKU of the SignalR Service. Possible values are Free\_F1, Standard\_S1, Premium\_P1, and Premium\_P2 | `string` | `"Free_F1"` | no |
| <a name="input_sku_capacity"></a> [sku\_capacity](#input\_sku\_capacity) | The capacity of the SKU.  See [the documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/signalr_service#capacity-1) for possible values. | `number` | `1` | no |
| <a name="input_cors_allowed_origins"></a> [cors\_allowed\_origins](#input\_cors\_allowed\_origins) | The allowed origins for CORS, separated by comma. The default is set to ["*"] which will allow all origins | `list(string)` | <pre>[<br>  "*"<br>]</pre> | no |
| <a name="input_upstream_endpoint"></a> [upstream\_endpoint](#input\_upstream\_endpoint) | The upstream endpoint configuration | <pre>object({<br>    category_pattern = optional(list(string))<br>    event_pattern    = optional(list(string))<br>    hub_pattern      = optional(list(string))<br>    url_template     = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_network_acl"></a> [network\_acl](#input\_network\_acl) | The SignalR network ACL configuration | <pre>object({<br>    default_action        = string<br>    allowed_request_types = list(string)<br>  })</pre> | `null` | no |
| <a name="input_private_endpoints"></a> [private\_endpoints](#input\_private\_endpoints) | The private endpoints for the SignalR network ACL | <pre>list(object({<br>    private_endpoint_id   = string<br>    allowed_request_types = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_resource_names_map"></a> [resource\_names\_map](#input\_resource\_names\_map) | A map of key to resource\_name that will be used by tf-launch-module\_library-resource\_name to generate resource names | <pre>map(object(<br>    {<br>      name       = string<br>      max_length = optional(number, 60)<br>    }<br>  ))</pre> | <pre>{<br>  "log_analytics_workspace": {<br>    "max_length": 60,<br>    "name": "log"<br>  },<br>  "monitor_diagnostic_setting": {<br>    "max_length": 60,<br>    "name": "mds"<br>  },<br>  "resource_group": {<br>    "max_length": 60,<br>    "name": "rg"<br>  },<br>  "signalr": {<br>    "max_length": 60,<br>    "name": "sgnlr"<br>  }<br>}</pre> | no |
| <a name="input_logical_product_family"></a> [logical\_product\_family](#input\_logical\_product\_family) | Name of the product family for which the resource is created | `string` | `"launch"` | no |
| <a name="input_logical_product_service"></a> [logical\_product\_service](#input\_logical\_product\_service) | Name of the product service for which the resource is created | `string` | `"signalr"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment in which the resource should be provisioned like dev, qa, prod etc. | `string` | `"dev"` | no |
| <a name="input_environment_number"></a> [environment\_number](#input\_environment\_number) | The environment count for the respective environment. Defaults to 000. Increments in value of 1 | `string` | `"000"` | no |
| <a name="input_resource_number"></a> [resource\_number](#input\_resource\_number) | The resource count for the respective resource. Defaults to 000. Increments in value of 1 | `string` | `"000"` | no |
| <a name="input_use_azure_region_abbr"></a> [use\_azure\_region\_abbr](#input\_use\_azure\_region\_abbr) | Abbreviate the region in the resource names | `bool` | `true` | no |
| <a name="input_enable_log_analytics_workspace"></a> [enable\_log\_analytics\_workspace](#input\_enable\_log\_analytics\_workspace) | n/a | `bool` | `false` | no |
| <a name="input_log_analytics_workspace_sku"></a> [log\_analytics\_workspace\_sku](#input\_log\_analytics\_workspace\_sku) | Specifies the SKU of the Log Analytics Workspace. Possible values are Free, PerNode, Premium, Standard, Standalone, Unlimited, CapacityReservation, and PerGB2018 (new SKU as of 2018-04-03). Defaults to PerGB2018. | `string` | `"Free"` | no |
| <a name="input_log_analytics_workspace_retention_in_days"></a> [log\_analytics\_workspace\_retention\_in\_days](#input\_log\_analytics\_workspace\_retention\_in\_days) | The workspace data retention in days. Possible values are either 7 (Free Tier only) or range between 30 and 730. | `number` | `"30"` | no |
| <a name="input_log_analytics_workspace_identity"></a> [log\_analytics\_workspace\_identity](#input\_log\_analytics\_workspace\_identity) | A identity block as defined below. | <pre>object({<br>    type         = string<br>    identity_ids = optional(list(string))<br>  })</pre> | `null` | no |
| <a name="input_log_analytics_workspace_local_authentication_disabled"></a> [log\_analytics\_workspace\_local\_authentication\_disabled](#input\_log\_analytics\_workspace\_local\_authentication\_disabled) | Boolean flag to specify whether local authentication should be disabled. Defaults to false. | `bool` | `false` | no |
| <a name="input_log_analytics_destination_type"></a> [log\_analytics\_destination\_type](#input\_log\_analytics\_destination\_type) | Specifies the type of destination for the logs. Possible values are 'Dedicated' or 'AzureDiagnostics'. | `string` | `null` | no |
| <a name="input_enable_monitor_diagnostic_setting"></a> [enable\_monitor\_diagnostic\_setting](#input\_enable\_monitor\_diagnostic\_setting) | n/a | `bool` | `false` | no |
| <a name="input_enabled_log"></a> [enabled\_log](#input\_enabled\_log) | n/a | <pre>list(object({<br>    category_group = optional(string, "allLogs")<br>    category       = optional(string, null)<br>  }))</pre> | `null` | no |
| <a name="input_metric"></a> [metric](#input\_metric) | n/a | <pre>object({<br>    category = optional(string)<br>    enabled  = optional(bool)<br>  })</pre> | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_signalr_id"></a> [signalr\_id](#output\_signalr\_id) | n/a |
| <a name="output_signalr_name"></a> [signalr\_name](#output\_signalr\_name) | n/a |
| <a name="output_location"></a> [location](#output\_location) | n/a |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
