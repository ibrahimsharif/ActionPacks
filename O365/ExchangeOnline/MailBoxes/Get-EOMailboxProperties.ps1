﻿<#
    .SYNOPSIS
        Connect to Exchange Online and gets the mailbox properties
        Requirements 
        64-bit OS for all Modules 
        Microsoft Online Sign-In Assistant for IT Professionals  
    
    .DESCRIPTION  

    .NOTES
        This PowerShell script was developed and optimized for ScriptRunner. The use of the scripts requires ScriptRunner. 
        The customer or user is authorized to copy the script from the repository and use them in ScriptRunner. 
        The terms of use for ScriptRunner do not apply to this script. In particular, AppSphere AG assumes no liability for the function, 
        the use and the consequences of the use of this freely available script.
        PowerShell is a product of Microsoft Corporation. ScriptRunner is a product of AppSphere AG.
        © AppSphere AG

    .Parameter MailboxId
        Specifies the Alias, Display name, Distinguished name, SamAccountName, Guid or user principal name of the mailbox from which to get properties

    .Parameter Properties
        List of properties to expand. Use * for all properties
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$MailboxId,
    [string[]]$Properties=@("DisplayName","FirstName","LastName","Office", "Phone","WindowsEmailAddress","AccountDisabled","DistinguishedName","Alias","Guid","ResetPasswordOnNextLogon","UserPrincipalName")
)

#Clear
#$ErrorActionPreference = 'Stop'

try{
    if([System.String]::IsNullOrWhiteSpace($Properties)){
        $Properties='*'
    }
    $res = Get-Mailbox -Identity $MailboxId | Select-Object $Properties 
    if($null -ne $res){        
        if($SRXEnv) {
            $SRXEnv.ResultMessage = $res
        }
        else{
            Write-Output $res
        }
    }
    else{
        if($SRXEnv) {
            $SRXEnv.ResultMessage = "Mailbox $($MailboxId) not found"
        } 
        Throw  "Mailbox $($MailboxId) not found"
    }
}
Finally{
   
}