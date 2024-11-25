function New-RtiEventhouse {
#Requires -Version 7.1

<#
.SYNOPSIS
    Creates a new Fabric Eventhouse

.DESCRIPTION
    Creates a new Fabric Eventhouse

.PARAMETER WorkspaceID
    Id of the Fabric Workspace for which the Eventhouse should be created. The value for WorkspaceID is a GUID.
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.PARAMETER EventhouseName
    The name of the Eventhouse to create.

.PARAMETER EventhouseDescription
    The description of the Eventhouse to create.

.EXAMPLE
    New-RtiEventhouse `
        -WorkspaceID '12345678-1234-1234-1234-123456789012' `
        -EventhouseName 'MyEventhouse' `
        -EventhouseDescription 'This is my Eventhouse'

    This example will create a new Eventhouse with the name 'MyEventhouse' and the description 'This is my Eventhouse'.

.NOTES
    Revsion History:

    - 2024-11-07 - FGE: Implemented SupportShouldProcess
    - 2024-11-09 - FGE: Added DisplaName as Alias for EventhouseName


.LINK
    https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/create-eventhouse?tabs=HTTP
#>

[CmdletBinding(SupportsShouldProcess)]
    param (

        [Parameter(Mandatory=$true)]
        [string]$WorkspaceID,

        [Parameter(Mandatory=$true)]
        [Alias("Name", "DisplayName")]
        [string]$EventhouseName,

        [ValidateLength(0, 256)]
        [Alias("Description")]
        [string]$EventhouseDescription
    )

begin {
    Write-Verbose "Checking if session is established. If not throw error"
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
    $eventhouseApiUrl = "$($RTISession.BaseFabricUrl)/v1/workspaces/$WorkspaceId/eventhouses"
    }

process {

    # Call Eventhouse API
    if($PSCmdlet.ShouldProcess($EventhouseName)) {
        $response = Invoke-RestMethod `
                            -Headers $RTISession.headerParams `
                            -Method POST `
                            -Uri $eventhouseApiUrl `
                            -Body ($body) `
                            -ContentType "application/json"

        $response
    }
}

end {}

}