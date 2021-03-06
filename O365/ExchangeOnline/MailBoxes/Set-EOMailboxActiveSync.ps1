﻿<#
    .SYNOPSIS
        Connect to Exchange Online and sets the mailbox ActiveSync setting to mailbox
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
        Specifies the Alias, Display name, Distinguished name, SamAccountName, Guid or user principal name of the mailbox from which to set ActiveSync

    .Parameter Activate
        Enables or disables Exchange ActiveSync for the mailbox
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$MailboxId,
    [bool]$Activate
)

#Clear
#$ErrorActionPreference='Stop'

try{
    $box = Get-CASMailbox -Identity $MailboxId
    if($null -ne $box){
        Set-CASMailbox -Identity $MailboxId -ActiveSyncEnabled $Activate 
        $resultMessage =  Get-CASMailbox -Identity $MailboxId | Select-Object ActiveSyncEnabled,PrimarySmtpAddress,DisplayName
        if($SRXEnv) {
            $SRXEnv.ResultMessage = $resultMessage | Format-List
        } 
        else{
            Write-Output $resultMessage | Format-List
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