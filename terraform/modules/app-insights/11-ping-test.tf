resource "azurerm_application_insights_web_test" "ping_test" {

  name                    = "tf-test-appinsights-webtest"
  location                = var.location
  resource_group_name     = var.resource_group
  application_insights_id = azurerm_application_insights.app_insights.id
  kind                    = "ping"
  frequency               = 300
  timeout                 = 120
  enabled                 = true
  geo_locations           = ["emea-nl-ams-azr", "emea-ru-msa-edge", "emea-se-sto-edge"]
  configuration           = templatefile("../../modules/app-insights/ping-test.tmpl", { url = "${var.health_check_url}" })
}
