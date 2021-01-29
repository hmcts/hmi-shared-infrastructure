location                = "uksouth"
product                 = "hmi-sharedinfra"
address_space           = ["10.101.1.192/26"]
subnet_address_prefixes = ["10.101.1.192/27", "10.101.1.224/27"]
route_table = [
  {
    name                   = "azure_control_plane"
    address_prefix         = "51.145.56.125/32"
    next_hop_type          = "Internet"
    next_hop_in_ip_address = null
  }
]
tags = {
  "businessarea" : "cross-cutting",
  "application" : "hearing-management-interface",
  "environment" : "staging"
}
log_analytics_workspace_name = "hmcts-prod"
log_analytics_workspace_rg = "oms-automation"
