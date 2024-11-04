function Remove-RTIEventhouse {
#Requires -Version 7.1

<#
.SYNOPSIS
    Removes an existing Fabric Eventhouse

.DESCRIPTION
    Removes an existing Fabric Eventhouse

.EXAMPLE
    New-RTIWorkspace 

.LINK
    https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/delete-eventhouse?tabs=HTTP
#>

# TODO: Add functionality to remove Eventhouse by name.

[CmdletBinding()]
    param (

        [Parameter(Mandatory=$true)]
        [string]$WorkspaceId, 
        
        [Parameter(Mandatory=$true)]
        [string]$EventhouseId

    )

begin {
    # Check if session is established - if not throw error
    if ($null -eq $RTISession.headerParams) {
        throw "No session established to Fabric Real-Time Intelligence. Please run Connect-RTISession"
    }

    # Create body of request
    $body = @{
    'displayName' = $EventhouseName
    'description' = $EventhouseDescription
    } | ConvertTo-Json `
            -Depth 1

    # Create Eventhouse API URL
    $eventhouseApiUrl = "$($RTISession.BaseFabricUrl)/v1/workspaces/$WorkspaceId/eventhouses/$EventhouseId" 

    }

process {

    # Call Eventhouse API
    $response = Invoke-RestMethod `
                        -Headers $RTISession.headerParams `
                        -Method DELETE `
                        -Uri $eventhouseApiUrl `
                        -Body ($body) `
                        -ContentType "application/json"

    $response
}

end {}

}