function New-RTIEventhouse {
#Requires -Version 7.1

<#
.SYNOPSIS
    Creates a new Fabric Eventhouse

.DESCRIPTION
    Creates a new Fabric Eventhouse

.EXAMPLE
    New-RTIWorkspace 

.LINK
    https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/create-eventhouse?tabs=HTTP
#>

[CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$Name,

        [Parameter(Mandatory=$true)]
        [string]$WorkspaceID
    )

begin {
    # Check if session is established - if not throw error
    if ($null -eq $RTISession.headerParams) {
        throw "No session established to Fabric Real-Time Intelligence. Please run Connect-RTISession"

    # Create body of request
    $body = @{
    'displayName' = $Name
    } | ConvertTo-Json `
            -Depth 1

    # Create Eventhouse API
    $eventhouseAPI = "https://api.fabric.microsoft.com/v1/workspaces/$WorkspaceId/eventhouses" 
    }
}

process {

    # Call Eventhouse API
    $response = Invoke-RestMethod `
                        -Headers $RTISession.headerParams `
                        -Method POST `
                        -Uri $eventhouseAPI `
                        -Body ($body) `
                        -ContentType "application/json"

    $response
}

end {}

}