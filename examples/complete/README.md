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
| <a name="input_region"></a> [region](#input\_region) | Azure Region in which the infra needs to be provisioned | `string` | `"eastus"` | no |
| <a name="input_log_analytics_workspace_sku"></a> [log\_analytics\_workspace\_sku](#input\_log\_analytics\_workspace\_sku) | Specifies the SKU of the Log Analytics Workspace. Possible values are Free, PerNode, Premium, Standard, Standalone, Unlimited, CapacityReservation, and PerGB2018 (new SKU as of 2018-04-03). Defaults to PerGB2018. | `string` | `"PerGB2018"` | no |
| <a name="input_log_analytics_workspace_retention_in_days"></a> [log\_analytics\_workspace\_retention\_in\_days](#input\_log\_analytics\_workspace\_retention\_in\_days) | The workspace data retention in days. Possible values are either 7 (Free Tier only) or range between 30 and 730. | `number` | `"30"` | no |
| <a name="input_log_analytics_workspace_identity"></a> [log\_analytics\_workspace\_identity](#input\_log\_analytics\_workspace\_identity) | A identity block as defined below. | <pre>object({<br>    type         = string<br>    identity_ids = optional(list(string))<br>  })</pre> | `null` | no |
| <a name="input_log_analytics_destination_type"></a> [log\_analytics\_destination\_type](#input\_log\_analytics\_destination\_type) | (Optional) Specifies the type of destination for the logs. Possible values are 'Dedicated' or 'AzureDiagnostics'. | `string` | `"AzureDiagnostics"` | no |
| <a name="input_enabled_log"></a> [enabled\_log](#input\_enabled\_log) | n/a | <pre>list(object({<br>    category_group = optional(string, "allLogs")<br>    category       = optional(string, null)<br>  }))</pre> | <pre>[<br>  {<br>    "category_group": "allLogs"<br>  }<br>]</pre> | no |
| <a name="input_metric"></a> [metric](#input\_metric) | n/a | <pre>object({<br>    category = optional(string, "AllMetrics")<br>    enabled  = optional(bool, false)<br>  })</pre> | <pre>{<br>  "category": "AllMetrics"<br>}</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_signalr_id"></a> [signalr\_id](#output\_signalr\_id) | n/a |
| <a name="output_signalr_name"></a> [signalr\_name](#output\_signalr\_name) | n/a |
| <a name="output_location"></a> [location](#output\_location) | n/a |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
