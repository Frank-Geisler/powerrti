function Get-RtiEventhouse {
#Requires -Version 7.1

<#
.SYNOPSIS
    Retrieves Fabric Eventhouses

.DESCRIPTION
    Retrieves Fabric Eventhouses. Without the EventhouseName or EventhouseID parameter, all Eventhouses are returned.
    If you want to retrieve a specific Eventhouse, you can use the EventhouseName or EventhouseID parameter. These
    parameters cannot be used together.

.PARAMETER WorkspaceId
    Id of the Fabric Workspace for which the Eventhouses should be retrieved. The value for WorkspaceId is a GUID. 
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.PARAMETER EventhouseName
    The name of the Eventhouse to retrieve. This parameter cannot be used together with EventhouseID. 

.PARAMETER EventhouseId
    The Id of the Eventhouse to retrieve. This parameter cannot be used together with EventhouseName. The value for WorkspaceId is a GUID. 
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.EXAMPLE
    Get-RTIEventhouse `
        -WorkspaceId '12345678-1234-1234-1234-123456789012' 

    This example will give you all Eventhouses in the Workspace.

.EXAMPLE
    Get-RTIEventhouse `
        -WorkspaceId '12345678-1234-1234-1234-123456789012' `
        -EventhouseName 'MyEventhouse'

    This example will give you all Information about the Eventhouse with the name 'MyEventhouse'.

.EXAMPLE
    Get-RTIEventhouse `
        -WorkspaceId '12345678-1234-1234-1234-123456789012' `
        -EventhouseId '12345678-1234-1234-1234-123456789012'

    This example will give you all Information about the Eventhouse with the Id '12345678-1234-1234-1234-123456789012'. 

.LINK
    https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/list-eventhouses?tabs=HTTP

.NOTES
    TODO: Add functionality to list all Eventhouses in the subscription. To do so fetch all workspaces 
    and then all eventhouses in each workspace.
#>

#

[CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$WorkspaceId,

        [Alias("Name")]
        [string]$EventhouseName,

        [Alias("Id")]
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

        # FGE: adding Members for convenience
        Add-Member `
            -MemberType NoteProperty `
            -Name 'queryServiceUri' `
            -Value $response.properties.queryServiceUri `
            -InputObject $response `
            -Force

        Add-Member `
            -MemberType NoteProperty `
            -Name 'ingestionServiceUri' `
            -Value $response.properties.ingestionServiceUri `
            -InputObject $response `
            -Force

        Add-Member `
            -MemberType NoteProperty `
            -Name 'databasesItemIds' `
            -Value $response.properties.databasesItemIds `
            -InputObject $response `
            -Force

        Add-Member `
            -MemberType NoteProperty `
            -Name 'minimumConsumptionUnits' `
            -Value $response.properties.minimumConsumptionUnits `
            -InputObject $response `
            -Force
                
        $response
    }
    else {
        # Call Workspace API
        $response = Invoke-RestMethod `
                    -Headers $RTISession.headerParams `
                    -Method GET `
                    -Uri $eventhouseAPI `
                    -ContentType "application/json"

        foreach ($eventhouse in $response.value) {
            # FGE: adding Members for convenience
            Add-Member `
                -MemberType NoteProperty `
                -Name 'queryServiceUri' `
                -Value $eventhouse.properties.queryServiceUri `
                -InputObject $eventhouse `
                -Force

            Add-Member `
                -MemberType NoteProperty `
                -Name 'ingestionServiceUri' `
                -Value $eventhouse.properties.ingestionServiceUri `
                -InputObject $eventhouse `
                -Force

            Add-Member `
                -MemberType NoteProperty `
                -Name 'databasesItemIds' `
                -Value $eventhouse.properties.databasesItemIds `
                -InputObject $eventhouse `
                -Force

            Add-Member `
                -MemberType NoteProperty `
                -Name 'minimumConsumptionUnits' `
                -Value $eventhouse.properties.minimumConsumptionUnits `
                -InputObject $eventhouse `
                -Force
        }

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