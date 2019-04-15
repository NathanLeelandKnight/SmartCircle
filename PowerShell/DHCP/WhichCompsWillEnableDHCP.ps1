#Get every computer in AD with adjustable logon date.
#Currently adjusted to no more than 1 years old
#Used to not waste time trying to contact decommissioned computers.

$Computers = Get-ADComputer -Filter * -Properties LastLogonDate `
| Where {$_.LastLogonDate -gt (Get-Date).AddYears(-1)} `
| Select -Property Name

#Run script on each computer
foreach($Computer in $Computers)
{
    #Get Network Adapters from current computer that have IP enabled and DHCP disabled   
    $adapters = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -ComputerName $Computer.Name `
    | where{$_.IPEnabled -eq 1} `
    | where{$_.DHCPEnabled -eq 0}

    #If there are adapters present, put the name of the computer in a file "HitComps.txt"
    if(($adapters | Measure-Object | Select -Property Count).Count -gt 0)
    {
        $Computer.Name | Out-File -FilePath C:\Users\nknight\Desktop\HitComps.txt -append
    }
}
