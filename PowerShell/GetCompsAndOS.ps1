$Computers = Get-ADComputer -Filter * -Properties LastLogonDate `
| Where {$_.LastLogonDate -gt (Get-Date).AddMonths(-2)} `
| Select -ExpandProperty Name

foreach($Computer in $Computers){
    $Caption = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $Computer | select -ExpandProperty Caption
    $Date = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $Computer | select -ExpandProperty InstallDate

    New-Object PSObject -Property @{'ComputerName'="$Computer"; `
                                    'Caption'="$Caption"; `
                                    'InstallDate'=[Management.ManagementDateTimeConverter]::ToDateTime($date)} `
    | Export-Csv C:\Users\nknight\Desktop\CompsAndOS.csv -append -notypeinformation
}