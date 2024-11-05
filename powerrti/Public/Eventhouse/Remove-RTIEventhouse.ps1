function Remove-RtiEventhouse {
#Requires -Version 7.1

<#
.SYNOPSIS
    Removes an existing Fabric Eventhouse

.DESCRIPTION
    Removes an existing Fabric Eventhouse

.PARAMETER WorkspaceId
    Id of the Fabric Workspace for which the Eventhouse should be deleted. The value for WorkspaceId is a GUID. 
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.PARAMETER EventhouseId
    The Id of the Eventhouse to delete. The value for EventhouseId is a GUID. 
    An example of a GUID is '12345678-1234-1234-1234-123456789012'. EventhouseId and EventhouseName cannot be used together.

.PARAMETER EventhouseName
    The name of the Eventhouse to delete. EventhouseId and EventhouseName cannot be used together.

.EXAMPLE
    New-RTIWorkspace 

.LINK
    https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/delete-eventhouse?tabs=HTTP
#>

[CmdletBinding()]
    param (

        [Parameter(Mandatory=$true)]
        [string]$WorkspaceId, 
        
        [string]$EventhouseId,

        [string]$EventhouseName

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

    # Create Eventhouse API URL
    $eventhouseApiUrl = "$($RTISession.BaseFabricUrl)/v1/workspaces/$WorkspaceId/eventhouses/$EventhouseId" 

    if ($PSBoundParameters.ContainsKey("EventhouseName")) {
        $eh = Get-RtiEventhouse `
                    -WorkspaceId $WorkspaceId `
                    -EventhouseName $EventhouseName

        $EventhouseId = $eh.id
    }

}

process {

    # Call Eventhouse API
    $response = Invoke-RestMethod `
                        -Headers $RTISession.headerParams `
                        -Method DELETE `
                        -Uri $eventhouseApiUrl `
                        -ContentType "application/json"

    $response
}

end {}

}