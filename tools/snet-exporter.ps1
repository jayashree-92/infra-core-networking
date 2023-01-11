$outputfinal = @()
Get-AzSubscription | Foreach-Object {
    $sub = Set-AzContext -SubscriptionId $_.SubscriptionId
    $vnets = Get-AzVirtualNetwork

    foreach ($vnet in $vnets) {
        foreach ($snet in $vnet.Subnets) {
            echo $snet
            $outputfinal += [PSCustomObject]@{
                Subscription                 = $sub.Subscription.Name
                SubscriptionId               = $sub.Subscription.Id
                Location                     = $vnet.Location
                Name                         = $vnet.Name
                VnetAddressPrefixes          = $vnet.AddressSpace.AddressPrefixes.Split(" ")
                SubnetName                   = $snet.Name
                SubnetAddressPrefix          = $snet.AddressPrefix.Split(" ")
                RTDisableBgpRoutePropagation = $snet.RouteTable.DisableBgpRoutePropagation
                RouteTable                   = $snet.RouteTable.Id
                NSG                          = $snet.NetworkSecurityGroup.Id
            }
        }
    }
}

$outputfinal | Export-Csv -Path "snets.csv"  -NoTypeInformation