location                = "uksouth"
product                 = "hmi-sharedinfra"
address_space           = ["10.101.1.0/26"]
subnet_address_prefixes = ["10.101.1.0/26"]
service_endpoints       = ["Microsoft.Web"]
subnet_delegation = {
  name = "APIM delegations"
  service_delegation = {
    name = "Microsoft.ApiManagement/service"
    actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  } 
route_name = "ss_aks"
route_address_prefix = "10.140.15.250/32"
route_next_hop_type = "VirtualAppliance"
next_hop_in_ip_address = "10.10.200.36"
tags = {
    "businessarea":"cross-cutting",
    "application":"hearing-management-interface",
    "environment":"sbox"
  }