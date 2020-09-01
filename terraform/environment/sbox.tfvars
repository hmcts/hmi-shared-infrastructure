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
tags = {
    "businessarea":"cross-cutting",
    "application":"hearing-management-interface",
    "environment":"sbox"
  }