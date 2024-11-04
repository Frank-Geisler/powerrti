function Get-RTIEventhouse {
#Requires -Version 7.1

<#
.SYNOPSIS
    Retrieves Fabric Eventhouses
.DESCRIPTION
    Retrieves Fabric Eventhouses
.EXAMPLE
    Get-RTIEventhouse
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
    }
    
    # You can either use Name or WorkspaceID
    if ($PSBoundParameters.ContainsKey("Name") -and $PSBoundParameters.ContainsKey("WorkspaceID")) {
        throw "Parameters Name and WorkspaceID cannot be used together"    
    }

    # Create Eventhouse API
    $eventhouseAPI = "https://api.fabric.microsoft.com/v1/workspaces/$WorkspaceId/eventhouses" 

}

process {

    # Call Workspace API
    $response = Invoke-RestMethod `
                -Headers $RTISession.headerParams `
                -Method GET `
                -Uri $eventhouseAPI `
                -ContentType "application/json"


    $response.value
}

end {}

}