location                = "uksouth"
product                 = "hmi-sharedinfra"
address_space           = ["10.101.1.128/26"]
subnet_address_prefixes = ["10.101.1.128/27", "10.101.1.160/27"]
health_check_url        = "http://microsoft.com"
route_table = {
  name = "default"
  address_prefix = "0.0.0.0"
  next_hop_type = "VirtualAppliance"
  next_hop_in_ip_address = "10.11.72.36"
  }
tags = {
    "businessarea":"cross-cutting",
    "application":"hearing-management-interface",
    "environment":"test"
  }
  