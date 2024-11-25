function Set-RtiKQLQueryset {
#Requires -Version 7.1

<#
.SYNOPSIS
    Updates Properties of an existing Fabric KQLQueryset

.DESCRIPTION
    Updates Properties of an existing Fabric KQLQueryset. The KQLQueryset is identified by
    the WorkspaceId and KQLQuerysetId.

.PARAMETER WorkspaceId
    Id of the Fabric Workspace for which the KQLQueryset should be updated. The value for WorkspaceId is a GUID.
    An example of a GUID is '12345678-1234-1234-1234-123456789012'. This parameter is mandatory.

.PARAMETER KQLQuerysetId
    The Id of the KQLQueryset to update. The value for KQLQuerysetId is a GUID. An example of a GUID is '12345678-1234-1234-1234-123456789012'.
    This parameter is mandatory.

.PARAMETER KQLQuerysetName
    The new name of the KQLQueryset. This parameter is optional.

.PARAMETER KQLQuerysetDescription
    The new description of the KQLQueryset. This parameter is optional.

.EXAMPLE
    Set-RTIKQLQueryset `
        -WorkspaceId '12345678-1234-1234-1234-123456789012' `
        -KQLQuerysetId '12345678-1234-1234-1234-123456789012' `
        -KQLQuerysetNewName 'MyKQLQueryset' `
        -KQLQuerysetDescription 'This is my KQLQueryset'

    This example will update the KQLQueryset. The KQLQueryset will have the name 'MyKQLQueryset'
    and the description 'This is my KQLQueryset'.

.NOTES

    Revsion History:

    - 2024-11-07 - FGE: Implemented SupportShouldProcess
    - 2024-11-09 - FGE: Added NewDisplaName as Alias for KQLQuerysetNewName

.LINK
    https://learn.microsoft.com/en-us/rest/api/fabric/KQLQueryset/items/create-KQLQueryset?tabs=HTTP
#>

[CmdletBinding(SupportsShouldProcess)]
    param (

        [Parameter(Mandatory=$true)]
        [string]$WorkspaceId,

        [Parameter(Mandatory=$true)]
        [Alias("Id")]
        [string]$KQLQuerysetId,

        [Alias("NewName", "NewDisplayName")]
        [string]$KQLQuerysetNewName,

        [ValidateLength(0, 256)]
        [Alias("Description")]
        [string]$KQLQuerysetDescription

    )

begin {
    # Check if session is established - if not throw error
    if ($null -eq $RTISession.headerParams) {
        throw "No session established to Fabric Real-Time Intelligence. Please run Connect-RTISession"
    }

    # Create body of request
    $body = @{}

    if ($PSBoundParameters.ContainsKey("KQLQuerysetName")) {
        $body["displayName"] = $KQLQuerysetNName
    }

    if ($PSBoundParameters.ContainsKey("KQLQuerysetDescription")) {
        $body["description"] = $KQLQuerysetDescription
    }

    $body = $body `
                | ConvertTo-Json `
                    -Depth 1

    # Create KQLQueryset API URL
    $KQLQuerysetApiUrl = "$($RTISession.BaseFabricUrl)/v1/workspaces/$WorkspaceId/KQLQuerysets/$KQLQuerysetId"
    }

process {

    # Call KQLQueryset API
        if($PSCmdlet.ShouldProcess($KQLQuerysetId)) {
            $response = Invoke-RestMethod `
                                -Headers $RTISession.headerParams `
                                -Method PATCH `
                                -Uri $KQLQuerysetApiUrl `
                                -Body ($body) `
                                -ContentType "application/json"

            $response
        }
}

end {}

}