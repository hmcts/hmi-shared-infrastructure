location                = "uksouth"
product                 = "hmi-sharedinfra"
address_space           = ["10.101.1.0/26"]
subnet_address_prefixes = ["10.101.1.0/27", "10.101.1.32/27"]
route_table = [
  {
    name                   = "ss_sbox_aks"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.10.200.36"
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
  "environment" : "sandbox"
}
log_analytics_workspace_name = "hmcts-sandbox"
log_analytics_workspace_rg   = "oms-automation"
ping_tests = [
  {
    name             = "hmi-apim"
    health_check_url = "https://hmi-apim.sandbox.platform.hmcts.net/status-0123456789abcdef"
  },
  {
    name             = "hmi-casehqemulator"
    health_check_url = "https://hmi-apim.sandbox.platform.hmcts.net/hmi/emulator-health"
  },
  {
    name             = "hmi-pact"
    health_check_url = "https://hmi-apim.sandbox.platform.hmcts.net/hmi/pact-health"
  }
]