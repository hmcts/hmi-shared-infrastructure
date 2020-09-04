apim_nsg_rules = [
  { name = "APIManagementEndpoint" },
  { name = "HTTP" },
  { name = "HTTPS" },
  { name = "Storage" },
  { name = "SQL" }
]

apim_rules = {
  APIManagementEndpoint = ["Inbound", "Allow", "TCP", "*", "3433", "Management", "ApiManagement", "VirtualNetwork"]
  HTTP                  = ["Inbound", "Allow", "TCP", "*", "80", "Internet", "Internet", "*"]
  HTTPS                 = ["Inbound", "Allow", "TCP", "*", "433", "Internet", "Internet", "*"]
  Storage               = ["Outbound", "Allow", "TCP", "*", "433", "Storage", "VirtualNetwork", "Storage"]
  SQL                   = ["Outbound", "Allow", "TCP", "*", "1443", "SQL", "VirtualNetwork", "Sql"]
}
