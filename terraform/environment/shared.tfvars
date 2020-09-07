apim_nsg_rules = [
  { name = "ManagementEndpointForAzurePortalAndPowershellInbound" },
  { name = "ClientCommunicationToAPIManagementInbound" },
  { name = "SecureClientCommunicationToAPIManagementInbound" },
  { name = "DependencyOnRedisCacheInbound" },
  { name = "DependencyOnAzureStorageOutbound" },
  { name = "DependencyOnAzureSQLOutbound" },
  { name = "DependencyForLogToEventHubPolicyOutbound" },
  { name = "DependencyOnRedisCacheOutbound" },
  { name = "PublishDiagnosticLogsAndMetricsOutbound" },
  { name = "AuthenticateToAzureActiveDirectoryOutbound" }
]

apim_rules = {
  ManagementEndpointForAzurePortalAndPowershellInbound = ["Inbound", "Allow", "TCP", "*", "3433", "ApiManagement", "VirtualNetwork"]
  ClientCommunicationToAPIManagementInbound            = ["Inbound", "Allow", "TCP", "*", "80", "Internet", "*"]
  SecureClientCommunicationToAPIManagementInbound      = ["Inbound", "Allow", "TCP", "*", "433", "Internet", "*"]
  DependencyOnRedisCacheInbound                        = ["Inbound", "Allow", "TCP", "*", "6381-6383", "VirtualNetwork", "VirtualNetwork"]
  DependencyOnAzureStorageOutbound                     = ["Outbound", "Allow", "TCP", "*", "433", "VirtualNetwork", "Storage"]
  DependencyOnAzureSQLOutbound                         = ["Outbound", "Allow", "TCP", "*", "1443", "VirtualNetwork", "Sql"]
  DependencyForLogToEventHubPolicyOutbound             = ["Outbound", "Allow", "TCP", "*", "5671", "VirtualNetwork", "EventHub"]
  DependencyOnRedisCacheOutbound                       = ["Outbound", "Allow", "TCP", "*", "6381-6383", "VirtualNetwork", "VirtualNetwork"]
  PublishDiagnosticLogsAndMetricsOutbound              = ["Outbound", "Allow", "TCP", "*", "443,12000,1886", "VirtualNetwork", "AzureMonitor"]
  AuthenticateToAzureActiveDirectoryOutbound           = ["Outbound", "Allow", "TCP", "*", "80,443", "VirtualNetwork", "AzureActiveDirectory"]
}
