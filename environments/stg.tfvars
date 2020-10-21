location                = "uksouth"
product                 = "hmi-sharedinfra"
address_space           = ["10.101.1.192/26"]
subnet_address_prefixes = ["10.101.1.192/27", "10.101.1.224/27"]
health_check_url        = "http://microsoft.com"
tags = {
    "businessarea":"cross-cutting",
    "application":"hearing-management-interface",
    "environment":"staging"
  }
