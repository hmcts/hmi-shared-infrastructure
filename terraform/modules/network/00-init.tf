provider "azurerm" {
  subscription_id = var.log_analytics_subscription_id
  alias           = "log-analytics-subscription"
}