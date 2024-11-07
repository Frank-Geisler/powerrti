function New-RtiKQLDashboard {
#Requires -Version 7.1

<#
.SYNOPSIS
    Creates a new Fabric KQLDashboard

.DESCRIPTION
    Creates a new Fabric KQLDashboard

.PARAMETER WorkspaceID
    Id of the Fabric Workspace for which the KQLDashboard should be created. The value for WorkspaceID is a GUID. 
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.PARAMETER KQLDashboardName
    The name of the KQLDashboard to create.

.PARAMETER KQLDashboardDescription
    The description of the KQLDashboard to create.

.EXAMPLE
    New-RtiDashboard `
        -WorkspaceID '12345678-1234-1234-1234-123456789012' `
        -KQLDashboardName 'MyKQLDashboard' `
        -KQLDashboardDescription 'This is my KQLDashboard'

    This example will create a new KQLDashboard with the name 'MyKQLDashboard' and the description 'This is my KQLDashboard'.	

.NOTES

    Revsion History:
    
    - 2024-11-07 - FGE: Implemented SupportShouldProcess
#>

[CmdletBinding(SupportsShouldProcess)]
    param (

        [Parameter(Mandatory=$true)]
        [string]$WorkspaceID, 
        
        [Parameter(Mandatory=$true)]
        [Alias("Name")]
        [string]$KQLDashboardName,

        [ValidateLength(0, 256)]
        [Alias("Description")]
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

    if($PSCmdlet.ShouldProcess($KQLDashboardName)) {
        # Call KQLDashboard API
        $response = Invoke-RestMethod `
                            -Headers $RTISession.headerParams `
                            -Method POST `
                            -Uri $KQLDashboardApiUrl `
                            -Body ($body) `
                            -ContentType "application/json"

        $response
    }
}

end {}

}