a set of functions that allow for quickly retreiving useful information when working on Windows systems and working with serial ports.

simply use the word 'wat' followed by one of the modules (wat com will show all active COM ports, wat ip will show active network connections)

# File locations

all of the psm1 modules under the modules directory get placed in C:\Users\$env:username\Documents\PowerShell\watframework

main file (Powershell 7)
watmain.ps1 is placed in C:\Users\$env:username\Documents\WindowsPowershell\watmain.ps1

main file (powershell 5)
watmain.ps1 is placed in C:\Users\$env:username\Documents\Powershell\watmain.ps1

I reccomend adding wat as an alias in the profile of powershell, the $powershell variable should reveal it's location.
Alias; 
set-alias wat C:\Users\$env:username\Documents\WindowsPowershell\watmain.ps1
