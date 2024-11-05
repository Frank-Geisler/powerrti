function Set-RtiKQLDatabase {
#Requires -Version 7.1

<#
.SYNOPSIS
    Updates Properties of an existing Fabric KQLDatabase

.DESCRIPTION
    Updates Properties of an existing Fabric KQLDatabase

.EXAMPLE
    Set-RTIKQLDatabase 

.LINK
    https://learn.microsoft.com/en-us/rest/api/fabric/KQLDatabase/items/create-KQLDatabase?tabs=HTTP
#>

[CmdletBinding()]
    param (

        [Parameter(Mandatory=$true)]
        [string]$WorkspaceId, 

        [Parameter(Mandatory=$true)]
        [string]$KQLDatabaseId, 
        
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
    $body = @{}

    if ($PSBoundParameters.ContainsKey("KQLDatabaseName")) {
        $body["displayName"] = $KQLDatabaseName
    }

    if ($PSBoundParameters.ContainsKey("KQLDatabaseDescription")) {
        $body["description"] = $KQLDatabaseDescription
    }

    $body = $body `
                | ConvertTo-Json `
                    -Depth 1

    # Create KQLDatabase API URL
    $KQLDatabaseApiUrl = "$($RTISession.BaseFabricUrl)/v1/workspaces/$WorkspaceId/KQLDatabases/$KQLDatabaseId" 
    }

process {

    # Call KQLDatabase API
    $response = Invoke-RestMethod `
                        -Headers $RTISession.headerParams `
                        -Method PATCH `
                        -Uri $KQLDatabaseApiUrl `
                        -Body ($body) `
                        -ContentType "application/json"

    $response
}

end {}

}