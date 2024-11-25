function Get-RtiWorkspace {
#Requires -Version 7.1

<#
.SYNOPSIS
    Retrieves Fabric Workspaces

.DESCRIPTION
    Retrieves Fabric Workspaces. Without the WorkspaceName or WorkspaceID parameter,
    all Workspaces are returned. If you want to retrieve a specific Workspace, you can
    use the WorkspaceName, an CapacityID, a WorkspaceType, a WorkspaceState or the WorkspaceID
    parameter. The WorkspaceId parameter has precedence over all other parameters because it
    is most specific.

.PARAMETER WorkspaceId
    Id of the Fabric Workspace to retrieve. The value for WorkspaceId is a GUID.
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.PARAMETER WorkspaceName
    The name of the Workspace to retrieve. This parameter cannot be used together with WorkspaceID.

.PARAMETER WorkspaceCapacityId
    The Id of the Capacity to retrieve. This parameter cannot be used together with WorkspaceID.
    The value for WorkspaceCapacityId is a GUID. An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.PARAMETER WorkspaceType
    The type of the Workspace to retrieve. This parameter cannot be used together with WorkspaceID.
    The value for WorkspaceType is a string. An example of a string is 'Personal'. The values that
    can be used are 'Personal', 'Workspace' and 'Adminworkspace'.

.PARAMETER WorkspaceState
    The state of the Workspace to retrieve. This parameter cannot be used together with WorkspaceID.
    The value for WorkspaceState is a string. An example of a string is 'active'. The values that
    can be used are 'active' and 'deleted'.

.EXAMPLE
    Get-RtiWorkspace

    This example will retrieve all Workspaces.

.EXAMPLE
    Get-RtiWorkspace `
        -WorkspaceId '12345678-1234-1234-1234-123456789012'

    This example will retrieve the Workspace with the ID '12345678-1234-1234-1234-123456789012'.

.EXAMPLE
    Get-RtiWorkspace `
        -WorkspaceName 'MyWorkspace'

    This example will retrieve the Workspace with the name 'MyWorkspace'.

.EXAMPLE
    Get-RtiWorkspace `
        -WorkspaceCapacityId '12345678-1234-1234-1234-123456789012'

    This example will retrieve the Workspaces with the Capacity ID '12345678-1234-1234-1234-123456789012'.

.EXAMPLE
    Get-RtiWorkspace `
        -WorkspaceType 'Personal'

    This example will retrieve the Workspaces with the type 'Personal'.

.EXAMPLE
    Get-RtiWorkspace `
        -WorkspaceState 'active'

    This example will retrieve the Workspaces with the state 'active'.


.LINK
    https://learn.microsoft.com/en-us/rest/api/fabric/admin/workspaces/get-workspace?tabs=HTTP


.LINK
    https://learn.microsoft.com/en-us/rest/api/fabric/admin/workspaces/list-workspaces?tabs=HTTP
#>

[CmdletBinding()]
    param (

        [Alias("Id")]
        [string]$WorkspaceId,

        [Alias("Name")]
        [string]$WorkspaceName,

        [Alias("CapacityId")]
        [string]$WorkspaceCapacityId,

        [ValidateSet("Personal", "Workspace", "Adminworkspace")]
        [Alias("Type")]
        [string]$WorkspaceType,

        [ValidateSet("active", "deleted")]
        [Alias("State")]
        [string]$WorkspaceState
    )

begin {

    # Check if session is established - if not throw error
    if ($null -eq $RTISession.headerParams) {
        throw "No session established to Fabric Real-Time Intelligence. Please run Connect-RTISession"
    }

    # WorkspaceID has to be used alone
    if ($PSBoundParameters.ContainsKey("WorkspaceName") -and
        ($PSBoundParameters.ContainsKey("WorkspaceID") `
        -or $PSBoundParameters.ContainsKey("WorkspaceCapcityId") `
        -or $PSBoundParameters.ContainsKey("WorkspaceType") `
        -or $PSBoundParameters.ContainsKey("WorkspaceState"))) {
            throw "Parameters WorkspaceName, WorkspaceCapacityId, WorkspaceType or WorkspaceState and WorkspaceID cannot be used together!"
    }

    # Create Workspace API URL
    $workspaceApiUrl = "$($RTISession.BaseFabricUrl)/v1/admin/workspaces"

    # Create URL for WebAPI Call if WorkspaceID is provided
    if ($PSBoundParameters.ContainsKey("WorkspaceID")) {
        $workspaceApiUrlId = $workspaceApiUrl + '/' + $WorkspaceID
    }

    # FGE: If there are any parameters, we need to filter the API call, the
    #     URL will be constructed here
    $workspaceApiFilter = $workspaceApiUrl

    if ($PSBoundParameters.ContainsKey("WorkspaceName")) {
        $workspaceApiFilter = $workspaceApiFilter + "?name=$WorkspaceName"
    }

    if ($PSBoundParameters.ContainsKey("WorkspaceCapacityId")) {
        $workspaceApiFilter = $workspaceApiFilter + "?capacityId=$WorkspaceCapacityId"
    }

    if ($PSBoundParameters.ContainsKey("WorkspaceType")) {
        $workspaceApiFilter = $workspaceApiFilter + "?type=$WorkspaceType"
    }

    if ($PSBoundParameters.ContainsKey("WorkspaceState")) {
        $workspaceApiFilter = $workspaceApiFilter + "?state=$WorkspaceState"
    }

}

process {

    # FGE: Providing a WorkspaceID is so specific that this will have
    #      precedence over any other parameter
    if ($PSBoundParameters.ContainsKey("WorkspaceID")) {

        # Call Workspace API for WorkspaceID
        $response = Invoke-RestMethod `
                    -Headers $RTISession.headerParams `
                    -Method GET `
                    -Uri $workspaceApiUrlId `
                    -ContentType "application/json"

        $response
    }
    else {

        # Call Workspace API for WorkspaceID
        $response = Invoke-RestMethod `
                    -Headers $RTISession.headerParams `
                    -Method GET `
                    -Uri $workspaceApiFilter `
                    -ContentType "application/json"

        $response.Workspaces
    }

}

end {}

}