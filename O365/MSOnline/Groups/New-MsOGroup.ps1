﻿#Requires -Modules MSOnline
<#
    .SYNOPSIS
        Connect to MS Online and adds a new group to the Azure Active Directory
        Requirements 
        64-bit OS for all Modules 
        Microsoft Online Sign-In Assistant for IT Professionals  
        Azure Active Directory Powershell Module v1

    .DESCRIPTION  

    .NOTES
        This PowerShell script was developed and optimized for ScriptRunner. The use of the scripts requires ScriptRunner. 
        The customer or user is authorized to copy the script from the repository and use them in ScriptRunner. 
        The terms of use for ScriptRunner do not apply to this script. In particular, AppSphere AG assumes no liability for the function, 
        the use and the consequences of the use of this freely available script.
        PowerShell is a product of Microsoft Corporation. ScriptRunner is a product of AppSphere AG.
        © AppSphere AG

    .Parameter GroupName
        Specifies the display name of the group

    .Parameter Description
        Specifies a description of the group
    
    .Parameter TenantId
        Specifies the unique ID of the tenant on which to perform the operation
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$GroupName,
    [string]$Description,
    [guid]$TenantId
)

$Script:Grp = New-MsolGroup -DisplayName $GroupName -Description $Description -TenantId $TenantId | Select-Object *
if($null -ne $Script:Grp){
    $res=@("Group $($GroupName) created",$Script:Grp)
    if($SRXEnv) {
        $SRXEnv.ResultMessage = "Group $($GroupName) created"
    } 
    else{
        Write-Output $res
    }
}
else{
    if($SRXEnv) {
        $SRXEnv.ResultMessage = "Group not created"
    }    
    Throw "Group not created"
}