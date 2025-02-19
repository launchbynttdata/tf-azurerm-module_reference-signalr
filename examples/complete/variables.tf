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
