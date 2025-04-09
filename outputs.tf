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

output "metric_alerts" {
  value = {
    for key, value in module.metric_alert : key => {
      id   = value.metric_alert_id
      name = value.name
    }
  }
}

output "action_groups" {
  value = {
    for key, value in module.action_group : key => {
      id   = value.action_group_id
      name = value.name
    }
  }
}
