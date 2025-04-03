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

locals {
  default_tags = {
    provisioner = "Terraform"
  }

  tags = merge(local.default_tags, var.tags)
}



locals {
  metric_alerts = {
    "alert1" = {
      description = "CPU usage alert"
      frequency   = 5
      severity    = 2
      enabled     = true
      webhook_properties = {
        url = "https://example.com/webhook"
      }
      criteria = {
        threshold = 80
      }
      dynamic_criteria = {
        condition = "greater_than"
      }
    }
  }
}

locals {
  metric_alerts = {
    "alert1" = {
      description        = "CPU usage alert"
      frequency          = 5
      severity           = 2
      enabled            = true
      webhook_properties = {
        url = "https://example.com/webhook"
        auth_token = "abcdef123456"
      }
      criterias = {
        "criteria1" = {
          threshold        = 80
          metric_namespace = "Microsoft.Compute/virtualMachines"
          metric_name      = "Percentage CPU"
          aggregation      = "Average"
          operator         = "GreaterThan"
          dimensions = {
            "dimension1" = {
              operator = "Include"
              values   = ["VM1", "VM2"]
            }
          }
        }
      }
      dynamic_criteria = {
        alert_sensitivity = "High"
        metric_name       = "Network In"
        metric_namespace  = "Microsoft.Network/networkInterfaces"
        aggregation       = "Total"
        operator          = "GreaterThanOrEqual"
        dimensions = {
          "dimension1" = {
            operator = "Include"
            values   = ["NIC1", "NIC2"]
          }
        }
      }
    },
    "alert2" = {
      description        = "Memory Usage Alert"
      frequency          = 10
      severity           = 3
      enabled            = false
      webhook_properties = {
        url = "https://example.com/another_webhook"
        auth_token = "ghijkl789012"
      }
      criterias = {
        "criteria1" = {
          threshold        = 90
          metric_namespace = "Microsoft.Storage/storageAccounts"
          metric_name      = "Available Memory"
          aggregation      = "Maximum"
          operator         = "LessThan"
          dimensions = {
            "dimension1" = {
              operator = "Include"
              values   = ["Storage1"]
            }
          }
        }
      }
      dynamic_criteria = {
        alert_sensitivity = "Medium"
        metric_name       = "Disk Read Bytes"
        metric_namespace  = "Microsoft.Compute/disks"
        aggregation       = "Min"
        operator          = "LessThanOrEqual"
        dimensions = {
          "dimension1" = {
            operator = "Include"
            values   = ["Disk1", "Disk2"]
          }
        }
      }
    }
  }
}



locals {
  monitor_action_groups = {
    "group1" = {
      action_group_name   = "AlertGroup1"
      resource_group_name = "ResourceGroup1"
      short_name          = "AG1"
      tags = {
        environment = "production"
        team        = "devops"
      }
      arm_role_receivers = [
        {
          name = "RoleReceiver1"
          role = "Contributor"
        }
      ]
      email_receivers = [
        {
          email_address = "alert@example.com"
        }
      ]
    }
  }
}
