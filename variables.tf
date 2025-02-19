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

variable "signalr_location" {
  description = "Location of the SignalR Service"
  type        = string
  nullable    = false
}

variable "public_network_access_enabled" {
  description = "Indicates whether public network access is allowed"
  type        = bool
  default     = true
}

variable "connectivity_logs_enabled" {
  description = "Indicates whether to enable connectivity logs"
  type        = bool
  default     = false
}

variable "http_request_logs_enabled" {
  description = "Indicates whether to enable http request logs"
  type        = bool
  default     = false
}

variable "live_trace_enabled" {
  description = "Indicates whether to enable live traces"
  type        = bool
  default     = false
}

variable "messaging_logs_enabled" {
  description = "Indicates whether to enable messaging logs"
  type        = bool
  default     = false
}

variable "service_mode" {
  description = "The service mode of the SignalR Service. Possible values are Default, Classic, and Serverless"
  type        = string
  default     = "Default"

  validation {
    condition     = can(regex("^(Default|Classic|Serverless)$", var.service_mode))
    error_message = "Invalid `service_mode` value"
  }
}

variable "sku_name" {
  description = "The SKU of the SignalR Service. Possible values are Free_F1, Standard_S1, Premium_P1, and Premium_P2"
  type        = string
  default     = "Free_F1"
  validation {
    condition     = can(regex("^(Free_F1|Standard_S1|Premium_P1|Premium_P2)$", var.sku_name))
    error_message = "Invalid `sku_name` value"
  }
}

variable "sku_capacity" {
  description = "The capacity of the SKU.  See [the documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/signalr_service#capacity-1) for possible values."
  type        = number
  default     = 1
  validation {
    condition = contains([
      1, 2, 3, 4, 5, 6, 7, 8, 9,
      10, 20, 30, 40, 50, 60, 70, 80, 90,
    100, 200, 300, 400, 500, 600, 700, 800, 900, 1000], var.sku_capacity)
    error_message = "Invalid `sku_capacity` value"
  }
}

variable "cors_allowed_origins" {
  description = <<EOF
  The allowed origins for CORS, separated by comma. The default is set to ["*"] which will allow all origins
  EOF
  type        = list(string)
  default     = ["*"]
}

variable "upstream_endpoint" {
  description = "The upstream endpoint configuration"
  type = object({
    category_pattern = optional(list(string))
    event_pattern    = optional(list(string))
    hub_pattern      = optional(list(string))
    url_template     = optional(string)
  })
  default = null
}

variable "network_acl" {
  description = "The SignalR network ACL configuration"
  type = object({
    default_action        = string
    allowed_request_types = list(string)
  })
  default = null
}

variable "private_endpoints" {
  description = "The private endpoints for the SignalR network ACL"
  type = list(object({
    private_endpoint_id   = string
    allowed_request_types = list(string)
  }))
  default = []
}

variable "resource_names_map" {
  description = "A map of key to resource_name that will be used by tf-launch-module_library-resource_name to generate resource names"
  type = map(object(
    {
      name       = string
      max_length = optional(number, 60)
    }
  ))
  default = {
    resource_group = {
      name       = "rg"
      max_length = 60
    }
    signalr = {
      name       = "sgnlr"
      max_length = 60
    }
    log_analytics_workspace = {
      name       = "log"
      max_length = 60
    }
    monitor_diagnostic_setting = {
      name       = "mds"
      max_length = 60
    }
  }
}

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

variable "enable_log_analytics_workspace" {
  type    = bool
  default = false
}

variable "log_analytics_workspace_sku" {
  type        = string
  description = "Specifies the SKU of the Log Analytics Workspace. Possible values are Free, PerNode, Premium, Standard, Standalone, Unlimited, CapacityReservation, and PerGB2018 (new SKU as of 2018-04-03). Defaults to PerGB2018."
  default     = "Free"
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

variable "log_analytics_workspace_local_authentication_disabled" {
  type        = bool
  description = "Boolean flag to specify whether local authentication should be disabled. Defaults to false."
  default     = false
}


variable "log_analytics_destination_type" {
  type        = string
  description = "Specifies the type of destination for the logs. Possible values are 'Dedicated' or 'AzureDiagnostics'."
  default     = null
}

variable "enable_monitor_diagnostic_setting" {
  type    = bool
  default = false
}

variable "enabled_log" {
  type = list(object({
    category_group = optional(string, "allLogs")
    category       = optional(string, null)
  }))
  default = null
}

variable "metric" {
  type = object({
    category = optional(string)
    enabled  = optional(bool)
  })
  default = null
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
