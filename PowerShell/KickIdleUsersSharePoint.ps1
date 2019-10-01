Connect-SPOService -Url "https://thesmartcircle-admin.sharepoint.com"

$UserCredential = Get-Credential

$Session = New-PSSession `
                -ConfigurationName Microsoft.Exchange `
                -ConnectionUri https://outlook.office365.com/powershell-liveid/ `
                -Credential $UserCredential `
                -Authentication Basic `
                -AllowRedirection

Import-PSSession $Session -DisableNameChecking

$ExternalSites = get-sposite `
                    | Where-Object {$_.SharingCapability -eq "ExternalUserSharingOnly"} `
                    | select -Property Url

$ActiveUsers = foreach($Site in $ExternalSites){
    Write-Host "Finding activity for site: " $Site.Url

    Search-UnifiedAuditLog `
        -ObjectIds $Site.Url `
        -StartDate 9/20/2019 `
        -EndDate 9/29/2019 `
        -ResultSize 5000 `
        | select -Property UserIds

    Write-Host "Completed"
    Write-Host
}

$ActiveUsers = $ActiveUsers.UserIds | Sort-Object -Unique

$ApprovedUsers = foreach($Site in $ExternalSites){
    Write-Host "Finding approved users for site: " $Site.Url

    Get-SPOExternalUser -Position 0 -PageSize 50 -SiteUrl $Site.Url `
        | select -Property Email

    Write-Host "Completed"
    Write-Host
}

$ApprovedUsers = $ApprovedUsers.Email | Sort-Object -Unique

#Find inactive externally shared users

$KeepUsers = Compare-Object `
    -ReferenceObject $ActiveUsers `
    -DifferenceObject $ApprovedUsers `
    -IncludeEqual `
    -ExcludeDifferent `
    | select -Property InputObject

$KeepUsers = $KeepUsers.InputObject | Sort-Object -Unique

$RemoveUsers = $ApprovedUsers

foreach($User in $KeepUsers){
    $RemoveUsers = $ApprovedUsers | Where-Object { $_ -ne $User }
}

#Remove-SPOUser 

#Remove-PSSession $Session