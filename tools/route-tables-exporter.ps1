$outputfinal = @()
foreach ( $Subscription in $(Get-AzSubscription | Where-Object { $_.State -ne "Disabled" }) ) {
    Select-AzSubscription -SubscriptionId $Subscription.SubscriptionId

    $rts = Get-AzureRmroutetable
    foreach ($rt in $rts) {
        $routes = $rt.routes
        foreach ($route in $routes) {
            $Outputtemp = “” | SELECT RTName, RGName, Location, RouteName, AddressPrefix, NextHopType, NextHopIPAddress
            $outputtemp.RTName = $rt.name
            $outputtemp.RGName = $rt.Resourcegroupname
            $outputtemp.location = $rt.location
            $outputtemp.routename = $route.Name
            $outputtemp.AddressPrefix = $route.AddressPrefix
            $outputtemp.nexthoptype = $route.nexthoptype
            $outputtemp.NextHopIPAddress = $route.NextHopIPAddress
            $outputfinal += $outputtemp
        }
    }
    $outputfinal | export-csv ./RouteTables_"$((Get-Date).ToString("yyyyMMdd_HHmmss")).csv" -NoTypeInformation
}