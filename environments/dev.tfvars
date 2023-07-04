address_space           = ["10.101.1.64/26"]
subnet_address_prefixes = ["10.101.1.64/27", "10.101.1.96/27"]

route_table = [
  {
    name                   = "azure_control_plane"
    address_prefix         = "51.145.56.125/32"
    next_hop_type          = "Internet"
    next_hop_in_ip_address = null
  }
]

log_analytics_workspace_name = "hmcts-nonprod"
log_analytics_workspace_rg   = "oms-automation"
ping_tests = [
  {
    pingTestName = "apim-service"
    pingTestURL  = "https://hmi-apim.dev.platform.hmcts.net/health/liveness"
    pingText     = "&#x22;status&#x22;&#x3A;&#x20;&#x22;Up&#x22;" # xml encoding
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
  },
  {
    pingTestName = "hmc-apim-service"
    pingTestURL  = "https://hmi-apim.dev.platform.hmcts.net/hmi/hmc-health"
    pingText     = "&#x22;status&#x22;&#x3A;&#x20;&#x22;Up&#x22;" # xml encoding
  }
]
environment = "dev"