$adapters = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -ComputerName 10.1.3.99 `
| where{$_.IPEnabled -eq 1} `
| where{$_.DHCPEnabled -eq 0}

Foreach($adapter in $adapters){
    $adapter.EnableDHCP()
    $adapter.SetDNSServerSearchOrder()
}