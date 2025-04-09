// empty.

logical_product_family  = "launch"
logical_product_service = "signalr"
environment             = "test"
environment_number      = "001"
resource_number         = "001"
use_azure_region_abbr   = true

metric_alerts = {
  "SystemErrorsHigh" = {
    description = "Perecentage of system errors are higher than usual"
    dynamic_criteria = {
      alert_sensitivity = "Low"
      metric_name       = "SystemErrors"
      metric_namespace  = "Microsoft.SignalRService/SignalR"
      aggregation       = "Maximum"
      operator          = "GreaterThan"
    }
  }
}
