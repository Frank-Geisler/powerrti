function Get-RtiKQLDashboard {
#Requires -Version 7.1

<#
.SYNOPSIS
    Retrieves Fabric KQLDashboards

.DESCRIPTION
    Retrieves Fabric KQLDashboards

.EXAMPLE
    Get-RTIKQLDashboard

#>

#TODO: Add functionality to list all KQLDashboards. To do so fetch all workspaces and 
#      then all KQLDashboards in each workspace.

[CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$WorkspaceId,

        [string]$KQLDashboardName,

        [string]$KQLDashboardId
    )

begin {

    # Check if session is established - if not throw error
    if ($null -eq $RTISession.headerParams) {
        throw "No session established to Fabric Real-Time Intelligence. Please run Connect-RTISession"
    }

    # You can either use Name or WorkspaceID
    if ($PSBoundParameters.ContainsKey("KQLDashboardName") -and $PSBoundParameters.ContainsKey("KQLDashboardId")) {
        throw "Parameters KQLDashboardName and KQLDashboardId cannot be used together"    
    }

    # Create KQLDashboard API
    $KQLDashboardAPI = "$($RTISession.BaseFabricUrl)/v1/workspaces/$WorkspaceId/KQLDashboards" 

    $KQLDashboardAPIKQLDashboardId = "$($RTISession.BaseFabricUrl)/v1/workspaces/$WorkspaceId/KQLDashboards/$KQLDashboardId" 

}

process {

    if ($PSBoundParameters.ContainsKey("KQLDashboardId")) {

        $response = Invoke-RestMethod `
                    -Headers $RTISession.headerParams `
                    -Method GET `
                    -Uri $KQLDashboardAPIKQLDashboardId `
                    -ContentType "application/json"
                
        $response
    }
    else {
        # Call Workspace API
        $response = Invoke-RestMethod `
                    -Headers $RTISession.headerParams `
                    -Method GET `
                    -Uri $KQLDashboardAPI `
                    -ContentType "application/json"

        if ($PSBoundParameters.ContainsKey("KQLDashboardName")) {
            $response.value | `
                Where-Object { $_.displayName -eq $KQLDashboardName }
        }
        else {
            $response.value
        }
    }
}

end {}

}