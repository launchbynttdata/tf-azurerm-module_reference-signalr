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
| <a name="input_region"></a> [region](#input\_region) | Azure Region in which the infra needs to be provisioned | `string` | `"eastus"` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | The SKU of the SignalR Service. Possible values are Free\_F1, Standard\_S1, Premium\_P1, and Premium\_P2. | `string` | `"Premium_P1"` | no |
| <a name="input_log_analytics_workspace_sku"></a> [log\_analytics\_workspace\_sku](#input\_log\_analytics\_workspace\_sku) | Specifies the SKU of the Log Analytics Workspace. Possible values are Free, PerNode, Premium, Standard, Standalone, Unlimited, CapacityReservation, and PerGB2018 (new SKU as of 2018-04-03). Defaults to PerGB2018. | `string` | `"PerGB2018"` | no |
| <a name="input_log_analytics_workspace_retention_in_days"></a> [log\_analytics\_workspace\_retention\_in\_days](#input\_log\_analytics\_workspace\_retention\_in\_days) | The workspace data retention in days. Possible values are either 7 (Free Tier only) or range between 30 and 730. | `number` | `"30"` | no |
| <a name="input_log_analytics_workspace_identity"></a> [log\_analytics\_workspace\_identity](#input\_log\_analytics\_workspace\_identity) | A identity block as defined below. | <pre>object({<br/>    type         = string<br/>    identity_ids = optional(list(string))<br/>  })</pre> | `null` | no |
| <a name="input_log_analytics_destination_type"></a> [log\_analytics\_destination\_type](#input\_log\_analytics\_destination\_type) | (Optional) Specifies the type of destination for the logs. Possible values are 'Dedicated' or 'AzureDiagnostics'. | `string` | `"AzureDiagnostics"` | no |
| <a name="input_live_trace_enabled"></a> [live\_trace\_enabled](#input\_live\_trace\_enabled) | Indicates whether to enable live traces | `bool` | `true` | no |
| <a name="input_enabled_log"></a> [enabled\_log](#input\_enabled\_log) | n/a | <pre>list(object({<br/>    category_group = optional(string, "allLogs")<br/>    category       = optional(string, null)<br/>  }))</pre> | <pre>[<br/>  {<br/>    "category_group": "allLogs"<br/>  }<br/>]</pre> | no |
| <a name="input_metric"></a> [metric](#input\_metric) | n/a | <pre>object({<br/>    category = optional(string, "AllMetrics")<br/>    enabled  = optional(bool, false)<br/>  })</pre> | <pre>{<br/>  "category": "AllMetrics"<br/>}</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Override for the resource group name. When null, the reference module generates a name using the resource\_names module. | `string` | `null` | no |
| <a name="input_action_group"></a> [action\_group](#input\_action\_group) | Action group to create and attach to metric alerts. Set to null to skip creation. | <pre>object({<br/>    name       = string<br/>    short_name = string<br/>    arm_role_receivers = optional(list(object({<br/>      name                    = string<br/>      role_id                 = string<br/>      use_common_alert_schema = optional(bool)<br/>    })), [])<br/>    email_receivers = optional(list(object({<br/>      name                    = string<br/>      email_address           = string<br/>      use_common_alert_schema = optional(bool)<br/>    })), [])<br/>  })</pre> | `null` | no |
| <a name="input_metric_alerts"></a> [metric\_alerts](#input\_metric\_alerts) | Map of metric alerts to create, keyed by alert name. | <pre>map(object({<br/>    description        = string<br/>    action_groups      = optional(set(string), [])<br/>    frequency          = optional(string, "PT1M")<br/>    severity           = optional(number, 3)<br/>    enabled            = optional(bool, true)<br/>    webhook_properties = optional(map(string), {})<br/>    criteria = optional(list(object({<br/>      metric_namespace       = string<br/>      metric_name            = string<br/>      aggregation            = string<br/>      operator               = string<br/>      threshold              = number<br/>      skip_metric_validation = optional(bool, false)<br/>      dimensions = optional(list(object({<br/>        name     = string<br/>        operator = string<br/>        values   = list(string)<br/>      })), [])<br/>    })), null)<br/>    dynamic_criteria = optional(object({<br/>      metric_namespace       = string<br/>      metric_name            = string<br/>      aggregation            = string<br/>      operator               = string<br/>      alert_sensitivity      = string<br/>      ignore_data_before     = optional(string)<br/>      skip_metric_validation = optional(bool, false)<br/>      dimensions = optional(list(object({<br/>        name     = string<br/>        operator = string<br/>        values   = list(string)<br/>      })), [])<br/>    }), null)<br/>  }))</pre> | `{}` | no |
| <a name="input_enable_monitor_autoscale_setting"></a> [enable\_monitor\_autoscale\_setting](#input\_enable\_monitor\_autoscale\_setting) | Whether to create an Azure Monitor Autoscale Setting targeting the SignalR service. | `bool` | `true` | no |
| <a name="input_autoscale_enabled"></a> [autoscale\_enabled](#input\_autoscale\_enabled) | Whether automatic scaling is enabled. Defaults to true. | `bool` | `true` | no |
| <a name="input_autoscale_profiles"></a> [autoscale\_profiles](#input\_autoscale\_profiles) | One or more autoscale profile blocks (up to 20). | <pre>list(object({<br/>    name = string<br/>    capacity = object({<br/>      default = number<br/>      maximum = number<br/>      minimum = number<br/>    })<br/>    rules = optional(list(object({<br/>      metric_trigger = object({<br/>        metric_name = string<br/><br/>        operator                 = string<br/>        statistic                = string<br/>        time_aggregation         = string<br/>        time_grain               = string<br/>        time_window              = string<br/>        threshold                = number<br/>        metric_namespace         = optional(string)<br/>        divide_by_instance_count = optional(bool)<br/>        dimensions = optional(list(object({<br/>          name     = string<br/>          operator = string<br/>          values   = list(string)<br/>        })))<br/>      })<br/>      scale_action = object({<br/>        cooldown  = string<br/>        direction = string<br/>        type      = string<br/>        value     = string<br/>      })<br/>    })))<br/>    fixed_date = optional(object({<br/>      end      = string<br/>      start    = string<br/>      timezone = optional(string, "UTC")<br/>    }))<br/>    recurrence = optional(object({<br/>      timezone = optional(string, "UTC")<br/>      days     = list(string)<br/>      hours    = list(number)<br/>      minutes  = list(number)<br/>    }))<br/>  }))</pre> | `null` | no |
| <a name="input_autoscale_notification"></a> [autoscale\_notification](#input\_autoscale\_notification) | Optional notification configuration for autoscale events. | <pre>object({<br/>    email = optional(object({<br/>      custom_emails                         = optional(list(string))<br/>      send_to_subscription_administrator    = optional(bool, false)<br/>      send_to_subscription_co_administrator = optional(bool, false)<br/>    }))<br/>    webhook = optional(list(object({<br/>      service_uri = string<br/>      properties  = optional(map(string))<br/>    })))<br/>  })</pre> | `null` | no |
| <a name="input_autoscale_predictive"></a> [autoscale\_predictive](#input\_autoscale\_predictive) | Optional predictive autoscale configuration. | <pre>object({<br/>    scale_mode      = string<br/>    look_ahead_time = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_action_group_ids"></a> [action\_group\_ids](#input\_action\_group\_ids) | Explicit list of existing action group IDs to attach to alerts. | `list(string)` | `[]` | no |
| <a name="input_service_mode"></a> [service\_mode](#input\_service\_mode) | The service mode of the SignalR Service. Possible values are Default, Classic, and Serverless. | `string` | `"Default"` | no |
| <a name="input_sku_capacity"></a> [sku\_capacity](#input\_sku\_capacity) | The capacity of the SignalR SKU. | `number` | `1` | no |
| <a name="input_upstream_endpoint"></a> [upstream\_endpoint](#input\_upstream\_endpoint) | The upstream endpoint configuration. | <pre>object({<br/>    category_pattern = optional(list(string))<br/>    event_pattern    = optional(list(string))<br/>    hub_pattern      = optional(list(string))<br/>    url_template     = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_network_acl"></a> [network\_acl](#input\_network\_acl) | The SignalR network ACL configuration. | <pre>object({<br/>    default_action        = string<br/>    allowed_request_types = list(string)<br/>  })</pre> | `null` | no |
| <a name="input_private_endpoints"></a> [private\_endpoints](#input\_private\_endpoints) | Private endpoints for the SignalR network ACL. | <pre>list(object({<br/>    private_endpoint_id   = string<br/>    allowed_request_types = list(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_resource_names_map"></a> [resource\_names\_map](#input\_resource\_names\_map) | A map of key to resource\_name used for name generation. | <pre>map(object({<br/>    name       = string<br/>    max_length = optional(number, 60)<br/>  }))</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_signalr_id"></a> [signalr\_id](#output\_signalr\_id) | n/a |
| <a name="output_signalr_name"></a> [signalr\_name](#output\_signalr\_name) | n/a |
| <a name="output_location"></a> [location](#output\_location) | n/a |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | n/a |
| <a name="output_autoscale_setting_id"></a> [autoscale\_setting\_id](#output\_autoscale\_setting\_id) | The ID of the Monitor Autoscale Setting, if created. |
| <a name="output_autoscale_setting_name"></a> [autoscale\_setting\_name](#output\_autoscale\_setting\_name) | The name of the Monitor Autoscale Setting, if created. |
| <a name="output_action_group_name"></a> [action\_group\_name](#output\_action\_group\_name) | The name of the Monitor Action Group, if created. |
| <a name="output_action_group_id"></a> [action\_group\_id](#output\_action\_group\_id) | The ID of the Monitor Action Group, if created. |
| <a name="output_metric_alert_ids"></a> [metric\_alert\_ids](#output\_metric\_alert\_ids) | Map of metric alert name to resource ID. |
<!-- END_TF_DOCS -->
