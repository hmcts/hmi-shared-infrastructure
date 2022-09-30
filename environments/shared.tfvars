location      = "uksouth"
project       = "hmi-sharedinfra"
support_email = "hmi-team@HMCTS.NET"
apim_nsg_rules = [
  { name = "ManagementEndpointForAzurePortalAndPowershellInbound" },
  { name = "SecureClientCommunicationToAPIManagementInbound" },
  { name = "DependencyOnRedisCacheInbound" },
  { name = "AzureInfrastructureLoadBalancer" },
  { name = "DependencyOnAzureStorageOutbound" },
  { name = "DependencyOnAzureSQLOutbound" },
  { name = "DependencyForLogToEventHubPolicyOutbound" },
  { name = "DependencyOnRedisCacheOutbound" },
  { name = "PublishDiagnosticLogsAndMetrics433Outbound" },
  { name = "PublishDiagnosticLogsAndMetrics1200Outbound" },
  { name = "PublishDiagnosticLogsAndMetrics1886Outbound" },
  { name = "AuthenticateToAzureActiveDirectory80Outbound" },
  { name = "AuthenticateToAzureActiveDirectory433Outbound" }
]
apim_rules = {
  ManagementEndpointForAzurePortalAndPowershellInbound = ["Inbound", "Allow", "Tcp", "*", "3443", "ApiManagement", "VirtualNetwork"]
  SecureClientCommunicationToAPIManagementInbound      = ["Inbound", "Allow", "Tcp", "*", "443", "Internet", "AzureFrontDoor.Backend"]
  DependencyOnRedisCacheInbound                        = ["Inbound", "Allow", "Tcp", "*", "6381-6383", "VirtualNetwork", "VirtualNetwork"]
  AzureInfrastructureLoadBalancer                      = ["Inbound", "Allow", "Tcp", "*", "*", "AzureLoadBalancer", "VirtualNetwork"]
  DependencyOnAzureStorageOutbound                     = ["Outbound", "Allow", "Tcp", "*", "443", "VirtualNetwork", "Storage"]
  DependencyOnAzureSQLOutbound                         = ["Outbound", "Allow", "Tcp", "*", "1443", "VirtualNetwork", "Sql"]
  DependencyForLogToEventHubPolicyOutbound             = ["Outbound", "Allow", "Tcp", "*", "5671-5672", "VirtualNetwork", "EventHub"]
  DependencyOnRedisCacheOutbound                       = ["Outbound", "Allow", "Tcp", "*", "6381-6383", "VirtualNetwork", "VirtualNetwork"]
  PublishDiagnosticLogsAndMetrics433Outbound           = ["Outbound", "Allow", "Tcp", "*", "443", "VirtualNetwork", "AzureMonitor"]
  PublishDiagnosticLogsAndMetrics1200Outbound          = ["Outbound", "Allow", "Tcp", "*", "12000", "VirtualNetwork", "AzureMonitor"]
  PublishDiagnosticLogsAndMetrics1886Outbound          = ["Outbound", "Allow", "Tcp", "*", "1886", "VirtualNetwork", "AzureMonitor"]
  AuthenticateToAzureActiveDirectory80Outbound         = ["Outbound", "Allow", "Tcp", "*", "80", "VirtualNetwork", "AzureActiveDirectory"]
  AuthenticateToAzureActiveDirectory433Outbound        = ["Outbound", "Allow", "Tcp", "*", "443", "VirtualNetwork", "AzureActiveDirectory"]
}

sds_routing_rules = {

  "sbox" = [
    {
      name                   = "ss_sbox_aks"
      address_prefix         = "0.0.0.0/0"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.10.200.36"
    }
  ]
  "dev" = [
    {
      name                   = "ss_dev_aks"
      address_prefix         = "0.0.0.0/0"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.11.72.36"
    }
  ]
  "test" = [
    {
      name                   = "ss_test_aks"
      address_prefix         = "0.0.0.0/0"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.11.72.36"
    }
  ]
  "stg" = [
    {
      name                   = "ss_stg_aks"
      address_prefix         = "10.148.0.0/18"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.11.8.36"
    }
  ]
  "prod" = [
    {
      name                   = "ss_prod_aks"
      address_prefix         = "10.144.0.0/18"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.11.8.36"
    }
  ]
  "ithc" = [
    {
      name                   = "ss_ithc_aks"
      address_prefix         = "10.143.0.0/18"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.11.72.36"
    }
  ]
}

cft_routing_rules = {
  "perftest" = [
    {
      name                   = "cft_perftest_aks"
      address_prefix         = "10.48.64.0/18"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.11.72.36"
    }
  ]
  "aat" = [
    {
      name                   = "cft_aat_aks"
      address_prefix         = "10.10.128.0/18"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.11.72.36"
    }
  ]
  "prod" = [
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
  "ithc" = [
    {
      name                   = "cft_ithc_aks"
      address_prefix         = "10.11.192.0/18"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.11.72.36"
    }
  ]
}