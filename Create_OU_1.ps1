Import-Module ActiveDirectory

# Path of the csv file
$path = "C:\Users\Administrator\Downloads\Users_1.csv"

# Import content from the csv file's path
$csvContent = Import-Csv -Path $path

# Get OU column from the csv content
$organizationUnits = $csvContent.Ou

# for each of the OU from the csv content :
foreach ($organizationUnit in $organizationUnits) {
    # Get OU's name from the csv content
    $organizationUnitName = [regex]::Match($organizationUnit, 'OU=([^,]+)').Groups[1].Value

    # Split OU from the csv content to prepare OU's path recuperation
    $splittedOU = $organizationUnit -split "(?<=OU=|DC=)"

    # Get OU's path
    $organizationUnitPath = "DC=" + ($splittedOU[2..$splittedOU.Count] -join '')

    # Check if OU already exists
    if (-not (Get-ADOrganizationalUnit -Filter {Name -eq $organizationUnitName})) {
        # If it doesn't : then create it
        New-ADOrganizationalUnit -Name $organizationUnitName -Path $organizationUnitPath -ProtectedFromAccidentalDeletion $false
        Write-Host "$organizationUnitName created"
    }
}
