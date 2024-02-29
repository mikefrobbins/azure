# Download and install the Az PowerShell module via tar archive from GitHub

<#
    Author:        Mike F. Robbins
    Website:       https://mikefrobbins.com/
    Prerequisites: Az PowerShell module
#>

# Define paths for source and destination locations (change as necessary)
$downloadPath = "$home/Downloads"

# Verify download folder exists
if (-not (Test-Path -Path $downloadPath -PathType Container)) {
    New-Item -Path $downloadPath
}

# Determine the source tar file to download
$tarFileLocation = (Invoke-RestMethod -Uri https://api.github.com/repos/azure/azure-powershell/releases/latest).assets.where({$_.content_type -eq 'application/x-gzip'}).browser_download_url

# Store source and destination filenames in variables (do not change)
$fileName = Split-Path -Path $tarFileLocation -Leaf
$downloadFileLocation = Join-Path -Path $downloadPath -ChildPath $fileName

# Download the tar file from GitHub
Invoke-WebRequest -Uri $tarFileLocation -OutFile $downloadFileLocation

# Unblock the downloaded file on Windows
if ($PSVersionTable.PSVersion.Major -le 5 -or $IsWindows -eq $true) {
    Unblock-File -Path $downloadFileLocation
}

# Extract the tar archive
tar zxf $downloadFileLocation -C $downloadPath

# Install the Az module from the extracted files
.$downloadPath/InstallModule.ps1
