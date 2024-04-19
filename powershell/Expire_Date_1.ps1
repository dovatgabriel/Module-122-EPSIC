Import-Module ActiveDirectory

# Path of the csv file
$path = "C:\Users\Administrator\Downloads\Users_1.csv"

# Import content from the csv file's path
$csvContent = Import-Csv -Path $path

# For each line of csv content (therefore for each employee) :
foreach ($line in $csvContent) {
    # Get employee's informations from the csv content
    $username = $line.Username
    $ouPath = $line.Ou

    # Get employee's account's expiration date from the csv content
    $accountExpirationDate = $line.'Expiration-Date'
    # Format it to a correct date time format
    $accountExpirationDate = [dateTime]::ParseExact($accountExpirationDate, "dd.MM.yy", $null)

    # Get employee's account
    $userAccount = Get-ADUser -Filter {SamAccountName -eq $username} -SearchBase $ouPath

    # Check if employee's account exists
    if ($userAccount) {
        # if it does : then update it to update account's expiration date
        Set-ADUser -Identity $userAccount -AccountExpirationDate $accountExpirationDate
        Write-Host "$username 's account's expiration date updated to $accountExpirationDate"
    } else {
        # if it doesn't : show a message that explain that the account doesn't exists
        Write-Host "$username 's account does not exists"
    }
}
