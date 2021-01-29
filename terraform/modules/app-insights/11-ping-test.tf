resource "azurerm_application_insights_web_test" "ping_test" {
  name                    = "${lookup(var.ping_tests[count.index], "name")}-${var.environment}-${format("%02d", count.index)}"
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
