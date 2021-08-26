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
log_analytics_workspace_name = "hmcts-sandbox"
log_analytics_workspace_rg   = "oms-automation"
ping_tests = [
  {
    pingTestName = "apim-service"
    pingTestURL  = "https://hmi-apim.sandbox.platform.hmcts.net/health/liveness"
    pingText     = "&#x22;status&#x22;&#x3A;&#x20;&#x22;Up&#x22;" # xml encoding
  },
  {
    pingTestName = "hmi-casehqemulator"
    pingTestURL  = "https://hmi-apim.sandbox.platform.hmcts.net/hmi/emulator-health"
    pingText     = ""
  },
  {
    pingTestName = "hmi-pact"
    pingTestURL  = "https://hmi-apim.sandbox.platform.hmcts.net/hmi/pact-health"
    pingText     = ""
  }
]
environment = "sbox"