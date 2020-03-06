#Requires -Modules MSOline

Connect-MsolService

Get-MsolUser -All | Where-Object {$_.UserType -ne "Guest" -and $_.BlockCredential -eq $False -and $_.isLicensed -eq $False} | Sort-Object -Property DisplayName