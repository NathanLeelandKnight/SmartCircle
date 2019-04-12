$Computers = Get-ADComputer -filter * | where{$_.Name -like "GWW-DURONSAR2"} | Select -Property Name
Foreach($Computer in $Computers){
    $adapters = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -ComputerName $Computer.Name `
    | where{$_.IPEnabled -eq 1} `
    | where{$_.DHCPEnabled -eq 0}

    Foreach($adapter in $adapters){
        $adapter.EnableDHCP()
        $adapter.SetDNSServerSearchOrder()
    }
}

