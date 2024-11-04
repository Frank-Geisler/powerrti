function Set-RtiKQLQueryset {
#Requires -Version 7.1

<#
.SYNOPSIS
    Updates Properties of an existing Fabric KQLQueryset

.DESCRIPTION
    Updates Properties of an existing Fabric KQLQueryset

.EXAMPLE
    Set-RTIKQLQueryset 

.LINK
    https://learn.microsoft.com/en-us/rest/api/fabric/KQLQueryset/items/create-KQLQueryset?tabs=HTTP
#>

[CmdletBinding()]
    param (

        [Parameter(Mandatory=$true)]
        [string]$WorkspaceId, 

        [Parameter(Mandatory=$true)]
        [string]$KQLQuerysetId, 
        
        [string]$KQLQuerysetName,

        [string]$KQLQuerysetDescription

    )

begin {
    # Check if session is established - if not throw error
    if ($null -eq $RTISession.headerParams) {
        throw "No session established to Fabric Real-Time Intelligence. Please run Connect-RTISession"
    }

    # Create body of request
    $body = @{}

    if ($PSBoundParameters.ContainsKey("KQLQuerysetName")) {
        $body["displayName"] = $KQLQuerysetName
    }

    if ($PSBoundParameters.ContainsKey("KQLQuerysetDescription")) {
        $body["description"] = $KQLQuerysetDescription
    }

    $body = $body `
                | ConvertTo-Json `
                    -Depth 1

    # Create KQLQueryset API URL
    $KQLQuerysetApiUrl = "$($RTISession.BaseFabricUrl)/v1/workspaces/$WorkspaceId/KQLQuerysets/$KQLQuerysetId" 
    }

process {

    # Call KQLQueryset API
    $response = Invoke-RestMethod `
                        -Headers $RTISession.headerParams `
                        -Method PATCH `
                        -Uri $KQLQuerysetApiUrl `
                        -Body ($body) `
                        -ContentType "application/json"

    $response
}

end {}

}