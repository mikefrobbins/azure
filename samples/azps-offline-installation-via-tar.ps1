# Download and install the Az PowerShell module via tar archive from GitHub

<#
    Author:        Mike F. Robbins
    Website:       https://mikefrobbins.com/
#>

# Define path for destination location (change as necessary)
$downloadFolderPath = "$home/Downloads"

# Verify download folder exists
if (-not (Test-Path -Path $downloadFolderPath -PathType Container)) {
    New-Item -Path $downloadFolderPath -ItemType Directory
}

# Determine the source tar file to download
$tarSourceUrl = (
    Invoke-RestMethod -Uri https://api.github.com/repos/azure/azure-powershell/releases/latest |
    Select-Object -ExpandProperty assets | Where-Object content_type -eq 'application/x-gzip'
).browser_download_url

# Store source and destination filenames in variables (do not change)
$fileName = Split-Path -Path $tarSourceUrl -Leaf
$downloadFilePath = Join-Path -Path $downloadFolderPath -ChildPath $fileName

# Download the tar file from GitHub
Invoke-WebRequest -Uri $tarSourceUrl -OutFile $downloadFilePath

# Unblock the downloaded file on Windows
if ($PSVersionTable.PSVersion.Major -le 5 -or $IsWindows -eq $true) {
    Unblock-File -Path $downloadFilePath
}

# Extract the tar archive
tar zxf $downloadFilePath -C $downloadFolderPath

# Install the Az module from the extracted files
.$downloadFolderPath/InstallModule.ps1
