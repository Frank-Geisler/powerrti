function Set-RtiEventstream {
#Requires -Version 7.1

<#
.SYNOPSIS
    Updates Properties of an existing Fabric Eventstream

.DESCRIPTION
    Updates Properties of an existing Fabric Eventstream

.PARAMETER WorkspaceId
    Id of the Fabric Workspace for which the Eventstream should be updated. The value for WorkspaceId is a GUID. 
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.PARAMETER EventstreamId
    The Id of the Eventstream to update. The value for EventstreamId is a GUID. 
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.PARAMETER EventstreamNewName
    The new name of the Eventstream.

.PARAMETER EventstreamDescription
    The new description of the Eventstream.

.EXAMPLE
    Set-RtiEventstream `
        -WorkspaceId '12345678-1234-1234-1234-123456789012' `
        -EventstreamId '12345678-1234-1234-1234-123456789012' `
        -EventstreamNewName 'MyNewEventstream' `
        -EventstreamDescription 'This is my new Eventstream'

    This example will update the Eventstream with the Id '12345678-1234-1234-1234-123456789012'. 
    
.NOTES
    TODO: Add functionality to update Eventstream properties using EventstreamName instead of EventstreamId
#>

[CmdletBinding()]
    param (

        [Parameter(Mandatory=$true)]
        [string]$WorkspaceId, 

        [Parameter(Mandatory=$true)]
        [string]$EventstreamId, 
        
        [string]$EventstreamNewName,

        [ValidateLength(0, 256)]
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