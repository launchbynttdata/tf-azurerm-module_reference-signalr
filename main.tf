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

module "resource_names" {
  source  = "terraform.registry.launch.nttdata.com/module_library/resource_name/launch"
  version = "~> 2.0"

  for_each = var.resource_names_map

  logical_product_family  = var.logical_product_family
  logical_product_service = var.logical_product_service
  region                  = var.signalr_location
  class_env               = var.environment
  cloud_resource_type     = each.value.name
  instance_env            = var.environment_number
  maximum_length          = each.value.max_length
  instance_resource       = var.resource_number
  use_azure_region_abbr   = var.use_azure_region_abbr

}

module "resource_group" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/resource_group/azurerm"
  version = "~> 1.0"

  name     = module.resource_names["resource_group"].standard
  location = var.signalr_location

  tags = merge(var.tags, { resource_name = module.resource_names["resource_group"].standard })
}

module "signalr" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/signalr/azurerm"
  version = "~> 1.0"

  signalr_location    = var.signalr_location
  resource_group_name = module.resource_group.name
  signalr_name        = module.resource_names["signalr"].standard

  public_network_access_enabled = var.public_network_access_enabled
  connectivity_logs_enabled     = var.connectivity_logs_enabled
  http_request_logs_enabled     = var.http_request_logs_enabled
  live_trace_enabled            = var.live_trace_enabled
  messaging_logs_enabled        = var.messaging_logs_enabled
  service_mode                  = var.service_mode
  sku_name                      = var.sku_name
  sku_capacity                  = var.sku_capacity
  cors_allowed_origins          = var.cors_allowed_origins
  upstream_endpoint             = var.upstream_endpoint
  network_acl                   = var.network_acl
  private_endpoints             = var.private_endpoints

  tags       = merge(local.tags, { resource_name = module.resource_names["signalr"].standard })
  depends_on = [module.resource_group]
}

module "log_analytics_workspace" {
  for_each = var.enable_log_analytics_workspace == true ? toset(["log_analytics_workspace"]) : []
  source   = "terraform.registry.launch.nttdata.com/module_primitive/log_analytics_workspace/azurerm"
  version  = "~> 1.0"

  name                          = module.resource_names["log_analytics_workspace"].standard
  location                      = var.signalr_location
  resource_group_name           = module.resource_group.name
  sku                           = var.log_analytics_workspace_sku
  retention_in_days             = var.log_analytics_workspace_retention_in_days
  identity                      = var.log_analytics_workspace_identity
  local_authentication_disabled = var.log_analytics_workspace_local_authentication_disabled
  tags                          = merge(local.tags, { resource_name = module.resource_names["log_analytics_workspace"].standard })

  depends_on = [module.resource_group]
}

module "diagnostic_setting" {
  for_each = var.enable_monitor_diagnostic_setting == true ? toset(["monitor_diagnostic_setting"]) : []
  source   = "terraform.registry.launch.nttdata.com/module_primitive/monitor_diagnostic_setting/azurerm"
  version  = "~> 1.0"

  name                           = module.resource_names["monitor_diagnostic_setting"].standard
  target_resource_id             = module.signalr.signalr_id
  log_analytics_workspace_id     = module.log_analytics_workspace["log_analytics_workspace"].id
  log_analytics_destination_type = var.log_analytics_destination_type
  enabled_log                    = var.enabled_log
  metric                         = var.metric
}

module "metric_alert" {
  for_each            = var.metric_alerts
  source              = "terraform.registry.launch.nttdata.com/module_primitive/monitor_metric_alert/azurerm"
  version             = "~> 1.1.0"
  name                = module.resource_names["metric_alert"].standard
  resource_group_name = each.value.resource_group.name
  scopes              = each.value.scopes
  description         = each.value.description
  frequency           = each.value.frequency
  severity            = each.value.severity
  enabled             = each.value.enabled
  action_group_ids    = module.monitor_action_group[each.value.action_groups[0]].action_group_ids[0]
  webhook_properties  = each.value.webhook_properties

  criteria = each.value.criterias

  dynamic_criteria = each.value.dynamic_criteria
  depends_on       = [module.resource_group, module.monitor_action_group]

}

# This module is used to create an Azure Monitor Action Group.
module "monitor_action_group" {
  for_each = var.monitor_action_group
  source   = "terraform.registry.launch.nttdata.com/module_primitive/monitor_action_group/azurerm"
  version  = "~> 1.0.0"

  action_group_name   = each.key
  resource_group_name = each.value.resource_group_name
  short_name          = each.value.short_name
  tags                = each.value.tags
  arm_role_receivers  = each.value.arm_role_receivers
  email_receivers     = each.value.email_receivers
  depends_on          = [module.resource_group]
}
