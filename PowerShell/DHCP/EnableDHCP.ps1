#Get the computers that you want to change
#Example
#$Computers = Get-Content C:\Users\nknight\Desktop\HitComps.txt

#Loop through each computer and turn on DHCP
foreach($Computer in $Computers){

    #Get Network Adapters from current computer that have IP enabled and DHCP disabled
    $adapters = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -ComputerName $Computer.Name `
    | where{$_.IPEnabled -eq 1} `
    | where{$_.DHCPEnabled -eq 0}

    $RestartReq = 0

    #If there are adapters present, turn on DHCP and Set DNS
    foreach($adapter in $adapters){
        $RetValDHCP = $adapter.EnableDHCP()
        $RetValDNS = $adapter.SetDNSServerSearchOrder()

        #Check if restart required
        if((RetValDHCP -eq 1) -or (RetValDNS -eq 1)){
            $RestartReq = 1
        }
    }

    #Uncomment to restart computers that require a restart
    #Warning! This will restart regardless of who is logged on
    <#
    if(RestartReq -eq 1){
        Restart-Computer -ComputerName $Computer -Force
    }
    #>
}

