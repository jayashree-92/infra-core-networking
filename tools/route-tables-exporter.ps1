# Login to Azure
# Connect-AzAccount
$outputfinal = @()

# Get all subscriptions
$subscriptions = Get-AzSubscription | Where-Object { $_.State -ne "Disabled" }

# Loop through each subscription
foreach ($subscription in $subscriptions) {
    # Set the current subscription
    Select-AzSubscription -SubscriptionId $subscription.Id

    # Get all routes in the current subscription
    $rts = Get-AzRouteTable

    # Loop through each route
    foreach ($rt in $rts) {
        $routes = $rt.routes
        foreach ($route in $routes) {
            # Get the route properties
            $outputfinal += [PSCustomObject]@{
                SubscriptionName  = $subscription.Name
                SubscriptionId    = $subscription.Id
                RTName            = $rt.Name
                RGName            = $rt.Resourcegroupname
                Location          = $rt.location
                RouteName         = $route.Name
                AddressPrefix     = $route.AddressPrefix
                NextHopType       = $route.NextHopType
                NextHopIpAddress  = $route.NextHopIpAddress
                ResourceId        = $route.Id
                ProvisioningState = $route.ProvisioningState
            }
        }
    }
}

$outputfinal | export-csv ./RouteTables_"$((Get-Date).ToString("yyyyMMdd_HHmmss")).csv" -NoTypeInformation