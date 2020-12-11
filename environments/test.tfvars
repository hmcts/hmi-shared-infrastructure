location                = "uksouth"
product                 = "hmi-sharedinfra"
address_space           = ["10.101.1.128/26"]
subnet_address_prefixes = ["10.101.1.128/27", "10.101.1.160/27"]
route_table = [
  {
    name                   = "ss_test_aks"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.11.72.36"
  },
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
  "environment" : "test"
}
log_analytics_workspace_name = "hmcts-nonprod"
