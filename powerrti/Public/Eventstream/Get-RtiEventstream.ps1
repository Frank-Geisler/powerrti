function Get-RtiEventstream {
#Requires -Version 7.1

<#
.SYNOPSIS
    Retrieves Fabric Eventstreams

.DESCRIPTION
    Retrieves Fabric Eventstreams. Without the EventstreamName or EventstreamID parameter, all Eventstreams are returned.
    If you want to retrieve a specific Eventstream, you can use the EventstreamName or EventstreamID parameter. These
    parameters cannot be used together.

.PARAMETER WorkspaceId
    Id of the Fabric Workspace for which the Eventstreams should be retrieved. The value for WorkspaceId is a GUID. 
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.PARAMETER EventstreamName
    The name of the Eventstream to retrieve. This parameter cannot be used together with EventstreamID.

.PARAMETER EventstreamId
    The Id of the Eventstream to retrieve. This parameter cannot be used together with EventstreamName. The value for EventstreamId is a GUID. 
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.EXAMPLE
    Get-RtiEventstream `
        -WorkspaceId '12345678-1234-1234-1234-123456789012'

    This example will give you all Eventstreams in the Workspace.

.EXAMPLE
    Get-RtiEventstream `
        -WorkspaceId '12345678-1234-1234-1234-123456789012' `
        -EventstreamName 'MyEventstream'

    This example will give you all Information about the Eventstream with the name 'MyEventstream'.

.EXAMPLE
    Get-RtiEventstream `
        -WorkspaceId '12345678-1234-1234-1234-123456789012' `
        -EventstreamId '12345678-1234-1234-1234-123456789012'

    This example will give you all Information about the Eventstream with the Id '12345678-1234-1234-1234-123456789012'.

.LINK
    https://learn.microsoft.com/en-us/rest/api/fabric/eventstream/items/get-eventstream?tabs=HTTP

.NOTES
    TODO: Add functionality to list all Eventhouses. To do so fetch all workspaces and 
          then all eventhouses in each workspace.
#>

[CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$WorkspaceId,

        [Alias("Name")]
        [string]$EventstreamName,

        [Alias("Id")]
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