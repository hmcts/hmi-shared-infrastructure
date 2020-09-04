apim_nsg_rules = [
  { name = "APIManagementEndpoint" },
  { name = "AllowWWW" },
  { name = "Storage" },
  { name = "SQL" }
]

apim_rules = {
  APIManagementEndpoint = ["Inbound", "Allow", "TCP", "*", "3433", "Management", "ApiManagement", "VirtualNetwork"]
  AllowWWW              = ["Inbound", "Allow", "TCP", "*", ["80", "433"], "Internet", "Internet", "*"]
  Storage               = ["Outbound", "Allow", "TCP", "*", "433", "Storage", "VirtualNetwork", "Storage"]
  SQL                   = ["Outbound", "Allow", "TCP", "*", "1443", "SQL", "VirtualNetwork", "Sql"]
}
