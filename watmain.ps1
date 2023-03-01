$modulepath = "C:\Users\$env:username\Documents\PowerShell\watframework"

foreach ($module in Get-Childitem $modulepath -Name -Filter "*.psm1")
{
    Import-Module "$modulepath\$module"
}

$valid = @("ip", "com", "sshl", "path")

$param1 = $args[0]

if ($args[0] -in $valid) {
    Invoke-expression $args[0]
}

elseif ($args[0] -like "hash") {
    $file = $args[1]
    Invoke-Expression "hash $file"
} 