apim_nsg_rules = [
  { name = "ManagementEndpointForAzurePortalAndPowershellInbound" },
  { name = "ClientCommunicationToAPIManagementInbound" },
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
  ManagementEndpointForAzurePortalAndPowershellInbound = ["Inbound", "Allow", "TCP", "*", "3443", "ApiManagement", "VirtualNetwork"]
  ClientCommunicationToAPIManagementInbound            = ["Inbound", "Allow", "TCP", "*", "80", "Internet", "*"]
  SecureClientCommunicationToAPIManagementInbound      = ["Inbound", "Allow", "TCP", "*", "443", "Internet", "*"]
  DependencyOnRedisCacheInbound                        = ["Inbound", "Allow", "TCP", "*", "6381-6383", "VirtualNetwork", "VirtualNetwork"]
  AzureInfrastructureLoadBalancer                      = ["Inbound", "Allow", "TCP", "*", "*", "AzureLoadBalancer", "VirtualNetwork"]
  DependencyOnAzureStorageOutbound                     = ["Outbound", "Allow", "TCP", "*", "443", "VirtualNetwork", "Storage"]
  DependencyOnAzureSQLOutbound                         = ["Outbound", "Allow", "TCP", "*", "1443", "VirtualNetwork", "Sql"]
  DependencyForLogToEventHubPolicyOutbound             = ["Outbound", "Allow", "TCP", "*", "5671", "VirtualNetwork", "EventHub"]
  DependencyOnRedisCacheOutbound                       = ["Outbound", "Allow", "TCP", "*", "6381-6383", "VirtualNetwork", "VirtualNetwork"]
  PublishDiagnosticLogsAndMetrics433Outbound           = ["Outbound", "Allow", "TCP", "*", "443", "VirtualNetwork", "AzureMonitor"]
  PublishDiagnosticLogsAndMetrics1200Outbound          = ["Outbound", "Allow", "TCP", "*", "12000", "VirtualNetwork", "AzureMonitor"]
  PublishDiagnosticLogsAndMetrics1886Outbound          = ["Outbound", "Allow", "TCP", "*", "1886", "VirtualNetwork", "AzureMonitor"]
  AuthenticateToAzureActiveDirectory80Outbound         = ["Outbound", "Allow", "TCP", "*", "80", "VirtualNetwork", "AzureActiveDirectory"]
  AuthenticateToAzureActiveDirectory433Outbound        = ["Outbound", "Allow", "TCP", "*", "443", "VirtualNetwork", "AzureActiveDirectory"]
}

subnet_delegation = {
  name = "APIM delegations"
  service_delegation = {
    name = "Microsoft.ApiManagement/service"
    actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
    }
  }