[CmdletBinding()]
Param (
[Parameter(Mandatory=$true)]
[string] $environment,

[Parameter(Mandatory=$true)]
[string] $larg,

[Parameter(Mandatory=$true)]
[string] $lasboxsubid,

[Parameter(Mandatory=$true)]
[string] $lanonprodsubid,

[Parameter(Mandatory=$true)]
[string] $laprodsubid,

[Parameter(Mandatory=$true)]
[string] $businessArea,

[Parameter(Mandatory=$true)]
[string] $product,

[Parameter(Mandatory=$true)]
[string] $builtFrom
)


if (!(Get-Module -Name Az.MonitoringSolutions)){
    Write-Host "Installing Az.MonitoringSolutions Module..." -ForegroundColor Yellow
    Install-Module -Name Az.MonitoringSolutions -Force -Verbose
    Write-Host "Az.MonitoringSolutions Module successfully installed..."
    } else {
        Write-Host "Az.MonitoringSolutions already installed, skipping" -ForegroundColor Green
    }

$subscriptionName = "dts-sharedservices-"+$environment
$ResourceGroupName = "hmi-sharedinfra-"+$environment+"-rg"

$subscriptionId = (Get-AzSubscription -SubscriptionName $subscriptionName).Id

$tags = @{"application"="hearing-management-interface"; "businessArea"=$businessArea; "builtFrom"=$builtFrom}
$env = ""
if($environment -ieq "sbox"){ $env = "sandbox" } elseif($environment -ieq "dev") { $env = "development" } elseif($environment -ieq "stg") { $env = "staging"} elseif($environment -ieq "prod") { $env = "production" } else { $env = $environment }
$tags += @{"environment"=$env}

if($environment -ieq "sbox")
    { $workspaceName = "hmcts-sandbox"; $workspaceId = "/subscriptions/$lasboxsubid/resourcegroups/$larg/providers/microsoft.operationalinsights/workspaces/hmcts-sandbox" }
    elseif($environment -ieq "dev" -or $environment -ieq "test")
    { $workspaceName = "hmcts-nonprod"; $workspaceId = "/subscriptions/$lanonprodsubid/resourcegroups/$larg/providers/microsoft.operationalinsights/workspaces/hmcts-nonprod" }
    elseif($environment -ieq "stg" -or $environment -ieq "prod")
    { $workspaceName = "hmcts-prod" ; $workspaceId = "/subscriptions/$laprodsubid/resourcegroups/$larg/providers/microsoft.operationalinsights/workspaces/hmcts-prod" }
    else { Write-Host "Workspace not set." }

Write-Host "Starting script"
if(!(Get-AzInsightsPrivateLinkScope -Name "$("hmi-apim-ampls-" + $environment)" -ResourceGroupName $ResourceGroupName -ErrorAction SilentlyContinue)){
    $virtualNetwork = Get-AzVirtualNetwork -ResourceName "$("hmi-sharedinfra-vnet-" + $environment)" -ResourceGroupName $ResourceGroupName
    $subnet = $virtualNetwork | Select-Object -ExpandProperty subnets | Where-Object Name -like 'mgmt-subnet-*'

    Write-Host "Create Azure Monitor Private Link Scope"
    $linkScope=(New-AzInsightsPrivateLinkScope -Location "global" -ResourceGroupName $ResourceGroupName -Name "$("hmi-apim-ampls-" + $environment)")
    New-AzTag -ResourceId $linkScope.Id -Tag $tags
    $appins = (Get-AzApplicationInsights -ResourceGroupName $ResourceGroupName -name "$("hmi-sharedinfra-appins-" + $environment)")

    Write-Host "Add Azure Monitor Resource"
    New-AzInsightsPrivateLinkScopedResource -LinkedResourceId $workspaceId -Name $workspaceName -ResourceGroupName $ResourceGroupName -ScopeName $linkScope.Name
    New-AzInsightsPrivateLinkScopedResource -LinkedResourceId $appins.Id -Name $appins.Name -ResourceGroupName $ResourceGroupName -ScopeName $linkScope.Name

    Write-Host "Set up Private Endpoint Connection"
    $PrivateLinkResourceId = "/subscriptions/"+$subscriptionId+"/resourceGroups/"+$ResourceGroupName+"/providers/microsoft.insights/privateLinkScopes/"+$linkScope.Name
    $linkedResource = Get-AzPrivateLinkResource -PrivateLinkResourceId $PrivateLinkResourceId

    $group = @("azuremonitor")
    $privateEndpointConnection = New-AzPrivateLinkServiceConnection -GroupId $group -Name "$("hmi-privatelink-" + $environment)" -PrivateLinkServiceId $linkScope.Id

    $privateEndpoint = New-AzPrivateEndpoint -ResourceGroupName $ResourceGroupName -Name "$("hmi-privateendpoint-" + $environment)" -Location "uksouth" -Subnet $subnet -PrivateLinkServiceConnection $privateEndpointConnection
    New-AzTag -ResourceId $privateEndpoint.Id -Tag $tags
    New-AzTag -ResourceId $privateEndpoint.NetworkInterfaces.Id -Tag $tags

    Write-Host "Create Private DNS Zones"
    $dnsZones= @('privatelink.oms.opinsights.azure.com', 'privatelink.ods.opinsights.azure.com', 'privatelink.agentsvc.azure-automation.net', 'privatelink.monitor.azure.com')

    $zoneConfigs = @()

    foreach ($_ in $dnsZones) {
        Write-Host "Creating DNS Zone " $_
        $zone = New-AzPrivateDnsZone -ResourceGroupName $ResourceGroupName `
        -Name $_
        New-AzTag -ResourceId $zone.ResourceId -Tag $tags

        $link  = New-AzPrivateDnsVirtualNetworkLink -ResourceGroupName $ResourceGroupName `
        -ZoneName $_ `
        -Name "dnsZoneLink" `
        -VirtualNetworkId $virtualNetwork.Id

        $zoneConfigs += (New-AzPrivateDnsZoneConfig -Name $_ -PrivateDnsZoneId $zone.ResourceId)
    }

    Write-Host "Linking DNS Zones to endpoint..."
    $PrivateDnsZoneGroup = New-AzPrivateDnsZoneGroup -ResourceGroupName $ResourceGroupName `
    -PrivateEndpointName "$("hmi-privateendpoint-" + $environment)" `
    -name "azure-monitor-dns-zone" `
    -PrivateDnsZoneConfig $zoneConfigs -Force

    Write-Host "Finished."

} else {
    Write-Host "Azure Private Link Scope already exists. Exiting."
}
