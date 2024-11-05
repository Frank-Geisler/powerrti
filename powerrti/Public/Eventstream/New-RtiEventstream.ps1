function New-RtiEventstream {
#Requires -Version 7.1

<#
.SYNOPSIS
    Creates a new Fabric Eventstream

.DESCRIPTION
    Creates a new Fabric Eventstream

.PARAMETER WorkspaceID  
    Id of the Fabric Workspace for which the Eventstream should be created. The value for WorkspaceID is a GUID. 
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.PARAMETER EventstreamName
    The name of the Eventstream to create.

.PARAMETER EventstreamDescription
    The description of the Eventstream to create.

.EXAMPLE
    New-RtiEventstream
        -WorkspaceID '12345678-1234-1234-1234-123456789012'
        -EventstreamName 'MyEventstream'
        -EventstreamDescription 'This is my Eventstream'

    This example will create a new Eventstream with the name 'MyEventstream' and the description 'This is my Eventstream'.

.LINK
    https://learn.microsoft.com/en-us/rest/api/fabric/eventstream/items/create-eventstream?tabs=HTTP
#>

[CmdletBinding()]
    param (

        [Parameter(Mandatory=$true)]
        [string]$WorkspaceID, 
        
        [Parameter(Mandatory=$true)]
        [string]$EventstreamName,

        [ValidateLength(0, 256)]
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