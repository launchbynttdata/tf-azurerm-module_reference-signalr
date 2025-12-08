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

module "signalr" {
  source = "../.."

  signalr_location     = var.region
  cors_allowed_origins = ["*"]

  enable_log_analytics_workspace            = true
  log_analytics_workspace_sku               = var.log_analytics_workspace_sku
  log_analytics_workspace_retention_in_days = var.log_analytics_workspace_retention_in_days
  log_analytics_workspace_identity          = var.log_analytics_workspace_identity
  log_analytics_destination_type            = var.log_analytics_destination_type
  resource_group_name                       = var.resource_group_name
  enable_monitor_diagnostic_setting         = true
  enabled_log                               = var.enabled_log
  metric                                    = var.metric

  tags = local.tags
}

module "monitor_action_group" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/monitor_action_group/azurerm"
  version = "~> 1.0.0"

  count               = var.action_group != null ? 1 : 0
  action_group_name   = var.action_group.name
  resource_group_name = var.resource_group_name
  short_name          = var.action_group.short_name
  arm_role_receivers  = var.action_group.arm_role_receivers
  email_receivers     = var.action_group.email_receivers
  tags                = var.tags
}

#  Metric Alert
module "monitor_metric_alert" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/monitor_metric_alert/azurerm"
  version = "~> 2.0"

  for_each            = var.metric_alerts
  name                = each.key
  resource_group_name = var.resource_group_name

  scopes = [module.signalr.signalr_id]

  description = each.value.description
  frequency   = each.value.frequency
  severity    = each.value.severity
  enabled     = each.value.enabled

  action_group_ids = concat(
    var.action_group_ids,
    try(tolist(each.value.action_groups), []),
    var.action_group != null ? [module.monitor_action_group[0].action_group_id] : []
  )

  webhook_properties = lookup(each.value, "webhook_properties", null)
  criteria           = each.value.criteria
  dynamic_criteria   = each.value.dynamic_criteria
}
