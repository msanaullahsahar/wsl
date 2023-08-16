clear
# Check if the script is running as administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Please run the script again as administrator."
    exit
}
# Specify the base directory path
$baseDirectory = "C:\Users\$env:UserName\Documents"
# Combine the base directory with the desired directory name
$wslDistroStoragePath = Join-Path -Path $baseDirectory -ChildPath "wslDistroStorage"
# Check if the directory exists
if (-not (Test-Path -Path $wslDistroStoragePath -PathType Container)) {
    # Directory doesn't exist, create it
    New-Item -ItemType Directory -Path $wslDistroStoragePath -Force
    Write-Host "wslDistroStorage directory created."
} else {
    Write-Host "wslDistroStorage directory already exists. No action required."
}

# Array of choices
$choices=("Alma Linux", "Alpine Linux", "Amazon Linux", "Arch Linux", "CentOS", "Clear Linux", "Debian", "Fedora", "Neuro Debian", "Oracle Linux", "openSUSE", "Red Hat", "Rocky Linux", "Ubuntu")

$codeNames=("almalinux", "alpine", "amazonlinux", "archlinux", "centos-stream-9", "clearlinux", "debian", "fedora", "neurodebian", "oraclelinux", "opensuse", "redhat", "rockylinux", "ubuntu")

# Display the choices
Write-Host "`r`n"
Write-Host ":: Linux OS Selection ::" -ForegroundColor red -BackgroundColor white
Write-Host "`r`n"

# Display the choices
Write-Host "Choose the OS that you have previously downloaded:"
Write-Host "`r`n"
for ($i = 0; $i -lt $choices.Length; $i++) {
    Write-Host ("[$($i+1)] $($choices[$i])")
}
Write-Host "`r`n"
# Ask user to select an option
$selectedOption = Read-Host "Enter the number of your choice [1-14]"

# Validate user input
if ([int]$selectedOption -ge 1 -and [int]$selectedOption -le 14) {
    $OsName = $codeNames[[int]$selectedOption - 1]
    Write-Host "You selected: $($choices[[int]$selectedOption - 1])"
    Write-Host "Corresponding codename: $OsName"
	Write-Host "$selectedOption"
	# Create a directory with OsName.
	New-Item -ItemType Directory -Path "C:\Users\$env:UserName\Documents\wslDistroStorage\$OsName" -Force
	# Import docker image to WSL Storage.
	wsl --import "$OsName" "C:\Users\$env:UserName\Documents\wslDistroStorage\$OsName" "C:\temp\$OsName.tar"
	# Install and run your OS
	wsl -d $OsName
	}

} else {
    Write-Host "Invalid choice. Please run the script again and enter a number between 1 and 14." -ForegroundColor red -BackgroundColor white
}
