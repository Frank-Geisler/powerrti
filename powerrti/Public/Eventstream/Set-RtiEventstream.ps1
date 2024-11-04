function Set-RtiEventstream {
#Requires -Version 7.1

<#
.SYNOPSIS
    Updates Properties of an existing Fabric Eventstream

.DESCRIPTION
    Updates Properties of an existing Fabric Eventstream

.EXAMPLE
    Set-RTIEventstream 

.LINK
    https://learn.microsoft.com/en-us/rest/api/fabric/Eventstream/items/create-Eventstream?tabs=HTTP
#>

[CmdletBinding()]
    param (

        [Parameter(Mandatory=$true)]
        [string]$WorkspaceId, 

        [Parameter(Mandatory=$true)]
        [string]$EventstreamId, 
        
        [string]$EventstreamName,

        [string]$EventstreamDescription

    )

begin {
    # Check if session is established - if not throw error
    if ($null -eq $RTISession.headerParams) {
        throw "No session established to Fabric Real-Time Intelligence. Please run Connect-RTISession"
    }

    # Create body of request
    $body = @{}

    if ($PSBoundParameters.ContainsKey("EventstreamName")) {
        $body["displayName"] = $EventstreamName
    }

    if ($PSBoundParameters.ContainsKey("EventstreamDescription")) {
        $body["description"] = $EventstreamDescription
    }

    $body = $body `
                | ConvertTo-Json `
                    -Depth 1

    # Create Eventstream API URL
    $EventstreamApiUrl = "$($RTISession.BaseFabricUrl)/v1/workspaces/$WorkspaceId/Eventstreams/$EventstreamId" 
    }

process {

    # Call Eventstream API
    $response = Invoke-RestMethod `
                        -Headers $RTISession.headerParams `
                        -Method PATCH `
                        -Uri $EventstreamApiUrl `
                        -Body ($body) `
                        -ContentType "application/json"

    $response
}

end {}

}