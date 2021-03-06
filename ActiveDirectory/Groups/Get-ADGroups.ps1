﻿#Requires -Modules ActiveDirectory

<#
    .SYNOPSIS
        Gets all groups from the OU path
    
    .DESCRIPTION  

    .NOTES
        This PowerShell script was developed and optimized for ScriptRunner. The use of the scripts requires ScriptRunner. 
        The customer or user is authorized to copy the script from the repository and use them in ScriptRunner. 
        The terms of use for ScriptRunner do not apply to this script. In particular, AppSphere AG assumes no liability for the function, 
        the use and the consequences of the use of this freely available script.
        PowerShell is a product of Microsoft Corporation. ScriptRunner is a product of AppSphere AG.
        © AppSphere AG

    .Parameter OUPath
        Specifies the AD path
      
    .Parameter DomainAccount
        Active Directory Credential for remote execution on jumphost without CredSSP

    .Parameter DomainName
        Name of Active Directory Domain
        
    .Parameter SearchScope
        Specifies the scope of an Active Directory search

    .Parameter AuthType
        Specifies the authentication method to use
#>

param(
    [Parameter(Mandatory = $true,ParameterSetName = "Local or Remote DC")]
    [Parameter(Mandatory = $true,ParameterSetName = "Remote Jumphost")]
    [string]$OUPath,   
    [Parameter(Mandatory = $true,ParameterSetName = "Remote Jumphost")]
    [PSCredential]$DomainAccount,
    [Parameter(ParameterSetName = "Local or Remote DC")]
    [Parameter(ParameterSetName = "Remote Jumphost")]
    [string]$DomainName,
    [Parameter(ParameterSetName = "Local or Remote DC")]
    [Parameter(ParameterSetName = "Remote Jumphost")]
    [ValidateSet('Base','OneLevel','SubTree')]
    [string]$SearchScope='SubTree',
    [Parameter(ParameterSetName = "Local or Remote DC")]
    [Parameter(ParameterSetName = "Remote Jumphost")]
    [ValidateSet('Basic', 'Negotiate')]
    [string]$AuthType="Negotiate"
)

Import-Module ActiveDirectory

#Clear
#$ErrorActionPreference='Stop'

$Script:Grps
if($PSCmdlet.ParameterSetName  -eq "Remote Jumphost"){
    if([System.String]::IsNullOrWhiteSpace($DomainName)){
        $Domain = Get-ADDomain -Current LocalComputer -AuthType $AuthType -Credential $DomainAccount
    }
    else{
        $Domain = Get-ADDomain -Identity $DomainName -AuthType $AuthType -Credential $DomainAccount
    }    
    if([System.String]::IsNullOrWhiteSpace($OUPath)){
        $OUPath = $Domain.DistinguishedName
    }
    $Script:Grps = Get-ADGroup -Credential $DomainAccount -Server $Domain.PDCEmulator -AuthType $AuthType -SearchBase $OUPath `
        -SearchBase $OUPath -SearchScope $SearchScope `
        -Filter * -Properties DistinguishedName, SamAccountName | Sort-Object -Property SAMAccountName
}
else{
    if([System.String]::IsNullOrWhiteSpace($DomainName)){
        $Domain = Get-ADDomain -Current LocalComputer -AuthType $AuthType 
    }
    else{
        $Domain = Get-ADDomain -Identity $DomainName -AuthType $AuthType 
    }    
    if([System.String]::IsNullOrWhiteSpace($OUPath)){
        $OUPath = $Domain.DistinguishedName        
    }
    $Script:Grps = Get-ADGroup -Server $Domain.PDCEmulator -AuthType $AuthType -SearchBase $OUPath `
        -SearchBase $OUPath -SearchScope $SearchScope `
        -Filter * -Properties DistinguishedName, SamAccountName | Sort-Object -Property SAMAccountName
}
if($null -ne $Script:Grps){ 
    $resultMessage = @()
    foreach($itm in $Script:Grps){
        $resultMessage = $resultMessage + ($itm.DistinguishedName + ';' +$itm.SamAccountName)
    }
    if($SRXEnv) {
        $SRXEnv.ResultMessage = $resultMessage 
    }
    else{
        Write-Output $resultMessage 
    }
}
else {
    if($SRXEnv) {
        $SRXEnv.ResultMessage = 'No groups found' 
    }
    else{
        Write-Output 'No groups found'
    }
}