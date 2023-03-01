<# Created by   :: Adam Bobbie
   Created on   :: 28-Aug-2022
   Mofified on  :: 28-Feb-2023
   Version      :: 1.2
   Description  :: displays current COM ports that are present, usefull for locating the COM port that 
                   your usb to serial adapter is registered under when you need to work with a console cable

   Revsion note :: switched to using the get-ciminstance as previous versions used wmiobject 
                   which is not supported in Powershell 7 and up
                   
   Example      :: PS > wat com
                   Standard Serial over Bluetooth link (COM5) Manufacturer:  Microsoft
                   Standard Serial over Bluetooth link (COM7) Manufacturer:  Microsoft
                   Intel(R) Active Management Technology - SOL (COM4) Manufacturer:  Intel
                   Standard Serial over Bluetooth link (COM8) Manufacturer:  Microsoft
                   Standard Serial over Bluetooth link (COM6) Manufacturer:  Microsoft



#>
function com{

#this is used to hide the always present serial adapters from Intel and Microsoft
#See comments on line 25 to exclude Intel and Microsoft
$exclusions = @('Microsoft','Intel')

#retrieve all the PnP entities within the system that have COMx where X is a number
#remove the ")" and the comment after the "COM\d+"}) on the line below to exclude Intel and Microsoft COM ports
$portList = (get-ciminstance -query "SELECT * FROM win32_PnPEntity" | where {$_.Name -Match "COM\d+"}) #| where {$_.Manufacturer -notin $exclusions})



$counter = 0
     while ($counter -lt $portlist.count){
          
               
               Write-Host $portList[$counter].Name "Manufacturer: " $portList[$counter].Manufacturer
               $counter++
          }
     }
     



