<#
    Author:        Mike F. Robbins
    Website:       https://mikefrobbins.com/
    Prerequisites: Az PowerShell module
#>

# Define VM Name, Resource Group Name, and Region (location)
$location = 'southcentralus'
$resourceGroup = 'MyResourceGroup'
$name = 'testvm-rhel'

# Create resource group if it doesn't already exist
if (-not(Get-AzResourceGroup -ResourceGroupName myResourceGroup -ErrorAction SilentlyContinue -OutVariable rg)) {
    New-AzResourceGroup -Name $resourceGroup -Location $location
} else {
    $resources = Get-AzResource -ResourceGroupName $rg.ResourceGroupName
    Write-Warning -Message "$resourceGroup already exist and may contain other resources!"
}

# Create Azure VM
$vmParams = @{
    ResourceGroupName = $resourceGroup
    Name = $name
    Credential = (Get-Credential)
    Location = $location
    Image = 'RHELRaw8LVMGen2'
    OpenPorts = 22
    PublicIpAddressName = $name
}
New-AzVM @vmParams -OutVariable vm

# Get the public IP address
$vm | Get-AzPublicIpAddress -OutVariable ip

# SSH into the VM
ssh <username>@$($ip.IpAddress)

# Remove the resource group and all resources
if ($resources.count -eq 0) {
    Remove-AzResourceGroup -ResourceGroupName $resourceGroup
} else {
    Write-Warning -Message "Unable to remove $resourceGroup. It contains other resources."
}
