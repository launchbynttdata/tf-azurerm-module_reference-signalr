# with_cake

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
| <a name="module_signalr"></a> [signalr](#module\_signalr) | ../.. | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_logical_product_family"></a> [logical\_product\_family](#input\_logical\_product\_family) | Name of the product family for which the resource is created | `string` | `"launch"` | no |
| <a name="input_logical_product_service"></a> [logical\_product\_service](#input\_logical\_product\_service) | Name of the product service for which the resource is created | `string` | `"signalr"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment in which the resource should be provisioned like dev, qa, prod etc. | `string` | `"dev"` | no |
| <a name="input_environment_number"></a> [environment\_number](#input\_environment\_number) | The environment count for the respective environment. Defaults to 000. Increments in value of 1 | `string` | `"000"` | no |
| <a name="input_resource_number"></a> [resource\_number](#input\_resource\_number) | The resource count for the respective resource. Defaults to 000. Increments in value of 1 | `string` | `"000"` | no |
| <a name="input_use_azure_region_abbr"></a> [use\_azure\_region\_abbr](#input\_use\_azure\_region\_abbr) | Abbreviate the region in the resource names | `bool` | `true` | no |
| <a name="input_region"></a> [region](#input\_region) | Azure Region in which the infra needs to be provisioned | `string` | `"eastus"` | no |
| <a name="input_log_analytics_workspace_sku"></a> [log\_analytics\_workspace\_sku](#input\_log\_analytics\_workspace\_sku) | Specifies the SKU of the Log Analytics Workspace. Possible values are Free, PerNode, Premium, Standard, Standalone, Unlimited, CapacityReservation, and PerGB2018 (new SKU as of 2018-04-03). Defaults to PerGB2018. | `string` | `"PerGB2018"` | no |
| <a name="input_log_analytics_workspace_retention_in_days"></a> [log\_analytics\_workspace\_retention\_in\_days](#input\_log\_analytics\_workspace\_retention\_in\_days) | The workspace data retention in days. Possible values are either 7 (Free Tier only) or range between 30 and 730. | `number` | `"30"` | no |
| <a name="input_log_analytics_workspace_identity"></a> [log\_analytics\_workspace\_identity](#input\_log\_analytics\_workspace\_identity) | A identity block as defined below. | <pre>object({<br>    type         = string<br>    identity_ids = optional(list(string))<br>  })</pre> | `null` | no |
| <a name="input_log_analytics_destination_type"></a> [log\_analytics\_destination\_type](#input\_log\_analytics\_destination\_type) | (Optional) Specifies the type of destination for the logs. Possible values are 'Dedicated' or 'AzureDiagnostics'. | `string` | `"AzureDiagnostics"` | no |
| <a name="input_enabled_log"></a> [enabled\_log](#input\_enabled\_log) | n/a | <pre>list(object({<br>    category_group = optional(string, "allLogs")<br>    category       = optional(string, null)<br>  }))</pre> | <pre>[<br>  {<br>    "category_group": "allLogs"<br>  }<br>]</pre> | no |
| <a name="input_metric"></a> [metric](#input\_metric) | n/a | <pre>object({<br>    category = optional(string, "AllMetrics")<br>    enabled  = optional(bool, false)<br>  })</pre> | <pre>{<br>  "category": "AllMetrics"<br>}</pre> | no |
| <a name="input_metric_alerts"></a> [metric\_alerts](#input\_metric\_alerts) | n/a | <pre>map(object({<br>    description        = string<br>    action_groups      = optional(set(string), [])<br>    enabled            = optional(bool, true)<br>    severity           = optional(number, 3)<br>    frequency          = optional(string)<br>    webhook_properties = optional(map(string))<br><br>    criterias = optional(list(object({<br>      threshold        = number<br>      metric_namespace = string<br>      metric_name      = string<br>      aggregation      = string<br>      operator         = string<br>      dimensions = optional(list(object({<br>        name     = string<br>        operator = string<br>        values   = list(string)<br>      })))<br>    })), [])<br><br>    dynamic_criteria = optional(object({<br>      alert_sensitivity = string<br>      metric_name       = string<br>      metric_namespace  = string<br>      aggregation       = string<br>      operator          = string<br>      dimensions = optional(list(object({<br>        name     = string<br>        operator = string<br>        values   = list(string)<br>      })))<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_signalr_id"></a> [signalr\_id](#output\_signalr\_id) | n/a |
| <a name="output_signalr_name"></a> [signalr\_name](#output\_signalr\_name) | n/a |
| <a name="output_location"></a> [location](#output\_location) | n/a |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | n/a |
| <a name="output_metric_alerts"></a> [metric\_alerts](#output\_metric\_alerts) | n/a |
| <a name="output_action_groups"></a> [action\_groups](#output\_action\_groups) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
