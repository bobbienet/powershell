function ip {<# Created by   :: Shadexic
   Created on   :: 18-Feb-2022
   Version      :: 1.0
   Description  :: add this script to the path
                   
                   > notepad $profile
                   set-alias nmip C:\Users\shadexic\Documents\WindowsPowershell\Scripts\nmip.ps1

                   and then run the command "nmip" to display a more intuitive ip interface summary
                   (Extremely usefull when you have multiple VPN adapters and you only care about
                   what your IP address, default gateway, and DHCP status)
   Example      :: PS C:\Users\shadexic> nmip

                   Description                       IPAddress    DefaultIPGateway DNSDomain         DHCPEnabled
                   -----------                       ---------    ---------------- ---------         -----------
                   Intel(R) Wi-Fi 6 AX201 160MHz     192.168.2.92 192.168.2.1      home              DHCP       
                   Realtek USB GbE Family Controller 172.16.80.11 172.16.80.1      truck.unicorn.ops DHCP       
                   Hyper-V Virtual Ethernet Adapter  172.17.240.1 undefined                          STAT 


#>
$adapters = Get-CimInstance Win32_NetworkAdapterconfiguration -filter "IPEnabled='true'" `
| Select DHCPEnabled, IPAddress, DefaultIPGateway, DNSDomain, Description

$count = $adapters.Length

$start = 0

while ($start -lt $count) {

$adapters[$start].IPAddress = $adapters[$start].IPAddress[0]
    if ($adapters[$start].DefaultIPGateway -eq $null) 
        {
        $adapters[$start].DefaultIPGateway = "undefined"
        }
    else 
        {
        $adapters[$start].DefaultIPGateway = $adapters[$start].DefaultIPGateway[0]
        }
    if ($adapters[$start].DNSDomain -eq $null)
        {
        $adapters[$start].DNSDomain = ""
        }
    if ($adapters[$start].DHCPEnabled -like "True" )
        {
        $adapters[$start].DHCPEnabled = "DHCP"
        }
    if ($adapters[$start].DHCPEnabled -like "False" )
        {
        $adapters[$start].DHCPEnabled = "STAT"
        }
$start++
}
$adapters | select Description, IPAddress, DefaultIPGateway, DNSDomain, DHCPEnabled | Format-Table
}