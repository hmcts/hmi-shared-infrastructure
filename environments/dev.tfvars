address_space           = ["10.101.1.64/26"]
subnet_address_prefixes = ["10.101.1.64/27", "10.101.1.96/27"]
route_table = [
  {
    name                   = "ss_dev_aks"
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
  "environment" : "development"
}
log_analytics_workspace_name = "hmcts-nonprod"
log_analytics_workspace_rg   = "oms-automation"
ping_tests = [
  {
    pingTestName = "apim-service"
    pingTestURL  = "https://hmi-apim.dev.platform.hmcts.net/status-0123456789abcdef"
    pingText     = ""
  },
  {
    pingTestName = "hmi-casehqemulator"
    pingTestURL  = "https://hmi-apim.dev.platform.hmcts.net/hmi/emulator-health"
    pingText     = ""
  },
  {
    pingTestName = "hmi-pact"
    pingTestURL  = "https://hmi-apim.dev.platform.hmcts.net/hmi/pact-health"
    pingText     = ""
  }
]
