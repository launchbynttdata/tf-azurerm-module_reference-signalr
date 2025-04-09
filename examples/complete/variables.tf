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

# naming variables

variable "logical_product_family" {
  description = "Name of the product family for which the resource is created"
  type        = string
  default     = "launch"
}

variable "logical_product_service" {
  description = "Name of the product service for which the resource is created"
  type        = string
  default     = "signalr"
}

variable "environment" {
  description = "Environment in which the resource should be provisioned like dev, qa, prod etc."
  type        = string
  default     = "dev"
}

variable "environment_number" {
  description = "The environment count for the respective environment. Defaults to 000. Increments in value of 1"
  type        = string
  default     = "000"
}

variable "resource_number" {
  description = "The resource count for the respective resource. Defaults to 000. Increments in value of 1"
  type        = string
  default     = "000"
}

variable "use_azure_region_abbr" {
  description = "Abbreviate the region in the resource names"
  type        = bool
  default     = true
}

# signalr variables

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

variable "metric_alerts" {
  type = map(object({
    description        = string
    action_groups      = optional(set(string), [])
    enabled            = optional(bool, true)
    severity           = optional(number, 3)
    frequency          = optional(string)
    webhook_properties = optional(map(string))

    criterias = optional(list(object({
      threshold        = number
      metric_namespace = string
      metric_name      = string
      aggregation      = string
      operator         = string
      dimensions = optional(list(object({
        name     = string
        operator = string
        values   = list(string)
      })))
    })), [])

    dynamic_criteria = optional(object({
      alert_sensitivity = string
      metric_name       = string
      metric_namespace  = string
      aggregation       = string
      operator          = string
      dimensions = optional(list(object({
        name     = string
        operator = string
        values   = list(string)
      })))
    }))
  }))
  default = {}

  validation {
    condition = alltrue(
      [for alert in var.metric_alerts : !(alert.criterias == null && alert.dynamic_criteria == null)],
    )
    error_message = "At least one of 'criteria', 'dynamic_criteria' must be defined for all metric alerts"
  }
}
variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
