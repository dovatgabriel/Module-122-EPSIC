Import-Module ActiveDirectory

# Path of the csv file
$path = "C:\Users\Administrator\Downloads\Users_1.csv"

# Import content from the csv file's path
$csvContent = Import-Csv -Path $path

# For each line of csv content (therefore for each employee) :
foreach ($line in $csvContent) {
    # get employee's OU informations
    $organizationUnitPath = $line.Ou
    $organizationUnitName = [regex]::Match($organizationUnit, 'OU=([^,]+)').Groups[1].Value

    $firstname = $line.FirstName
    $lastname = $line.LastName
    $fullname = $line.Firstname, $line.LastName
    $initials = $line.Initials
    
    $jobtitle = $line.JobTitle
    $department = $line.Departement

    $username = $line.Username
    $email = $line.email
    $password = $line.Password

    # if employee's OU exists :
    if (Get-ADOrganizationalUnit -Filter { Name -eq $organizationUnitName }) {
        # then create employee's account inside it
        New-ADUser -SamAccountName $username -UserPrincipalName $email -Name $firstname -GivenName $firstname -Initials $initials -Title $jobtitle -Department $department -Enabled $true -AccountPassword (ConvertTo-SecureString -AsPlainText $password -Force) -Path $organizationUnitPath
        Write-Host "$fullname 's account created"   
    } else {
        # if it doesn't : show a message that explain that the OU doesn't exists
        Write-Host "$organizationUnitName does not exists"
    }
}
