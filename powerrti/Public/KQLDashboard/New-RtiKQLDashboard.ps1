function New-RtiKQLDashboard {
#Requires -Version 7.1

<#
.SYNOPSIS
    Creates a new Fabric KQLDashboard

.DESCRIPTION
    Creates a new Fabric KQLDashboard

.EXAMPLE
    New-RTIWorkspace 

#>

[CmdletBinding()]
    param (

        [Parameter(Mandatory=$true)]
        [string]$WorkspaceID, 
        
        [Parameter(Mandatory=$true)]
        [string]$KQLDashboardName,

        [ValidateLength(0, 256)]
        [string]$KQLDashboardDescription

    )

begin {
    # Check if session is established - if not throw error
    if ($null -eq $RTISession.headerParams) {
        throw "No session established to Fabric Real-Time Intelligence. Please run Connect-RTISession"
    }

    # Create body of request
    $body = @{
        'displayName' = $KQLDashboardName
        'description' = $KQLDashboardDescription
    } | ConvertTo-Json `
            -Depth 1

    # Create KQLDashboard API URL
    $KQLDashboardApiUrl = "$($RTISession.BaseFabricUrl)/v1/workspaces/$WorkspaceId/KQLDashboards" 
    }

process {

    # Call KQLDashboard API
    $response = Invoke-RestMethod `
                        -Headers $RTISession.headerParams `
                        -Method POST `
                        -Uri $KQLDashboardApiUrl `
                        -Body ($body) `
                        -ContentType "application/json"

    $response
}

end {}

}