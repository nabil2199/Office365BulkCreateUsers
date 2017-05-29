<#
User creation
OCWS
Nabil LAKHNACHFI
BSD 3-Clause License
#>

param([string]$userCsv = "C:\Sources\Liste_Utilisateurs_creation.csv")

#Setting Account SKU Id for tenant
$MSOLSKUid=(Get-MsolAccountSku).accountskuid

#User CSV loading
$usersList = $null
$usersList = Import-Csv $userCsv
$count = $usersList.count
Write-Host "User count within CSV file=" $count
Write-Host ""

foreach ($user in $usersList)
{
    Write-Host -NoNewline "creation de l'utilisateur: "; Write-Host -NoNewline -ForegroundColor Cyan $user.DisplayName; Write-Host -NoNewline " avec le mot de passe "; Write-Host -ForegroundColor Green $user.Password
#Creating user
    New-MsolUser -DisplayName $user.DisplayName -FirstName $user.FirstName -LastName $user.LastName -UserPrincipalName $user.UserPrincipalName -UsageLocation "Fr" -Password $user.Password
#Assigning license to user
    Set-MsolUserLicense -UserPrincipalName $user.UserPrincipalName -AddLicenses $MSOLSKUid
#Setting user password without forced change
    Set-MsolUserPassword -UserPrincipalName $user.UserPrincipalName -ForceChangePassword $false -NewPassword $user.Password 
}