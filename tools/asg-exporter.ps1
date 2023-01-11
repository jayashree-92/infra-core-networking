$results = @()

# Connect to Azure
# Connect-AzAccount

# Get a list of all the subscriptions the user has access to
$subscriptions = Get-AzSubscription | Select-Object -ExpandProperty Id

# Iterate through each subscription
foreach ($subscription in $subscriptions) {
    # Set the current subscription
    Set-AzContext -SubscriptionId $subscription

    # Get a list of all the Application Security Groups
    $asgs = Get-AzApplicationSecurityGroup
    # Get a list of all network interfaces in the subscription
    $interfaces = Get-AzNetworkInterface
    
    # Iterate through each ASG
    foreach ($asg in $asgs) {
        $networkInterfaces = $interfaces.Where({ $_.IpConfigurations.ApplicationSecurityGroups.Where({ $_.Id -eq $asg.Id }) })
        # $networkInterfaces = $interfaces | Where-Object { $_.IpConfigurations.ApplicationSecurityGroups.Id -eq $asg.Id }
        if (!$networkInterfaces) {
            $results += [PSCustomObject]@{
                ASG               = $asg.Name
                NetworkInterfaces = $null
                Subnet            = $null
            }
        }
        else {
            $subnetId = ($networkInterfaces | Select-Object -ExpandProperty IpConfigurations | Select-Object -ExpandProperty Subnet).Id

            # Add the results to the $results array
            $results += [PSCustomObject]@{
                ASG               = $asg.Name
                NetworkInterfaces = ($networkInterfaces.Name -join ", ")
                Subnet            = ($subnetId -split "/")[-1]
            }
        }
    }
}

# Export results to CSV
$results | Export-Csv -Path 'ASG_and_NetworkInterfaces.csv' -NoTypeInformation