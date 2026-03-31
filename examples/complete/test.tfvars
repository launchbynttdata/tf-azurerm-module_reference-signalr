action_group = {
  name       = "test-alerts"
  short_name = "testalert"
  email_receivers = [
    {
      name                    = "oncall"
      email_address           = "test@example.com"
      use_common_alert_schema = true
    }
  ]
}

sku_name = "Premium_P1"

resource_number = "001"

metric_alerts = {
  "high-connection-count" = {
    description = "Alert when SignalR connection count is high"
    severity    = 2
    criteria = [
      {
        metric_namespace = "Microsoft.SignalRService/SignalR"
        metric_name      = "ConnectionCount"
        aggregation      = "Average"
        operator         = "GreaterThan"
        threshold        = 500
      }
    ]
  }
}

live_trace_enabled = true

enable_monitor_autoscale_setting = true
autoscale_enabled                = true
autoscale_profiles = [
  {
    name = "defaultProfile"
    capacity = {
      default = 1
      maximum = 5
      minimum = 1
    }
    rules = [
      {
        metric_trigger = {
          metric_name      = "ConnectionCount"
          operator         = "GreaterThan"
          statistic        = "Average"
          time_aggregation = "Average"
          time_grain       = "PT1M"
          time_window      = "PT5M"
          threshold        = 500
        }
        scale_action = {
          cooldown  = "PT5M"
          direction = "Increase"
          type      = "ChangeCount"
          value     = "1"
        }
      },
      {
        metric_trigger = {
          metric_name      = "ConnectionCount"
          operator         = "LessThan"
          statistic        = "Average"
          time_aggregation = "Average"
          time_grain       = "PT1M"
          time_window      = "PT5M"
          threshold        = 100
        }
        scale_action = {
          cooldown  = "PT5M"
          direction = "Decrease"
          type      = "ChangeCount"
          value     = "1"
        }
      }
    ]
  }
]
