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
  description = "(Require) Location of the SignalR Service"
  type        = string
  nullable    = false
}

variable "public_network_access_enabled" {
  description = "(Optional) Indicates whether public network access is allowed"
  type        = bool
  default     = true
}

variable "connectivity_logs_enabled" {
  description = "(Optional) Indicates whether to enable connectivity logs"
  type        = bool
  default     = false
}

variable "http_request_logs_enabled" {
  description = "(Optional) Indicates whether to enable http request logs"
  type        = bool
  default     = false
}

variable "live_trace_enabled" {
  description = "(Optional) Indicated whether to enable live traces"
  type        = bool
  default     = false
}

variable "messaging_logs_enabled" {
  description = "(Optional) Indicates whether to enable messaging logs"
  type        = bool
  default     = false
}

variable "service_mode" {
  description = "(Optional) The service mode of the SignalR Service"
  type        = string
  default     = "Default"

  validation {
    condition     = can(regex("^(Default|Classic|Serverless)$", var.service_mode))
    error_message = "Invalid service_mode value"
  }
}

variable "sku_name" {
  description = "(Optional) The SKU of the SignalR Service"
  type        = string
  default     = "Free_F1"
  validation {
    condition     = can(regex("^(Free_F1|Standard_S1|Premium_P1|Premium_P2)$", var.sku_name))
    error_message = "Invalid sku_name value"
  }
}

variable "sku_capacity" {
  description = "(Optional) The capacity of the SKU"
  type        = number
  default     = 1
  validation {
    condition     = var.sku_capacity == null || can(regex("^[0-9]$", var.sku_capacity))
    error_message = "Invalid `sku_capacity` value"
  }
  validation {
    condition = contains([
      1, 2, 3, 4, 5, 6, 7, 8, 9,
      10, 20, 30, 40, 50, 60, 70, 80, 90,
    100, 200, 300, 400, 500, 600, 700, 800, 900, 1000], var.sku_capacity)
    error_message = "Invalid `sku_capacity` value"
  }

}

variable "cors_allowed_origins" {
  description = "(Optional) The allowed origins for CORS, separated by comma"
  type        = list(string)
  default     = []
}

variable "upstream_endpoint" {
  description = "(Optional) The upstream endpoint configuration"
  type = object({
    category_pattern = optional(list(string))
    event_pattern    = optional(list(string))
    hub_pattern      = optional(list(string))
    url_template     = optional(string)
  })
  default = null
}

variable "network_acl" {
  description = "(Optional) The network ACL configuration"
  type = object({
    default_action        = string
    allowed_request_types = list(string)
  })
  default = null
}

variable "private_endpoints" {
  description = "(Optional) The private endpoints configuration"
  type = list(object({
    private_endpoint_id   = string
    allowed_request_types = list(string)
  }))
  default = []
}

variable "resource_names_map" {
  description = "(Optional) A map of key to resource_name that will be used by tf-launch-module_library-resource_name to generate resource names"
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
  }
}

variable "product_family" {
  description = "(Optional) Name of the product family for which the resource is created"
  type        = string
  default     = "launch"
}

variable "product_service" {
  description = "(Optional) Name of the product service for which the resource is created"
  type        = string
  default     = "signalr"
}

variable "environment" {
  description = "(Optional) Environment in which the resource should be provisioned like dev, qa, prod etc."
  type        = string
  default     = "dev"
}

variable "environment_number" {
  description = "(Optional) The environment count for the respective environment. Defaults to 000. Increments in value of 1"
  type        = string
  default     = "000"
}

variable "region" {
  description = "(Optional) Azure Region in which the infra needs to be provisioned"
  type        = string
  default     = "eastus"
}

variable "resource_number" {
  description = "(Optional) The resource count for the respective resource. Defaults to 000. Increments in value of 1"
  type        = string
  default     = "000"
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
