<# 
.NOTES
   
   Created By ::          Adam Bobbie
   Created On ::          20250626
   Modified On ::         na
   Modification Note ::   
   Version ::             1.0
   Github ::              github.com/bobbienet

.DESCRIPTION
makes fixing the forms2 issue on Outlook somewhat faster

.SYNOPSIS          
refer to the issue and solution published https://support.microsoft.com/en-us/topic/description-of-the-security-update-for-outlook-2016-june-10-2025-kb5002683-18f6b15f-f304-4823-97f4-d01ea49e4f1f
.PARAMETER username
Mandatory. the username of the user to assist with creating the path for the C:\users\\appdata\local\microsoft\forms2 directory

.PARAMETER hostname
Mandatory. the hostname of the system that the user is reporting the issue with outlook crashing on
   
.EXAMPLE
fix-KB5002683 -username jsmith -hostname jsmith-laptop.contoso.com
  

#>

function fix-KB5002683 {
    param (
        [parameter(mandatory=$true)]
        [string]$username,

        [parameter(mandatory=$true)]
        [string]$hostname
        )

new-item -path "\\${hostname}\C$\users\${username}\AppData\Local\Microsoft\" -name "FORMS2" -ItemType directory
}
