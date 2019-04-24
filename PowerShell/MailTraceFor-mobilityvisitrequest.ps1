$UserCredential = Get-Credential
$Session = New-PSSession    -ConfigurationName Microsoft.Exchange `
                            -ConnectionUri https://outlook.office365.com/powershell-liveid/ `
                            -Credential $UserCredential `
                            -Authentication Basic `
                            -AllowRedirection

Import-PSSession $Session -DisableNameChecking

Get-Messagetrace -EndDate (Get-Date) -StartDate (Get-Date).AddDays(-9) -RecipientAddress mobilityvisitrequest@thesmartcircle.com `
    | Select -property Received,SenderAddress,RecipientAddress `
    | Export-Csv "C:\Users\nknight\OneDrive - The Smart Circle\Desktop\mailtrace.csv"