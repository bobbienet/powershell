function path {
$major = $PSVersionTable.PSVersion.Major
$minor = $PSVersionTable.PSVersion.Minor
$patch = $PSVersionTable.PSVersion.Patch
switch ($major) {
    7 {write-host "Powershell $major.$minor.$patch default path: C:\Users\$env:username\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"}
    5 {write-host "Powershell $major.$minor.$patch default path: C:\Users\$env:username\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"}
    default {write-host "unknown version, the wat framework may not work correctly"}
    }
    write-host "`ncurrent Profile that runs on startup of this powershell is $profile"
    write-host "`nNOTE: often the Powershell 5 location is also in use for version 7... this can cause confusion"
}