$UserCredential = Get-Credential
$Session = New-PSSession    -ConfigurationName Microsoft.Exchange `
                            -ConnectionUri https://outlook.office365.com/powershell-liveid/ `
                            -Credential $UserCredential `
                            -Authentication Basic `
                            -AllowRedirection

Import-PSSession $Session -DisableNameChecking

Get-Messagetrace -EndDate (Get-Date) -StartDate (Get-Date).AddDays(-9) -RecipientAddress mobilityvisitrequest@thesmartcircle.com `
    | Select -property Received,SenderAddress,RecipientAddress `
    | Export-Csv "C:\Users\nknight\OneDrive - The Smart Circle\Desktop\mailTraceRec.csv"

Get-Messagetrace -EndDate (Get-Date) -StartDate (Get-Date).AddDays(-9) -SenderAddress mobilityvisitrequest@thesmartcircle.com `
    | Select -property Received,SenderAddress,RecipientAddress `
    | Export-Csv "C:\Users\nknight\OneDrive - The Smart Circle\Desktop\mailTraceSent.csv"

$From = "nknight@thesmartcircle.com"
$To = "tgresham@thesmartcircle.com"
$AttachmentRec = "C:\Users\nknight\OneDrive - The Smart Circle\Desktop\mailTraceRec.csv"
$AttachmentSent = "C:\Users\nknight\OneDrive - The Smart Circle\Desktop\mailTraceSent.csv"
$Subject = "Mail Trace"
$Body = "Hey Trey, here is the weekly received and sent mail trace for mobilityvisitrequest@thesmartcircle.com"
$SMTPServer = "smtp.office365.com"
$SMTPPort = "587"

Send-MailMessage -From $From -to $To -Subject $Subject -Body $Body -SmtpServer $SMTPServer -Port $SMTPPort -UseSsl `
    -Credential $UserCredential -Attachments $AttachmentRec,$AttachmentSent -DeliveryNotificationOption OnSuccess