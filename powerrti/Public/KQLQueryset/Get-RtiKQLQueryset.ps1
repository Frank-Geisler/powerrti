function Get-RtiKQLQueryset {
#Requires -Version 7.1

<#
.SYNOPSIS
    Retrieves Fabric KQLQuerysets

.DESCRIPTION
    Retrieves Fabric KQLQuerysets

.EXAMPLE
    Get-RTIKQLQueryset

#>

#TODO: Add functionality to list all KQLQuerysets. To do so fetch all workspaces and 
#      then all KQLQuerysets in each workspace.

[CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$WorkspaceId,

        [string]$KQLQuerysetName,

        [string]$KQLQuerysetId
    )

begin {

    # Check if session is established - if not throw error
    if ($null -eq $RTISession.headerParams) {
        throw "No session established to Fabric Real-Time Intelligence. Please run Connect-RTISession"
    }

    # You can either use Name or WorkspaceID
    if ($PSBoundParameters.ContainsKey("KQLQuerysetName") -and $PSBoundParameters.ContainsKey("KQLQuerysetId")) {
        throw "Parameters KQLQuerysetName and KQLQuerysetId cannot be used together"    
    }

    # Create KQLQueryset API
    $KQLQuerysetAPI = "$($RTISession.BaseFabricUrl)/v1/workspaces/$WorkspaceId/KQLQuerysets" 

    $KQLQuerysetAPIKQLQuerysetId = "$($RTISession.BaseFabricUrl)/v1/workspaces/$WorkspaceId/KQLQuerysets/$KQLQuerysetId" 

}

process {

    if ($PSBoundParameters.ContainsKey("KQLQuerysetId")) {

        $response = Invoke-RestMethod `
                    -Headers $RTISession.headerParams `
                    -Method GET `
                    -Uri $KQLQuerysetAPIKQLQuerysetId `
                    -ContentType "application/json"
                
        $response
    }
    else {
        # Call Workspace API
        $response = Invoke-RestMethod `
                    -Headers $RTISession.headerParams `
                    -Method GET `
                    -Uri $KQLQuerysetAPI `
                    -ContentType "application/json"

        if ($PSBoundParameters.ContainsKey("KQLQuerysetName")) {
            $response.value | `
                Where-Object { $_.displayName -eq $KQLQuerysetName }
        }
        else {
            $response.value
        }
    }
}

end {}

}