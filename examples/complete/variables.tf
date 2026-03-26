// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

variable "region" {
  description = "Azure Region in which the infra needs to be provisioned"
  type        = string
  default     = "eastus"
}

variable "sku_name" {
  description = "The SKU of the SignalR Service. Possible values are Free_F1, Standard_S1, Premium_P1, and Premium_P2."
  type        = string
  default     = "Premium_P1"
}

variable "log_analytics_workspace_sku" {
  type        = string
  description = "Specifies the SKU of the Log Analytics Workspace. Possible values are Free, PerNode, Premium, Standard, Standalone, Unlimited, CapacityReservation, and PerGB2018 (new SKU as of 2018-04-03). Defaults to PerGB2018."
  default     = "PerGB2018"
}

variable "log_analytics_workspace_retention_in_days" {
  type        = number
  description = "The workspace data retention in days. Possible values are either 7 (Free Tier only) or range between 30 and 730."
  default     = "30"
}

variable "log_analytics_workspace_identity" {
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  description = "A identity block as defined below."
  default     = null
}

variable "log_analytics_destination_type" {
  description = "(Optional) Specifies the type of destination for the logs. Possible values are 'Dedicated' or 'AzureDiagnostics'."
  type        = string
  default     = "AzureDiagnostics"
}

variable "live_trace_enabled" {
  description = "Indicates whether to enable live traces"
  type        = bool
  default     = true
}

variable "enabled_log" {
  type = list(object({
    category_group = optional(string, "allLogs")
    category       = optional(string, null)
  }))
  default = [{
    category_group = "allLogs"
  }]
}

variable "metric" {
  type = object({
    category = optional(string, "AllMetrics")
    enabled  = optional(bool, false)
  })
  default = {
    category = "AllMetrics"
  }
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "resource_group_name" {
  description = "Override for the resource group name. When null, the reference module generates a name using the resource_names module."
  type        = string
  default     = null
}


variable "action_group" {
  description = "Action group to create and attach to metric alerts. Set to null to skip creation."
  type = object({
    name       = string
    short_name = string
    arm_role_receivers = optional(list(object({
      name                    = string
      role_id                 = string
      use_common_alert_schema = optional(bool)
    })), [])
    email_receivers = optional(list(object({
      name                    = string
      email_address           = string
      use_common_alert_schema = optional(bool)
    })), [])
  })
  default = null
}

variable "metric_alerts" {
  description = "Map of metric alerts to create, keyed by alert name."
  type = map(object({
    description        = string
    action_groups      = optional(set(string), [])
    frequency          = optional(string, "PT1M")
    severity           = optional(number, 3)
    enabled            = optional(bool, true)
    webhook_properties = optional(map(string), {})
    criteria = optional(list(object({
      metric_namespace       = string
      metric_name            = string
      aggregation            = string
      operator               = string
      threshold              = number
      skip_metric_validation = optional(bool, false)
      dimensions = optional(list(object({
        name     = string
        operator = string
        values   = list(string)
      })), [])
    })), null)
    dynamic_criteria = optional(object({
      metric_namespace       = string
      metric_name            = string
      aggregation            = string
      operator               = string
      alert_sensitivity      = string
      ignore_data_before     = optional(string)
      skip_metric_validation = optional(bool, false)
      dimensions = optional(list(object({
        name     = string
        operator = string
        values   = list(string)
      })), [])
    }), null)
  }))
  default = {}
}

variable "enable_monitor_autoscale_setting" {
  description = "Whether to create an Azure Monitor Autoscale Setting targeting the SignalR service."
  type        = bool
  default     = true
}

variable "autoscale_enabled" {
  description = "Whether automatic scaling is enabled. Defaults to true."
  type        = bool
  default     = true
}

variable "autoscale_profiles" {
  description = "One or more autoscale profile blocks (up to 20)."
  type = list(object({
    name = string
    capacity = object({
      default = number
      maximum = number
      minimum = number
    })
    rules = optional(list(object({
      metric_trigger = object({
        metric_name = string

        operator                 = string
        statistic                = string
        time_aggregation         = string
        time_grain               = string
        time_window              = string
        threshold                = number
        metric_namespace         = optional(string)
        divide_by_instance_count = optional(bool)
        dimensions = optional(list(object({
          name     = string
          operator = string
          values   = list(string)
        })))
      })
      scale_action = object({
        cooldown  = string
        direction = string
        type      = string
        value     = string
      })
    })))
    fixed_date = optional(object({
      end      = string
      start    = string
      timezone = optional(string, "UTC")
    }))
    recurrence = optional(object({
      timezone = optional(string, "UTC")
      days     = list(string)
      hours    = list(number)
      minutes  = list(number)
    }))
  }))
  default = null
}

variable "autoscale_notification" {
  description = "Optional notification configuration for autoscale events."
  type = object({
    email = optional(object({
      custom_emails                         = optional(list(string))
      send_to_subscription_administrator    = optional(bool, false)
      send_to_subscription_co_administrator = optional(bool, false)
    }))
    webhook = optional(list(object({
      service_uri = string
      properties  = optional(map(string))
    })))
  })
  default = null
}

variable "autoscale_predictive" {
  description = "Optional predictive autoscale configuration."
  type = object({
    scale_mode      = string
    look_ahead_time = optional(string)
  })
  default = null
}
