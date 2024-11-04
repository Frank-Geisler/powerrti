function Get-RtiWorkspace {
#Requires -Version 7.1

<#
.SYNOPSIS
    Retrieves Fabric Workspaces

.DESCRIPTION
    Retrieves Fabric Workspaces

.EXAMPLE
    Get-RTIWorkspace
    
.LINK
    https://learn.microsoft.com/en-us/rest/api/fabric/admin/workspaces/get-workspace?tabs=HTTP

.LINK
    https://learn.microsoft.com/en-us/rest/api/fabric/admin/workspaces/list-workspaces?tabs=HTTP
#>

[CmdletBinding()]
    param (

        [string]$WorkspaceId,

        [string]$WorkspaceName,

        [string]$WorkspaceCapacityId,

        [ValidateSet("Personal", "Workspace", "Adminworkspace")]
        [string]$WorkspaceType,

        [ValidateSet("active", "deleted")]
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