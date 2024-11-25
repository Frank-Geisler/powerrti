function Get-RtiKQLQueryset {
#Requires -Version 7.1

<#
.SYNOPSIS
    Retrieves Fabric KQLQuerysets

.DESCRIPTION
    Retrieves Fabric KQLQuerysets. Without the KQLQuerysetName or KQLQuerysetId parameter,
    all KQLQuerysets are returned in the given Workspace. If you want to retrieve a specific
    KQLQueryset, you can use the KQLQuerysetName or KQLQuerysetId parameter. These parameters
    cannot be used together.

.PARAMETER WorkspaceId
    Id of the Fabric Workspace for which the KQLQuerysets should be retrieved. The value for WorkspaceId is a GUID.
    An example of a GUID is '12345678-1234-1234-1234-123456789012'. This parameter is mandatory.

.PARAMETER KQLQuerysetName
    The name of the KQLQueryset to retrieve. This parameter cannot be used together with KQLQuerysetId.

.PARAMETER KQLQuerysetId
    The Id of the KQLQueryset to retrieve. This parameter cannot be used together with KQLQuerysetName.
    The value for KQLQuerysetId is a GUID. An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.EXAMPLE
    Get-RtiKQLQueryset `
        -WorkspaceId '12345678-1234-1234-1234-123456789012' `
        -KQLQuerysetName 'MyKQLQueryset'

    This example will retrieve the KQLQueryset with the name 'MyKQLQueryset'.

.EXAMPLE
    Get-RtiKQLQueryset `
        -WorkspaceId '12345678-1234-1234-1234-123456789012'

    This example will retrieve all KQLQuerysets in the workspace that is specified
    by the WorkspaceId.

.EXAMPLE
    Get-RtiKQLQueryset `
        -WorkspaceId '12345678-1234-1234-1234-123456789012' `
        -KQLQuerysetId '12345678-1234-1234-1234-123456789012'

    This example will retrieve the KQLQueryset with the ID '12345678-1234-1234-1234-123456789012'.

.NOTES
    TODO: Add functionality to list all KQLQuerysets. To do so fetch all workspaces and
        then all KQLQuerysets in each workspace.

    Revision History:
        - 2024-11-09 - FGE: Added DisplaName as Alias for KQLQuerysetName

#>


[CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$WorkspaceId,

        [Alias("Name","DisplayName")]
        [string]$KQLQuerysetName,

        [Alias("Id")]
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