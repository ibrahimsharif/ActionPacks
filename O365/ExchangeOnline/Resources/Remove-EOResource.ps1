﻿<#
    .SYNOPSIS
        Connect to Exchange Online and removes the resource
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
        Specifies the Alias, Display name, Distinguished name, SamAccountName, Guid or user principal name of the resource to remove
    
    .Parameter Permanent
        Specifies whether to permanently delete the resource from the resources database
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$MailboxId,
    [switch]$Permanent
)

#Clear
# $ErrorActionPreference='Stop'

try{
    Remove-Mailbox -Identity $MailboxId -Permanent:$Permanent -Force -Confirm:$false
                  
    if($SRXEnv) {
        $SRXEnv.ResultMessage = "Resource $($MailboxId) removed"
    }
    else{
        Write-Output "Resource $($MailboxId) removed"
    }        
}
finally{
   
}