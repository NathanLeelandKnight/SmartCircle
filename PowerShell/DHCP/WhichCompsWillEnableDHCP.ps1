$Computers = Get-ADComputer -filter * | Select -Property Name
Foreach($Computer in $Computers)
{
    Write-Host $Computer.Name
    
    $adapters = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -ComputerName $Computer.Name `
    | where{$_.IPEnabled -eq 1} `
    | where{$_.DHCPEnabled -eq 0}

    if(($adapters | Measure-Object | Select -Property Count).Count -gt 0)
    {
        $Computer.Name | Out-File -FilePath C:\Users\nknight\Desktop\HitComps.txt -append
    }
}
