function Get-RTIWorkspace {
#Requires -Version 7.1

<#
.SYNOPSIS
    Retrieves Fabric Workspaces
.DESCRIPTION
    Retrieves Fabric Workspaces
.EXAMPLE
    Get-RTIWorkspace 
#>

[CmdletBinding()]
    param (
        [string]$Name,

        [string]$WorkspaceID
    )

begin {

    # Check if session is established - if not throw error
    if ($null -eq $RTISession.headerParams) {
        throw "No session established to Fabric Real-Time Intelligence. Please run Connect-RTISession"

    if ($PSBoundParameters.ContainsKey("Name") -and $PSBoundParameters.ContainsKey("WorkspaceID")) {
        throw "Parameters Name and WorkspaceID cannot be used together"    
    }

    if ($PSBoundParameters.ContainsKey("WorkspaceID")) {
        $workspaceAPI = $workspaceAPI + '/' + $WorkspaceID
    }

    # Create Workspace API
    $workspaceApiUrl = "https://api.fabric.microsoft.com/v1/admin/workspaces" 
}

process {

    # Call Workspace API
    $response = Invoke-RestMethod `
                -Headers $RTISession.headerParams `
                -Method GET `
                -Uri $workspaceApiUrl `
                -ContentType "application/json"


    if ($PSBoundParameters.ContainsKey("WorkspaceID")) {
        $response
    }
    elseif ($PSBoundParameters.ContainsKey("Name")) {
        $response.Workspaces | `
            Where-Object { $_.Name -eq $Name }
    }
    else {
        $response.Workspaces
    }

}

end {}

}