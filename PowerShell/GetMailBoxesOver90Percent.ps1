#Requires -Modules MSOnline

Connect-MSOnline

Get-Mailbox | Get-MailboxStatistics -ErrorAction SilentlyContinue | Where-Object {([float]$_.TotalItemSize.Value.ToString().Split(" ")[0] -gt 90) -and ($_.TotalItemSize.Value.ToString().Split(" ")[1] -eq "GB")} | ft -Property TotalItemSize, DisplayName