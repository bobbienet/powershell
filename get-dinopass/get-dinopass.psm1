<# 
.NOTES
   
   Created By ::          Adam Bobbie
   Created On ::          20250612
   Modified On ::         20250624
   Modification Note ::   Module / function renamed from generate-password to get-dinopass
                          in order to leave generate-password available for future creation
                          as this function requires the use of an internet connection
                          and the dinopass website / api and doesn't "generate" the password
                          locally. A future function called "generate-password" will perform
                          the generation locally
   Version ::             1.0
   Github ::              github.com/bobbienet

.DESCRIPTION
using the -weak or -strong flag after the generate-password command will 
query the dinopass api and display the password that's been retrieved 
and copy it to the clipboard. the reason the password will be displayed
is to allow you to choose a different password if it generates something
uncomfortable like "l@rgebLob23" which could yield the impression that 
you are insulting the end user

.SYNOPSIS          
generates a password using the dinopass.com api with either the strong 
or simple switch

.PARAMETER strong
Optional. uses the strong option with the api to generate a more complex
password (if no flag, invalid flag, or misspelled this is used as default) 

.PARAMETER weak
Optional. uses the simple option with the api to generate a weak password 
   
.EXAMPLE
get-dinopass -weak
  
.EXAMPLE
get-dinopass -strong
#>

function get-dinopass {
    param (
        [switch]$strong,
        [switch]$weak
    )
    #if the -strong or -weak flags aren't set then default to -strong
    #set the child directory of the api to either simple or strong depending on what flag is set
    if ($strong) {
        $child = "strong"
        }
    elseif ($weak) {
        $child = "simple"
        }
    #if neither strong or weak are set
    else {
        $child = "strong"
        }
    #make a web request and only assign the values of the "content" field to the dinopassword variable (negating the need for select-object property and stripping the title)
    $dinopassword = $(Invoke-WebRequest -Uri https://dinopass.com/password/$child).Content

    write-host $dinopassword -NoNewline

    #copy the password that's displayed to the clipboard
    Set-Clipboard -Value $dinopassword
}
