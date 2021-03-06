﻿#Requires -Modules AzureAD

<#
    .SYNOPSIS
        Connect to Azure Active Directory and enables/disables user
        Requirements 
        ScriptRunner Version 4.x or higher
        64-bit OS for all Modules 
        Microsoft Online Sign-In Assistant for IT Professionals  
        Azure Active Directory Powershell Module v2
    
    .DESCRIPTION  

    .NOTES
        This PowerShell script was developed and optimized for ScriptRunner. The use of the scripts requires ScriptRunner. 
        The customer or user is authorized to copy the script from the repository and use them in ScriptRunner. 
        The terms of use for ScriptRunner do not apply to this script. In particular, AppSphere AG assumes no liability for the function, 
        the use and the consequences of the use of this freely available script.
        PowerShell is a product of Microsoft Corporation. ScriptRunner is a product of AppSphere AG.
        © AppSphere AG

    .Parameter UserObjectId
        Specifies the unique ID of the user from which to get properties

    .Parameter UserName
        Specifies the Display name or user principal name of the user from which to set status

    .Parameter Enabled
        Specifies whether the account is enabled
#>

param(
    [Parameter(Mandatory = $true,ParameterSetName = "User object id")]
    [guid]$UserObjectId,
    [Parameter(Mandatory = $true,ParameterSetName = "User name")]
    [string]$UserName,
    [Parameter(Mandatory = $true,ParameterSetName = "User name")]
    [Parameter(Mandatory = $true,ParameterSetName = "User object id")]    
    [bool]$Enabled
)

try{
    if($PSCmdlet.ParameterSetName  -eq "User object id"){
        $Script:Usr = Get-AzureADUser -ObjectId $UserObjectId | Select-Object ObjectID,DisplayName
    }
    else{
        $Script:Usr = Get-AzureADUser -All $true | `
            Where-Object {($_.DisplayName -eq $UserName) -or ($_.UserPrincipalName -eq $UserName)} | `
            Select-Object ObjectID,DisplayName
    }
    if($null -ne $Script:Usr){
        Set-AzureADUser -ObjectId $Script:Usr.ObjectId -AccountEnabled $Enabled
        if($SRXEnv) {
            $SRXEnv.ResultMessage = "User $($Script:Usr.DisplayName) enabled status is $($Enabled.toString())"
        } 
        else{
            Write-Output "User $($Script:Usr.DisplayName) enabled status is $($Enabled.toString())"
        }
    }
    else{
        if($SRXEnv) {
            $SRXEnv.ResultMessage = "User not found"
        }
        Throw  "User not found"
    }
}
finally{
  
}    