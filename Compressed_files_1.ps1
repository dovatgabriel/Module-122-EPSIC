Import-Module ActiveDirectory

# Path of the csv file
$path = "C:\Users\Administrator\Downloads\Users_1.csv"

# Import content from the csv file's path
$csvContent = Import-Csv -Path $path

# Create an array for all organization units that are in the csv file
$organizationUnits = @()

# For each line of csv content (therefore for each employee) :
foreach ($line in $csvContent) {
    # Get employee's OU's path
    $organizationUnitPath = $line.Ou
    
    # Check if employee's OU isn't already in the organization units array
    if (-not ($organizationUnits -contains $organizationUnitPath)) {
        # If it doesn't : then insert it into the array
        $organizationUnits += $organizationUnitPath
    }
}

# Create an array for all users
$organizationUnitsUsers = @()

# For each organization unit of the organization units array
foreach ($organizationUnitPath in $organizationUnits) {
    # Get organization unit's users
    $organizationUnitUsers = Get-ADUser -Filter * -SearchBase $organizationUnitPath
    
    # Add each organization unit user in the all organization units users array
    foreach($organizationUnitUser in $organizationUnitUsers) {
        $organizationUnitsUsers += $organizationUnitUsers
    }
}

# Define backup's location path
$backupLocation = "C:\Workspace\Back_up"

# If the directory doesn't exist :
if (-not (Test-Path $backupLocation -PathType Container)) {
    # Then create it
    New-Item -ItemType Directory -Path $backupLocation
    Write-Host "Backup's directory didn't exist: it has been created"
}

# Get current date
$currentDate = Get-Date -Format "dd-MM-yyyy"

# Specify the paths
$csvFilePath = "$backupLocation\$currentDate.csv"
$zipFilePath = "$backupLocation\$currentDate.zip"

# Export users from the all organization units users array to the csv file
$organizationUnitsUsers | Export-Csv -Path $csvFilePath -NoTypeInformation

# Compress the CSV file into a ZIP file
Compress-Archive -Path $csvFilePath -DestinationPath $zipFilePath

# Remove the original CSV file so we keep only the zip file
Remove-Item $csvFilePath

# Show a message confirming that the backup has been created
Write-Host "Backup is now saved at location $zipFilePath"
