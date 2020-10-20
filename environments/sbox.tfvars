location                = "uksouth"
product                 = "hmi-sharedinfra"
address_space           = ["10.101.1.0/26"]
subnet_address_prefixes = ["10.101.1.0/27", "10.101.1.32/27"]
health_check_url        = "https://hmi-apim.sandbox.platform.hmcts.net/health/liveness"
route_table = {
  name = "default"
  address_prefix = "0.0.0.0"
  next_hop_type = "VirtualAppliance"
  next_hop_in_ip_address = "10.10.200.36"
  }
tags = {
    "businessarea":"cross-cutting",
    "application":"hearing-management-interface",
    "environment":"sandbox"
  }
