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

$activeUsers = foreach($Site in $ExternalSites){
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

$approvedUsers = foreach($Site in $ExternalSites){
    Write-Host "Finding approved users for site: " $Site.Url

    Get-SPOExternalUser -Position 0 -PageSize 50 -SiteUrl $Site.Url `
        | select -Property Email

    Write-Host "Completed"
    Write-Host
}

#Remove-PSSession $Session