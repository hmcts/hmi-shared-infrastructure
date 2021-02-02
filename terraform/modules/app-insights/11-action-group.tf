module "hmi-action-group" {
  source   = "github.com/hmcts/cnp-module-action-group"
  location = "global"
  env      = var.environment

  resourcegroup_name     = var.resource_group
  action_group_name      = "hmi-support"
  short_name             = "hmi-support"
  email_receiver_name    = "HMI Support Mailing List"
  email_receiver_address = var.support_email
}