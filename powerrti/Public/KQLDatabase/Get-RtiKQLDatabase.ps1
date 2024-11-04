function Get-RtiKQLDatabase {
#Requires -Version 7.1

<#
.SYNOPSIS
    Retrieves Fabric KQLDatabases

.DESCRIPTION
    Retrieves Fabric KQLDatabases

.EXAMPLE
    Get-RTIKQLDatabase

#>

#TODO: Add functionality to list all KQLDatabases. To do so fetch all workspaces and 
#      then all KQLDatabases in each workspace.

[CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$WorkspaceId,

        [string]$KQLDatabaseName,

        [string]$KQLDatabaseId
    )

begin {

    # Check if session is established - if not throw error
    if ($null -eq $RTISession.headerParams) {
        throw "No session established to Fabric Real-Time Intelligence. Please run Connect-RTISession"
    }

    # You can either use Name or WorkspaceID
    if ($PSBoundParameters.ContainsKey("KQLDatabaseName") -and $PSBoundParameters.ContainsKey("KQLDatabaseId")) {
        throw "Parameters KQLDatabaseName and KQLDatabaseId cannot be used together"    
    }

    # Create KQLDatabase API
    $KQLDatabaseAPI = "$($RTISession.BaseFabricUrl)/v1/workspaces/$WorkspaceId/kqldatabases" 

    $KQLDatabaseAPIKQLDatabaseId = "$($RTISession.BaseFabricUrl)/v1/workspaces/$WorkspaceId/kqldatabases/$KQLDatabaseId" 

}

process {

    if ($PSBoundParameters.ContainsKey("KQLDatabaseId")) {

        $response = Invoke-RestMethod `
                    -Headers $RTISession.headerParams `
                    -Method GET `
                    -Uri $KQLDatabaseAPIKQLDatabaseId `
                    -ContentType "application/json"
                
        $response
    }
    else {
        # Call Workspace API
        $response = Invoke-RestMethod `
                    -Headers $RTISession.headerParams `
                    -Method GET `
                    -Uri $KQLDatabaseAPI `
                    -ContentType "application/json"

        if ($PSBoundParameters.ContainsKey("KQLDatabaseName")) {
            $response.value | `
                Where-Object { $_.displayName -eq $KQLDatabaseName }
        }
        else {
            $response.value
        }
    }
}

end {}

}