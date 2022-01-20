module "app-insights" {
  source         = "../modules/app-insights"
  environment    = var.environment
  resource_group = azurerm_resource_group.rg.name
  location       = azurerm_resource_group.rg.location
  project        = var.product
  support_email  = var.support_email
  ping_tests     = var.ping_tests
  tags           = local.common_tags
}