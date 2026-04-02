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

  logical_product_family  = var.logical_product_family
  logical_product_service = var.logical_product_service
  environment             = var.environment
  environment_number      = var.environment_number
  resource_number         = var.resource_number

  signalr_location     = var.region
  cors_allowed_origins = ["*"]
  sku_name             = var.sku_name
  sku_capacity         = var.sku_capacity
  service_mode         = var.service_mode
  upstream_endpoint    = var.upstream_endpoint
  network_acl          = var.network_acl
  private_endpoints    = var.private_endpoints

  enable_log_analytics_workspace            = true
  log_analytics_workspace_sku               = var.log_analytics_workspace_sku
  log_analytics_workspace_retention_in_days = var.log_analytics_workspace_retention_in_days
  log_analytics_workspace_identity          = var.log_analytics_workspace_identity
  log_analytics_destination_type            = var.log_analytics_destination_type
  resource_group_name                       = var.resource_group_name
  enable_monitor_diagnostic_setting         = true
  enabled_log                               = var.enabled_log
  metric                                    = var.metric
  live_trace_enabled                        = var.live_trace_enabled

  enable_monitor_autoscale_setting = var.enable_monitor_autoscale_setting
  autoscale_enabled                = var.autoscale_enabled
  autoscale_profiles               = var.autoscale_profiles
  autoscale_notification           = var.autoscale_notification
  autoscale_predictive             = var.autoscale_predictive

  action_group     = var.action_group
  action_group_ids = var.action_group_ids
  metric_alerts    = var.metric_alerts

  tags = local.tags
}
