function New-RtiEventstream {
#Requires -Version 7.1

<#
.SYNOPSIS
    Creates a new Fabric Eventstream

.DESCRIPTION
    Creates a new Fabric Eventstream

.EXAMPLE
    New-RTIEventstream

.LINK
    https://learn.microsoft.com/en-us/rest/api/fabric/eventstream/items/create-eventstream?tabs=HTTP
#>

[CmdletBinding()]
    param (

        [Parameter(Mandatory=$true)]
        [string]$WorkspaceID, 
        
        [Parameter(Mandatory=$true)]
        [string]$EventstreamName,

        [string]$EventstreamDescription

    )

begin {
    # Check if session is established - if not throw error
    if ($null -eq $RTISession.headerParams) {
        throw "No session established to Fabric Real-Time Intelligence. Please run Connect-RTISession"
    }

    # Create body of request
    $body = @{
    'displayName' = $EventstreamName
    'description' = $EventstreamDescription
    } | ConvertTo-Json `
            -Depth 1

    # Create Eventhouse API URL
    $eventstreamApiUrl = "$($RTISession.BaseFabricUrl)/v1/workspaces/$WorkspaceId/eventstreams" 
    }

process {

    # Call Eventhouse API
    $response = Invoke-RestMethod `
                        -Headers $RTISession.headerParams `
                        -Method POST `
                        -Uri $eventstreamApiUrl `
                        -Body ($body) `
                        -ContentType "application/json"

    $response
}

end {}

}