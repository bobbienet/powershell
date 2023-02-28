
$pubkey = "$env:userprofile\.ssh\id_rsa.pub"
$modkey = "$env:userprofile\.ssh\id_rsa.pub.txt"
#test if the default public key is in the default location.
if (test-path $pubkey){
write-host "Discovered file in $pubkey"
}

#check that the first 8 characters of the file is "ssh-rsa " (including space)
$begin = (get-content $pubkey).Substring(0,8)
if ($begin -eq "ssh-rsa ") {
write-host "Discovered what appears to be a valid RSA Public Key (Begins with 'ssh-rsa ')"
}
else {
write-warning "File begins with $begin... exiting"
}

#store the contents of the public key in a string named workingkey
$workingkey = (get-content $pubkey)

#strip the first 8 characters (ssh-rsa )
$workingkey = $workingkey.substring(8)

#strip all characters after the '==' which should appear at the end of the key just before the username@
#$workingkey.substring(0, $workingkey.IndexOf('=='))

#locate the position of "==" and add two to the value to include it, will be used to strip out the remainder
$length = $workingkey.IndexOf('==')+2

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
