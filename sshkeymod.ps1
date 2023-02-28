<# Created by   ::  Adam Bobbie 
   Created on   ::  2022-11-18 (18th November 2022)
   Modified by  ::  Adam Bobbie
   Modified on  ::  2023-02-28 (28th February 2023)
   Version      ::  1.1
   Description  ::  Checks the default location of public keys for SSH in a windows environment (C:\Users\username\.ssh\id_rsa.pub)
                    and strips out everything but the key itself and then copies to clipboard (if -c flag is used) to allow for pasting
                    into a console session on Cisco equipment for ssh authentication. (unfortunately Cisco equipment doesn't like anything
                    but the key in it's configuration). a file named cisco_id_rsa.txt extension is also generated for future use, the .txt
                    extension is chosen to make opening it eassier in a windows environment.
   
   Modification ::  added description and option to copy output to clipboard via -c flag in prepration for public publication

   Example      ::
                  PS> .\sshkeymod.ps1
                  Discovered file in C:\Users\<username>\.ssh\id_rsa.pub
                  Discovered what appears to be a valid RSA Public Key (Begins with 'ssh-rsa ')

                  key file is located at C:\Users\<username>\.ssh\cisco_id_rsa.txt
                  Key is:
                  djfksaht3fhdgksdfghs8erioghsdrkghsdflgiu~
                  ~

   Example      ::
                  PS> .\sshkeymod.ps1 -s -c
                  Discovered file in C:\Users\<username>\.ssh\id_rsa.pub
                  Discovered what appears to be a valid RSA Public Key (Begins with 'ssh-rsa ')

                  Key file is located at C:\Users\<username>\.ssh\cisco_id_rsa.txt

                  Key copied to clipboard
   Example      ::
                  PS> .\sshkeymod.ps1 -c
                  Discovered file in C:\Users\<username>\.ssh\id_rsa.pub
                  Discovered what appears to be a valid RSA Public Key (Begins with 'ssh-rsa ')

                  key file is located at C:\Users\<username>\.ssh\cisco_id_rsa.txt
                  Key is:
                  djfksaht3fhdgksdfghs8erioghsdrkghsdflgiu~
                  ~
                  
                  Key copied to clipboard
#>

#two switches for hiding the key output and copying the key to the clipboard
[CmdletBinding()]
Param([switch]$silent, [switch]$clipboard)

#Checks the OS of the system that it's running on, then uses the appropriate variable
if ($IsLinux) {
    $pubkey = "~/.ssh/id_rsa.pub"
    $modkey = "~/.ssh/cisco_id_rsa.txt"
}
elseif ($IsWindows) {
    $pubkey = "$env:userprofile\.ssh\id_rsa.pub"
    $modkey = "$env:userprofile\.ssh\cisco_id_rsa.txt"
}

#test if the default public key is in the default location.
if (test-path $pubkey){
        write-host "Discovered file in $pubkey"
    }

    #if no file is found display message and add example of command to generate key
    else {
        write-host "File $pubkey not found"
        write-host "You can generate a public key file with"
        write-host "ssh-keygen -b 4096 ↵ ↵ ↵ ↵ (Press enter 4 times for passwordless ssh key)"
        exit
    }

#check that the first 8 characters of the file is "ssh-rsa " (including space)
$begin = (get-content $pubkey).Substring(0,8)
if ($begin -eq "ssh-rsa ") {
write-host "Discovered what appears to be a valid RSA Public Key (Begins with 'ssh-rsa ')"

#store the contents of the public key in a string named workingkey
$workingkey = get-content $pubkey


#strip the first 8 characters (ssh-rsa ) of working key and save it back into the workingkey variable
$workingkey = $workingkey.substring(8)


#locate the position of "=" and store it as $length, this will be used to strip out the remaing characters after the key 
#typically it's something like domain\username@hostname | this also works with ==
 
$length = $workingkey.IndexOf('=')

#set the workingkey string as everything before the location specified by the $length variable calculated in the last step
$workingkey = $workingkey.Substring(0, $length)


#splits the lines into 64 character segments and writes them to the $modkey location
$workingkey | ForEach-Object {
    $line = $_
 
    for ($i = 0; $i -lt $line.Length; $i += 64)
    {
        $length = [Math]::Min(64, $line.Length - $i)
        $line.SubString($i, $length)
    }
} | set-content $modkey
    #if the -silent or -s switch is used, display the location where the key can be found
    if($silent){
        Write-Host "`nKey file is located at $modkey" #`n (non-shift tilde key) makes a new blank line between the two lines)
    }
    #if the -silent or -s key isn't present then show it on the command line in addition to where it can be found
    else{
        Write-Host "`nKey file is located at $modkey"
        write-host "Key is:"
        get-content $modkey
    }
    #if the -c or -clipboard switch / flag is in the commandline then copy the contents of the key (including the line breaks) to the clipboard
    if($clipboard){
        Set-Clipboard (get-content $modkey)
        write-host "`nKey copied to clipboard"
    }
}

#if the file doesn't begin with "ssh-rsa" write a two line error code with the first 8 characters in the --foreground color of red (your env color scheme may be different)
# and the valid output that's expected in --foregroundcolor of green (your theme may change this)
else {
write-warning "Unexpected beginning of file."
write-host "File begins with " -NoNewline
write-host "$begin" -ForegroundColor Red -NoNewline
write-host "is not recognised as the beginning of an SSH key file that can be modified. Expected " -NoNewline
write-host "ssh-rsa" -ForegroundColor Green
exit
}
