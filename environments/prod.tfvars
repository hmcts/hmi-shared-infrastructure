location                = "uksouth"
product                 = "hmi-sharedinfra"
address_space           = ["10.101.2.0/26"]
subnet_address_prefixes = ["10.101.2.0/27", "10.101.2.32/27"]
health_check_url        = "http://microsoft.com"
tags = {
    "businessarea":"cross-cutting",
    "application":"hearing-management-interface",
    "environment":"production"
  }
