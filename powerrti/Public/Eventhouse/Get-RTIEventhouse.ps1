function Get-RtiEventhouse {
#Requires -Version 7.1

<#
.SYNOPSIS
    Retrieves Fabric Eventhouses

.DESCRIPTION
    Retrieves Fabric Eventhouses

.EXAMPLE
    Get-RTIEventhouse

.LINK
    https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/list-eventhouses?tabs=HTTP

#>

#TODO: Add functionality to list all Eventhouses. To do so fetch all workspaces and 
#      then all eventhouses in each workspace.

[CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$WorkspaceId,

        [string]$EventhouseName,

        [string]$EventhouseId
    )

begin {

    # Check if session is established - if not throw error
    if ($null -eq $RTISession.headerParams) {
        throw "No session established to Fabric Real-Time Intelligence. Please run Connect-RTISession"
    }

    # You can either use Name or WorkspaceID
    if ($PSBoundParameters.ContainsKey("EventhouseName") -and $PSBoundParameters.ContainsKey("EventhouseID")) {
        throw "Parameters EventhouseName and EventhouseID cannot be used together"    
    }

    # Create Eventhouse API
    $eventhouseAPI = "$($RTISession.BaseFabricUrl)/v1/workspaces/$WorkspaceId/eventhouses" 

    $eventhouseAPIEventhouseId = "$($RTISession.BaseFabricUrl)/v1/workspaces/$WorkspaceId/eventhouses/$EventhouseId" 

}

process {

    if ($PSBoundParameters.ContainsKey("EventhouseId")) {

        $response = Invoke-RestMethod `
                    -Headers $RTISession.headerParams `
                    -Method GET `
                    -Uri $eventhouseAPIEventhouseId `
                    -ContentType "application/json"
                
        $response
    }
    else {
        # Call Workspace API
        $response = Invoke-RestMethod `
                    -Headers $RTISession.headerParams `
                    -Method GET `
                    -Uri $eventhouseAPI `
                    -ContentType "application/json"

        if ($PSBoundParameters.ContainsKey("EventhouseName")) {
            $response.value | `
                Where-Object { $_.displayName -eq $EventhouseName }
        }
        else {
            $response.value
        }
    }

}

end {}

}