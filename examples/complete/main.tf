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

  enable_monitor_diagnostic_setting = true
  enabled_log                       = var.enabled_log
  metric                            = var.metric

  tags = local.tags
}
