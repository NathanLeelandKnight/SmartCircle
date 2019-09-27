#Connect-SPOService -Url "https://thesmartcircle-admin.sharepoint.com"

#$UserCredential = Get-Credential

<#$Session = New-PSSession `
                -ConfigurationName Microsoft.Exchange `
                -ConnectionUri https://outlook.office365.com/powershell-liveid/ `
                -Credential $UserCredential `
                -Authentication Basic `
                -AllowRedirection#>

#Import-PSSession $Session -DisableNameChecking

$ExternalSites = get-sposite `
                    | Where-Object {$_.SharingCapability -eq "ExternalUserSharingOnly"} `
                    | select -Property Url

foreach($Site in $ExternalSites){
    Write-Host "Finding activity for site: " $Site.Url

    Search-UnifiedAuditLog `
        -ObjectIds $Site.Url `
        -StartDate 9/20/2019 `
        -EndDate 9/29/2019 `
        -ResultSize 5000 `
        | select -Property UserIds `
        | Export-Csv -Append C:\temp\sharepointtest.csv

    Write-Host "Completed"
    Write-Host
}

#Remove-PSSession $Session