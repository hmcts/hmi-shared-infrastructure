location                = "uksouth"
product                 = "hmi-sharedinfra"
address_space           = ["10.101.1.0/26"]
subnet_address_prefixes = ["10.101.1.0/27", "10.101.1.32/27"]
route_table = {
  name = "ss_aks"
  address_prefix = "10.140.15.250/32"
  next_hop_type = "VirtualAppliance"
  next_hop_in_ip_address = "10.10.200.36"
  }
tags = {
    "businessarea":"cross-cutting",
    "application":"hearing-management-interface",
    "environment":"sbox"
  }
