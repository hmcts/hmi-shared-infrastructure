address_space           = ["10.101.1.192/26"]
subnet_address_prefixes = ["10.101.1.192/27", "10.101.1.224/27"]
route_table = [
  {
    name                   = "azure_control_plane"
    address_prefix         = "51.145.56.125/32"
    next_hop_type          = "Internet"
    next_hop_in_ip_address = null
  },
  {
    name                   = "ss_stg_aks"
    address_prefix         = "10.148.0.0/18"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.11.8.36"
  },
  {
    name                   = "cft_ithc_aks"
    address_prefix         = "10.11.192.0/18"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.11.72.36"
  },
  {
    name                   = "cft_prod_00_aks"
    address_prefix         = "10.10.128.0/20"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.11.8.36"
  },
  {
    name                   = "cft_prod_01_aks"
    address_prefix         = "10.10.144.0/20"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.11.8.36"
  }
]
log_analytics_workspace_name = "hmcts-prod"
log_analytics_workspace_rg   = "oms-automation"
ping_tests = [
  {
    pingTestName = "apim-service"
    pingTestURL  = "https://hmi-apim.staging.platform.hmcts.net/health/liveness"
    pingText     = "&#x22;status&#x22;&#x3A;&#x20;&#x22;Up&#x22;" # xml encoding
  }
]
environment = "stg"
