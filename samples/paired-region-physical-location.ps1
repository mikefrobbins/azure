<# 
This PowerShell script retrieves and filters Azure locations to only include those within the
"US" geography group. It selects specific properties of each location: the location name, its
physical location, and the paired region's name and physical location. The script achieves this by
first storing all Azure locations in a variable, then using Where-Object to filter the results and
Select-Object to format the output with the desired properties, including custom expressions to
extract and match the paired regions' physical locations.
#>

(Get-AzLocation -OutVariable locations) |
Where-Object GeographyGroup -match 'US' |
Select-Object -Property Location, PhysicalLocation,
                        @{Name='PairedRegion';Expression={$_.PairedRegion.Name}},
                        @{Name='PairedRegionPhysicalLocation';Expression={(
                            $locations |
                            Where-Object location -eq $_.PairedRegion.Name).PhysicalLocation}
                        }
