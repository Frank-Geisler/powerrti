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
    # Create Workspace API
    $workspaceAPI = 'https://api.fabric.microsoft.com/v1/admin/workspaces' 

    if ($PSBoundParameters.ContainsKey("Name") -and $PSBoundParameters.ContainsKey("WorkspaceID")) {
        throw "Parameters Name and WorkspaceID cannot be used together"    
    }

    if ($PSBoundParameters.ContainsKey("WorkspaceID")) {
        $workspaceAPI = $workspaceAPI + '/' + $WorkspaceID
    }
}

process {

    # Call Workspace API
    $response = Invoke-RestMethod `
                -Headers $RTISession.headerParams `
                -Method GET `
                -Uri $workspaceAPI `
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