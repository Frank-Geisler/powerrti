function Set-RtiEventhouse {
#Requires -Version 7.1

<#
.SYNOPSIS
    Updates Properties of an existing Fabric Eventhouse

.DESCRIPTION
    Updates Properties of an existing Fabric Eventhouse

.PARAMETER WorkspaceId
    Id of the Fabric Workspace for which the Eventhouse should be updated. The value for WorkspaceId is a GUID. 
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.PARAMETER EventhouseId
    The Id of the Eventhouse to update. The value for EventhouseId is a GUID. 
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.PARAMETER EventhouseNewName
    The new name of the Eventhouse.

.PARAMETER EventhouseDescription
    The new description of the Eventhouse.

.EXAMPLE
    Set-RtiEventhouse `
        -WorkspaceId '12345678-1234-1234-1234-123456789012' `
        -EventhouseId '12345678-1234-1234-1234-123456789012' `
        -EventhouseNewName 'MyNewEventhouse' `
        -EventhouseDescription 'This is my new Eventhouse'

    This example will update the Eventhouse with the Id '12345678-1234-1234-1234-123456789012' 
    in the Workspace with the Id '12345678-1234-1234-1234-123456789012' to 
    have the name 'MyNewEventhouse' and the description 
    'This is my new Eventhouse'.

.NOTES
    TODO: Add functionality to update Eventhouse properties using EventhouseName instead of EventhouseId

    Revsion History:
    
    - 2024-11-07 - FGE: Implemented SupportShouldProcess
    - 2024-11-09 - FGE: Added NewDisplaName as Alias for EventhouseName    

.LINK
    https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/create-eventhouse?tabs=HTTP
#>

[CmdletBinding(SupportsShouldProcess)]
    param (

        [Parameter(Mandatory=$true)]
        [string]$WorkspaceId, 

        [Parameter(Mandatory=$true)]
        [Alias("Id")]
        [string]$EventhouseId, 
        
        [Alias("NewName", "NewDisplayName")]
        [string]$EventhouseNewName,

        [ValidateLength(0, 256)]
        [Alias("Description")]
        [string]$EventhouseDescription

    )

begin {
    # Check if session is established - if not throw error
    if ($null -eq $RTISession.headerParams) {
        throw "No session established to Fabric Real-Time Intelligence. Please run Connect-RTISession"
    }

    # Create body of request
    $body = @{}

    if ($PSBoundParameters.ContainsKey("EventhouseName")) {
        $body["displayName"] = $EventhouseNewName
    }

    if ($PSBoundParameters.ContainsKey("EventhouseDescription")) {
        $body["description"] = $EventhouseDescription
    }

    $body = $body `
                | ConvertTo-Json `
                    -Depth 1

    # Create Eventhouse API URL
    $eventhouseApiUrl = "$($RTISession.BaseFabricUrl)/v1/workspaces/$WorkspaceId/eventhouses/$EventhouseId" 
    }

process {

    # Call Eventhouse API
        if($PSCmdlet.ShouldProcess($EventhouseId)) {
            $response = Invoke-RestMethod `
                                -Headers $RTISession.headerParams `
                                -Method PATCH `
                                -Uri $eventhouseApiUrl `
                                -Body ($body) `
                                -ContentType "application/json"

            $response
        }
}

end {}

}