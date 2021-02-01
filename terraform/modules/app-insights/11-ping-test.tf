resource "azurerm_application_insights_web_test" "ping_test" {
  name                    = "${lookup(var.ping_tests[count.index], "name")}-test-${var.environment}"
  count                   = length(var.ping_tests)
  location                = var.location
  resource_group_name     = var.resource_group
  application_insights_id = azurerm_application_insights.app_insights.id
  kind                    = "ping"
  frequency               = 300
  timeout                 = 120
  enabled                 = true
  geo_locations           = ["emea-nl-ams-azr", "emea-ru-msa-edge", "emea-se-sto-edge"]
  configuration           = templatefile("../../modules/app-insights/ping-test.tmpl", { url = lookup(var.ping_tests[count.index], "health_check_url") })
  tags                    = var.tags
}

resource "azurerm_monitor_metric_alert" "web_alert" {
  name                = "example-metricalert"
  count               = length(var.ping_tests)
  resource_group_name = azurerm_application_insights_web_test.ping_test.resource_group_name
  scopes              = "${element(azurerm_application_insights_web_test.ping_test.*.id, count.index)}"
  description         = "Hello World"

  criteria {
    metric_namespace = "Microsoft.Web/sites"
    metric_name      = "Http5xx"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 5

    dimension {
      name     = "Instance"
      operator = "Include"
      values   = ["*"]
    }
  }

  frequency   = "PT1M"
  window_size = "PT5M"
  severity    = 3

}