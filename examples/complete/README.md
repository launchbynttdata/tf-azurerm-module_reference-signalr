# with_cake

<!-- BEGIN_TF_DOCS -->
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
| <a name="module_monitor_action_group"></a> [monitor\_action\_group](#module\_monitor\_action\_group) | terraform.registry.launch.nttdata.com/module_primitive/monitor_action_group/azurerm | ~> 1.0.0 |
| <a name="module_monitor_metric_alert"></a> [monitor\_metric\_alert](#module\_monitor\_metric\_alert) | terraform.registry.launch.nttdata.com/module_primitive/monitor_metric_alert/azurerm | ~> 2.0 |

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
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Test resource group | `string` | `"test"` | no |
| <a name="input_action_group"></a> [action\_group](#input\_action\_group) | n/a | <pre>object({<br>    name       = string<br>    short_name = string<br>    arm_role_receivers = optional(list(object({<br>      name                    = string<br>      role_id                 = string<br>      use_common_alert_schema = optional(bool)<br>    })), [])<br>    email_receivers = optional(list(object({<br>      name                    = string<br>      email_address           = string<br>      use_common_alert_schema = optional(bool)<br>    })), [])<br>  })</pre> | <pre>{<br>  "arm_role_receivers": [],<br>  "email_receivers": [<br>    {<br>      "email_address": "test@example.com",<br>      "name": "oncall",<br>      "use_common_alert_schema": true<br>    }<br>  ],<br>  "name": "ag-test-alerts",<br>  "short_name": "agtest"<br>}</pre> | no |
| <a name="input_action_group_ids"></a> [action\_group\_ids](#input\_action\_group\_ids) | n/a | `list(string)` | `[]` | no |
| <a name="input_metric_alerts"></a> [metric\_alerts](#input\_metric\_alerts) | n/a | <pre>map(object({<br>    description        = string<br>    action_groups      = optional(set(string), [])<br>    frequency          = optional(string, "PT5M")<br>    severity           = optional(number, 2)<br>    enabled            = optional(bool, true)<br>    webhook_properties = optional(map(string), {})<br>    criteria = optional(list(object({<br>      metric_namespace       = string<br>      metric_name            = string<br>      aggregation            = string<br>      operator               = string<br>      threshold              = number<br>      skip_metric_validation = optional(bool, false)<br>      dimensions = optional(list(object({<br>        name     = string<br>        operator = string<br>        values   = list(string)<br>      })), [])<br>    })), null)<br>    dynamic_criteria = optional(object({<br>      metric_namespace       = string<br>      metric_name            = string<br>      aggregation            = string<br>      operator               = string<br>      alert_sensitivity      = string<br>      ignore_data_before     = optional(string)<br>      skip_metric_validation = optional(bool, false)<br>      dimensions = optional(list(object({<br>        name     = string<br>        operator = string<br>        values   = list(string)<br>      })), [])<br>    }), null)<br>  }))</pre> | <pre>{<br>  "signalr-connections-high": {<br>    "action_groups": [],<br>    "criteria": [<br>      {<br>        "aggregation": "Maximum",<br>        "dimensions": [],<br>        "metric_name": "ConnectionCount",<br>        "metric_namespace": "Microsoft.SignalRService/SignalR",<br>        "operator": "GreaterThan",<br>        "skip_metric_validation": false,<br>        "threshold": 1000<br>      }<br>    ],<br>    "description": "High number of SignalR connections",<br>    "dynamic_criteria": null,<br>    "enabled": true,<br>    "frequency": "PT5M",<br>    "severity": 2,<br>    "webhook_properties": {}<br>  }<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_signalr_id"></a> [signalr\_id](#output\_signalr\_id) | n/a |
| <a name="output_signalr_name"></a> [signalr\_name](#output\_signalr\_name) | n/a |
| <a name="output_location"></a> [location](#output\_location) | n/a |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | n/a |
<!-- END_TF_DOCS -->
