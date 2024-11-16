function Get-RtiKQLDashboardDefinition {
#Requires -Version 7.1

<#
.SYNOPSIS
    Retrieves Fabric KQLDashboard Definitions for a given KQLDashboard.

.DESCRIPTION
    Retrieves the Definition of the Fabric KQLDashboard that is specified by the KQLDashboardName or KQLDashboardID.
    The KQLDashboard Definition contains the parts of the KQLDashboard, which are the visualizations and their configuration.
    This is provided as a JSON object.

.PARAMETER WorkspaceId
    Id of the Fabric Workspace in which the KQLDashboard exists. The value for WorkspaceId is a GUID. 
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.PARAMETER KQLDashboardName
    The name of the KQLDashboard to retrieve. This parameter cannot be used together with KQLDashboardID.

.PARAMETER KQLDashboardID
    The Id of the KQLDashboard to retrieve. This parameter cannot be used together with KQLDashboardName. The value for KQLDashboardID is a GUID. 
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.EXAMPLE
    Get-RtiKQLDashboardDefinition `
        -WorkspaceId "12345678-1234-1234-1234-123456789012" `
        -KQLDashboardName "MyKQLDashboard"

    This example retrieves the KQLDashboard Definition for the KQLDashboard named "MyKQLDashboard" in the 
    Workspace with the ID "12345678-1234-1234-1234-123456789012".

.EXAMPLE
    $db = Get-RtiKQLDashboardDefinition `
            -WorkspaceId "12345678-1234-1234-1234-123456789012" `
            -KQLDashboardName "MyKQLDashboard"

     $db[0].payload | `
        Set-Content `
            -Path "C:\temp\mydashboard.json" 

    This example retrieves the KQLDashboard Definition for the KQLDashboard named "MyKQLDashboard" in the
    Workspace with the ID "12345678-1234-1234-1234-123456789012". 
    The definition is saved to a file named "mydashboard.json".


.NOTES

    Revision History:
        - 2024-11-16 - FGE: First version
#>


[CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$WorkspaceId,

        [Alias("Name","DisplayName")]
        [string]$KQLDashboardName,

        [Alias("Id")]
        [string]$KQLDashboardId,

        [string]$Format
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

    $KQLDashboardAPIKQLDashboardId = "$($RTISession.BaseFabricUrl)/v1/workspaces/$WorkspaceId/KQLDashboards/$KQLDashboardId/getDefinition" 

    $body = @{
    } | ConvertTo-Json `
            -Depth 1

}

process {

    if ($PSBoundParameters.ContainsKey("KQLDashboardId")) {

        $response = Invoke-RestMethod `
                    -Headers $RTISession.headerParams `
                    -Method POST `
                    -Uri $KQLDashboardAPIKQLDashboardId `
                    -Body $null `
                    -ContentType "application/json"
                
        $parts = $response.definition.parts

        foreach ($part in $parts) {
            $bytes = [System.Convert]::FromBase64String($part.payload)
            $decodedText = [System.Text.Encoding]::UTF8.GetString($bytes)

            $part.payload = $decodedText
        }

        $parts
    }
}

end {}

}