function Set-RtiEventhouse {
#Requires -Version 7.1

<#
.SYNOPSIS
    Updates Properties of an existing Fabric Eventhouse

.DESCRIPTION
    Updates Properties of an existing Fabric Eventhouse

.EXAMPLE
    Set-RTIEventhouse 

.LINK
    https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/create-eventhouse?tabs=HTTP
#>

[CmdletBinding()]
    param (

        [Parameter(Mandatory=$true)]
        [string]$WorkspaceId, 

        [Parameter(Mandatory=$true)]
        [string]$EventhouseId, 
        
        [string]$EventhouseName,

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
        $body["displayName"] = $EventhouseName
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
    $response = Invoke-RestMethod `
                        -Headers $RTISession.headerParams `
                        -Method PATCH `
                        -Uri $eventhouseApiUrl `
                        -Body ($body) `
                        -ContentType "application/json"

    $response
}

end {}

}