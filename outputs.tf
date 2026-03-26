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

output "signalr_id" {
  value = module.signalr.signalr_id
}

output "signalr_name" {
  value = module.signalr.signalr_name
}

output "location" {
  value = module.signalr.location
}

output "resource_group_name" {
  value = module.signalr.resource_group_name
}

output "autoscale_setting_id" {
  description = "The ID of the Monitor Autoscale Setting, if created."
  value       = var.enable_monitor_autoscale_setting ? module.monitor_autoscale_setting["monitor_autoscale_setting"].id : null
}

output "autoscale_setting_name" {
  description = "The name of the Monitor Autoscale Setting, if created."
  value       = var.enable_monitor_autoscale_setting ? module.monitor_autoscale_setting["monitor_autoscale_setting"].name : null
}

output "action_group_id" {
  description = "The ID of the Monitor Action Group, if created."
  value       = var.action_group != null ? module.monitor_action_group[0].action_group_id : null
}

output "action_group_name" {
  description = "The name of the Monitor Action Group, if created."
  value       = var.action_group != null ? module.monitor_action_group[0].action_group_name : null
}

output "metric_alert_ids" {
  description = "Map of alert name to resource ID for all created metric alerts."
  value       = { for k, v in module.monitor_metric_alert : k => v.metric_alert_id }
}
