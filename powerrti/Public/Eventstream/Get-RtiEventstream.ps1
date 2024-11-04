function Get-RtiEventstream {
#Requires -Version 7.1

<#
.SYNOPSIS
    Retrieves Fabric Eventstreams

.DESCRIPTION
    Retrieves Fabric Eventstreams

.EXAMPLE
    Get-RTIEventstream

.LINK
    https://learn.microsoft.com/en-us/rest/api/fabric/eventstream/items/get-eventstream?tabs=HTTP
#>

#TODO: Add functionality to list all Eventhouses. To do so fetch all workspaces and 
#      then all eventhouses in each workspace.

[CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$WorkspaceId,

        [string]$EventstreamName,

        [string]$EventstreamId
    )

begin {

    # Check if session is established - if not throw error
    if ($null -eq $RTISession.headerParams) {
        throw "No session established to Fabric Real-Time Intelligence. Please run Connect-RTISession"
    }

    # You can either use Name or WorkspaceID
    if ($PSBoundParameters.ContainsKey("EventstreamName") -and $PSBoundParameters.ContainsKey("EventstreamID")) {
        throw "Parameters EventstreamName and EventstreamID cannot be used together"    
    }

    # Create Eventhouse API
    $eventstreamApiUrl = "$($RTISession.BaseFabricUrl)/v1/workspaces/$WorkspaceId/eventstreams" 

    $eventstreamAPIEventstreamIdUrl = "$($RTISession.BaseFabricUrl)/v1/workspaces/$WorkspaceId/eventstreams/$EventstreamId" 

}

process {

    if ($PSBoundParameters.ContainsKey("EventstreamId")) {

        $response = Invoke-RestMethod `
                    -Headers $RTISession.headerParams `
                    -Method GET `
                    -Uri $eventstreamAPIEventstreamIdUrl `
                    -ContentType "application/json"
                
        $response
    }
    else {
        # Call Workspace API
        $response = Invoke-RestMethod `
                    -Headers $RTISession.headerParams `
                    -Method GET `
                    -Uri $eventstreamApiUrl `
                    -ContentType "application/json"

        if ($PSBoundParameters.ContainsKey("EventstreamName")) {
            $response.value | `
                Where-Object { $_.displayName -eq $EventstreamName }
        }
        else {
            $response.value
        }
    }

}

end {}

}