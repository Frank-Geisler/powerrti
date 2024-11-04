function Remove-RtiKQLQueryset {
#Requires -Version 7.1

<#
.SYNOPSIS
    Removes an existing Fabric Eventhouse

.DESCRIPTION
    Removes an existing Fabric Eventhouse

.EXAMPLE
    New-RTIWorkspace 

#>

# TODO: Add functionality to remove Eventhouse by name.

[CmdletBinding()]
    param (

        [Parameter(Mandatory=$true)]
        [string]$WorkspaceId, 
        
        [Parameter(Mandatory=$true)]
        [string]$KQLQuerysetId

    )

begin {
    # Check if session is established - if not throw error
    if ($null -eq $RTISession.headerParams) {
        throw "No session established to Fabric Real-Time Intelligence. Please run Connect-RTISession"
    }

    # Create Eventhouse API URL
    $eventhouseApiUrl = "$($RTISession.BaseFabricUrl)/v1/workspaces/$WorkspaceId/KQLQuerysets/$KQLQuerysetId" 

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