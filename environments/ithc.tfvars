address_space           = ["10.101.2.64/26"]
subnet_address_prefixes = ["10.101.2.64/27", "10.101.2.96/27"]

route_table = [
  [
    {
      name                   = "azure_control_plane"
      address_prefix         = "51.145.56.125/32"
      next_hop_type          = "Internet"
      next_hop_in_ip_address = null
    }
  ],
  local.cft_routing_rules["ithc"],
  local.cft_routing_rules["prod"],
  local.sds_routing_rules["ithc"]
]

log_analytics_workspace_name = "hmcts-nonprod"
log_analytics_workspace_rg   = "oms-automation"
ping_tests = [
  {
    pingTestName = "apim-service"
    pingTestURL  = "https://hmi-apim.ithc.platform.hmcts.net/health/liveness"
    pingText     = "&#x22;status&#x22;&#x3A;&#x20;&#x22;Up&#x22;" # xml encoding
  }
]
environment = "ithc"
