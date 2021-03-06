﻿<#
    .SYNOPSIS
        Connect to Exchange Online and sets the mailbox Archive setting to mailbox
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
        Specifies the Alias, Display name, Distinguished name, SamAccountName, Guid or user principal name of the mailbox from which to set archive setting

    .Parameter Enable
        Enables or disables the archive state of the mailbox
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$MailboxId,
    [switch]$Enable
)

#Clear
#$ErrorActionPreference='Stop'

try{
    $box = Get-Mailbox -Identity $MailboxId
    if($null -ne $box){
        if($Enable){
            Enable-Mailbox -Identity $MailboxId -Archive -Confirm:$false
        }
        else{
            Disable-Mailbox -Identity $MailboxId -Archive -Confirm:$false
        }
        $res =  Get-Mailbox -Identity $MailboxId | Select-Object ArchiveStatus,UserPrincipalName,DisplayName,WindowsEmailAddress
        if($SRXEnv) {
            $SRXEnv.ResultMessage = $res | Format-List
        } 
        else{
            Write-Output $res | Format-List 
        }
    }
    else{
        if($SRXEnv) {
            $SRXEnv.ResultMessage = "Mailbox not found"
        } 
        Throw  "Mailbox not found"
    }
}
finally{
    
}