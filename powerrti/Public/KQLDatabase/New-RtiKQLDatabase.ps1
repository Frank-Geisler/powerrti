function New-RtiKQLDatabase {
#Requires -Version 7.1

<#
.SYNOPSIS
    Creates a new Fabric KQLDatabase

.DESCRIPTION
    Creates a new Fabric KQLDatabase

.EXAMPLE
    New-RTIWorkspace 

#>

[CmdletBinding()]
    param (

        [Parameter(Mandatory=$true)]
        [string]$WorkspaceID, 

        [Parameter(Mandatory=$true)]
        [string]$EventhouseID, 
        
        [Parameter(Mandatory=$true)]
        [string]$KQLDatabaseName,

        [ValidateLength(0, 256)]
        [string]$KQLDatabaseDescription

    )

begin {
    # Check if session is established - if not throw error
    if ($null -eq $RTISession.headerParams) {
        throw "No session established to Fabric Real-Time Intelligence. Please run Connect-RTISession"
    }

    # Create body of request
    $body = @{
        'displayName' = $KQLDatabaseName
        'description' = $KQLDatabaseDescription
        'creationPayload'= @{
                'databaseType' = "ReadWrite";
                'parentEventhouseItemId' = $EventhouseId} 
    } | ConvertTo-Json `
            -Depth 1

    # Create KQLDatabase API URL
    $KQLDatabaseApiUrl = "$($RTISession.BaseFabricUrl)/v1/workspaces/$WorkspaceId/KQLDatabases" 
    }

process {

    # Call KQLDatabase API
    $response = Invoke-RestMethod `
                        -Headers $RTISession.headerParams `
                        -Method POST `
                        -Uri $KQLDatabaseApiUrl `
                        -Body ($body) `
                        -ContentType "application/json"

    $response
}

end {}

}