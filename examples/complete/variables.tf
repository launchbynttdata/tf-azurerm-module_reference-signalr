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
  description = "Test resource group"
  type        = string
  default     = "test"
}


variable "action_group" {
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

  default = {
    name       = "ag-test-alerts"
    short_name = "agtest"

    email_receivers = [
      {
        name                    = "oncall"
        email_address           = "test@example.com"
        use_common_alert_schema = true
      }
    ]

    arm_role_receivers = []
  }
}

variable "action_group_ids" {
  type    = list(string)
  default = []
}

variable "metric_alerts" {
  type = map(object({
    description        = string
    action_groups      = optional(set(string), [])
    frequency          = optional(string, "PT5M")
    severity           = optional(number, 2)
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

  default = {
    "signalr-connections-high" = {
      description   = "High number of SignalR connections"
      action_groups = []

      frequency = "PT5M"
      severity  = 2
      enabled   = true

      criteria = [
        {
          metric_namespace       = "Microsoft.SignalRService/SignalR"
          metric_name            = "ConnectionCount"
          aggregation            = "Maximum"
          operator               = "GreaterThan"
          threshold              = 1000
          skip_metric_validation = false
          dimensions             = []
        }
      ]

      dynamic_criteria   = null
      webhook_properties = {}
    }
  }

  validation {
    condition = alltrue(
      [for alert in values(var.metric_alerts) :
        !(alert.criteria == null && alert.dynamic_criteria == null)
      ]
    )
    error_message = "Each metric alert must define at least one of 'criteria' or 'dynamic_criteria'."
  }
}
