function Remove-RtiKQLDatabase {
#Requires -Version 7.1

<#
.SYNOPSIS
    Removes an existing Fabric Eventhouse

.DESCRIPTION
    Removes an existing Fabric Eventhouse. The Eventhouse is removed from the specified Workspace.

.PARAMETER WorkspaceId
    Id of the Fabric Workspace from which the Eventhouse should be removed. The value for WorkspaceId is a GUID.
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.PARAMETER EventhouseId
    The Id of the Eventhouse to remove. The value for EventhouseId is a GUID.
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.EXAMPLE
    Remove-RtiEventhouse `
        -WorkspaceId '12345678-1234-1234-1234-123456789012' `
        -EventhouseId '12345678-1234-1234-1234-123456789012'

    This example will remove the Eventhouse with the Id '12345678-1234-1234-1234-123456789012'.

.NOTES
    TODO: Add functionality to remove Eventhouse by name.

#>


[CmdletBinding(SupportsShouldProcess)]
    param (

        [Parameter(Mandatory=$true)]
        [string]$WorkspaceId,

        [Parameter(Mandatory=$true)]
        [Alias("Id")]
        [string]$KQLDatabaseId

    )

begin {
    # Check if session is established - if not throw error
    if ($null -eq $RTISession.headerParams) {
        throw "No session established to Fabric Real-Time Intelligence. Please run Connect-RTISession"
    }

    # Create Eventhouse API URL
    $eventhouseApiUrl = "$($RTISession.BaseFabricUrl)/v1/workspaces/$WorkspaceId/KQLDatabases/$KQLDatabaseId"

    }

process {

    if($PSCmdlet.ShouldProcess($KQLDatabaseId)) {
        # Call Eventhouse API
        $response = Invoke-RestMethod `
                            -Headers $RTISession.headerParams `
                            -Method DELETE `
                            -Uri $eventhouseApiUrl `
                            -ContentType "application/json"

        $response
    }
}

end {}

}