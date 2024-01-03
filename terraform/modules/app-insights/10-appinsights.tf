module "application_insights" {
  source = "git::https://github.com/hmcts/terraform-module-application-insights?ref=main"


  env      = var.env
  product  = var.product
  name     = "${var.project}-appins"
  location = var.location

  resource_group_name = var.resource_group

  common_tags = var.tags
}

moved {
  from = azurerm_application_insights.app_insights
  to   = module.application_insights.azurerm_application_insights.this
}
