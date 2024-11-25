function New-RtiWorkspace {
#Requires -Version 7.1

<#
.SYNOPSIS
    Creates a new Fabric Workspace

.DESCRIPTION
    Creates a new Fabric Workspace

.PARAMETER CapacityID
    Id of the Fabric Capacity for which the Workspace should be created. The value for CapacityID is a GUID. 
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.PARAMETER WorkspaceName
    The name of the Workspace to create. This parameter is mandatory.

.PARAMETER WorkspaceDescription
    The description of the Workspace to create.

.EXAMPLE
    New-RtiWorkspace `
        -CapacityID '12345678-1234-1234-1234-123456789012' `
        -WorkspaceName 'TestWorkspace' `
        -WorkspaceDescription 'This is a Test Workspace'

    This example will create a new Workspace with the name 'TestWorkspace' and the description 'This is a test workspace'.	

.NOTES

#>

[CmdletBinding(SupportsShouldProcess)]
    param (
        
        [Parameter(Mandatory=$true)]
        [string]$CapacityId,

        [Parameter(Mandatory=$true)]
        [Alias("Name", "DisplayName")]
        [string]$WorkspaceName,

        [ValidateLength(0, 4000)]
        [Alias("Description")]
        [string]$WorkspaceDescription
    )

begin {
    # Check if session is established - if not throw error
    if ($null -eq $RTISession.headerParams) {
        throw "No session established to Fabric Real-Time Intelligence. Please run Connect-RTISession"
    }

    # Create body of request
    $body = @{
        'displayName' = $WorkspaceName
        'description' = $WorkspaceDescription
        'capacityId'  = $CapacityId
    } | ConvertTo-Json `
            -Depth 1

    # Create Workspace API URL
    $WorkspaceApiUrl = "$($RTISession.BaseFabricUrl)/v1/workspaces"
    }

process {

    if($PSCmdlet.ShouldProcess($WorkspaceName)) {
        # Call Workspace API
        $response = Invoke-RestMethod `
                            -Headers $RTISession.headerParams `
                            -Method POST `
                            -Uri $WorkspaceApiUrl `
                            -Body ($body) `
                            -ContentType "application/json"

        $response
    }
}

end {}

}