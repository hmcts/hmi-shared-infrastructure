resource "azurerm_template_deployment" "web-test" {
  name                = "web-test-${format("%02d", count.index)}"
  resource_group_name = var.resource_group
  deployment_mode     = "Incremental"
  count               = length(var.ping_tests)
  parameters = {
    appInsightsName = azurerm_application_insights.app_insights.name
    pingTestName    = "${lookup(var.ping_tests[count.index], "pingTestName")}-${var.environment}"
    pingTestURL     = lookup(var.ping_tests[count.index], "pingTestURL")
    pingText        = lookup(var.ping_tests[count.index], "pingText")
    actionGroupId   = azurerm_monitor_action_group.hmi-action-group.id
    location        = var.location
    severity        = var.environment == "sbox" || var.environment == "dev" || var.environment == "test" ? 3 : 0
    environment     = var.tags.environment
  }
  template_body = <<DEPLOY
{
  "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "appInsightsName": {
      "type": "string"
    },
    "pingTestName": {
      "type": "string"
    },
    "pingTestURL": {
      "type": "string"
    },
    "pingText": {
      "type": "string",
      "defaultValue": ""
    },
    "actionGroupId": {
      "type": "string"
    },
    "location": {
      "type": "string"
    }, 
    "severity": {
      "type": "string"
    },
    "environment": {
      "type": "string"
    }
  },
  "variables": {
    "pingTestName": "[concat('PingTest-', toLower(parameters('pingTestName')))]",
    "pingAlertRuleName": "[concat('PingAlert-', toLower(parameters('pingTestName')), '-', toLower(parameters('appInsightsName')))]"
  },
  "resources": [
    {
      "name": "[variables('pingTestName')]",
      "type": "Microsoft.Insights/webtests",
      "apiVersion": "2014-04-01",
      "location": "[parameters('location')]",
      "tags": {
        "[concat('hidden-link:', resourceId('Microsoft.Insights/components', parameters('appInsightsName')))]": "Resource",
        "application": "hearings-management-interface",
        "businessarea": "cross-cutting",
        "environment": "[parameters('environment')]"
      },
      "properties": {
        "Name": "[variables('pingTestName')]",
        "Description": "Basic ping test",
        "Enabled": true,
        "Frequency": 300,
        "Timeout": 120,
        "Kind": "ping",
        "RetryEnabled": true,
        "Locations": [
            {
                "Id": "emea-nl-ams-azr"
            },
            {
                "Id": "emea-ru-msa-edge"
            },
            {
                "Id": "emea-se-sto-edge"
            },
            {
                "Id": "emea-gb-db3-azr"
            },
            {
                "Id": "emea-fr-pra-edge"
            }
        ],
        "Configuration": {
          "WebTest": "[concat('<WebTest Name=\"', variables('pingTestName'), '\" Enabled=\"True\" CssProjectStructure=\"\" CssIteration=\"\" Timeout=\"120\" WorkItemIds=\"\" xmlns=\"http://microsoft.com/schemas/VisualStudio/TeamTest/2010\" Description=\"\" CredentialUserName=\"\" PreAuthenticate=\"True\" Proxy=\"default\" StopOnError=\"False\" RecordedResultFile=\"\" ResultsLocale=\"\"><Items><Request Method=\"GET\" Version=\"1.1\" Url=\"', parameters('pingTestURL'), '\" ThinkTime=\"0\" Timeout=\"300\" ParseDependentRequests=\"True\" FollowRedirects=\"True\" RecordResult=\"True\" Cache=\"False\" ResponseTimeGoal=\"0\" Encoding=\"utf-8\" ExpectedHttpStatusCode=\"200\" ExpectedResponseUrl=\"\" ReportingName=\"\" IgnoreHttpStatusCode=\"False\" /></Items><ValidationRules><ValidationRule Classname=\"Microsoft.VisualStudio.TestTools.WebTesting.Rules.ValidationRuleFindText, Microsoft.VisualStudio.QualityTools.WebTestFramework, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a\" DisplayName=\"Find Text\" Description=\"Verifies the existence of the specified text in the response.\" Level=\"High\" ExecutionOrder=\"BeforeDependents\"><RuleParameters><RuleParameter Name=\"FindText\" Value=\"', parameters('pingText'),'\"/><RuleParameter Name=\"IgnoreCase\" Value=\"False\" />  <RuleParameter Name=\"UseRegularExpression\" Value=\"False\" /><RuleParameter Name=\"PassIfTextFound\" Value=\"True\" /></RuleParameters></ValidationRule></ValidationRules></WebTest>')]"
        },
        "SyntheticMonitorId": "[variables('pingTestName')]"
      }
    },
    {
      "name": "[variables('pingAlertRuleName')]",
      "type": "Microsoft.Insights/metricAlerts",
      "apiVersion": "2018-03-01",
      "location": "global",
      "dependsOn": [
        "[resourceId('Microsoft.Insights/webtests', variables('pingTestName'))]"
      ],
      "tags": {
        "[concat('hidden-link:', resourceId('Microsoft.Insights/components', parameters('appInsightsName')))]": "Resource",
        "[concat('hidden-link:', resourceId('Microsoft.Insights/webtests', variables('pingTestName')))]": "Resource",
		"application": "hearings-management-interface",
		"businessarea": "cross-cutting",
		"environment": "[parameters('environment')]"
      },
      "properties": {
        "description": "Alert for web test",
        "severity": "[parameters('severity')]",
        "enabled": true,
        "scopes": [
          "[resourceId('Microsoft.Insights/webtests',variables('pingTestName'))]",
          "[resourceId('Microsoft.Insights/components',parameters('appInsightsName'))]"
        ],
        "evaluationFrequency": "PT1M",
        "windowSize": "PT5M",
        "criteria": {
          "odata.type": "Microsoft.Azure.Monitor.WebtestLocationAvailabilityCriteria",
          "webTestId": "[resourceId('Microsoft.Insights/webtests', variables('pingTestName'))]",
          "componentId": "[resourceId('Microsoft.Insights/components', parameters('appInsightsName'))]",
          "failedLocationCount": 2
        },
        "actions": [
          {
            "actionGroupId": "[parameters('actionGroupId')]"
          }
        ]
      }
    }
  ]
}
DEPLOY
}