<#  
.SYNOPSIS  
    "inteligently" works with files and the clipboard to match file hashes automatically
.DESCRIPTION  
    This Module is part of the "wat" framework of modules for windows systems
    two arguments are used, although only the first one is required, prompts will be provided
    for the hash of the file itself (the second argument)  
.NOTES  
    File Name  : wathash.psm1
    Author     : Adam Bobbie - abobbie@bobbienet.ca 
    Requires   : get-filehash cmdlet.  
.EXAMPLE
wat hash C:\Users\<username>\Downloads\isofile.iso BEB7CB73BE17
.EXAMPLE
wat hash C:\Users\<username>\Downloads\isofile.iso (Assuming you have the Hash in the clipboard)
#>

function hash($file,$knownhash){
write-host "file is $file"
if ($file -eq $null){
Write-Warning "no file specified"
exit
}
$file = Resolve-Path $file
if ($knownhash -eq $null){
    $clipboard = get-clipboard
    $hashlengths = 32,40,64
    
    if ($clipboard.Length -notin $hashlengths){
    $knownhash = read-host "hash (MD5/SHA1/256)"
    }
    else {
    $knownhash = Get-Clipboard
    }
    }
Switch ($knownhash.Length){
{$_ -eq 32}{$length = "MD5"}
{$_ -eq 40}{$length = "SHA1"}
{$_ -eq 64}{$length = "SHA256"}
Default {throw "Unknown Hash Type"}
}

if (Test-Path $file){
$calculatedhash = (Get-FileHash $file -Algorithm $length).Hash

    if ($calculatedhash -like $knownhash) {
    write-host -ForegroundColor Cyan "Hashes Match"
    write-host -ForegroundColor Cyan "Hash Type: $Length"
    Write-host "Hash: $calculatedhash"}
    
    else {
    write-host -ForegroundColor Red "MISMATCH"
    write-host -ForegroundColor red "Calculated Hash: $calculatedhash"
    write-host -ForegroundColor Red "Compared hash  : $knownhash"
    }
}
else {
Write-host "File Not Found"
}
}
#BEB20D69994EC39DDBC282544A19A005BD8E86A6464C866C7B5BCD57CB73BE17
#BEB20D69994EC39DDBC282544A19A005BD8E86Aass4C866C7B5BCD57CB73BE18

