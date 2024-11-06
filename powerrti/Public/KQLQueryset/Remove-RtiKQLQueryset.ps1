function Remove-RtiKQLQueryset {
#Requires -Version 7.1

<#
.SYNOPSIS
    Removes an existing Fabric KQLQueryset.

.DESCRIPTION
    Removes an existing Fabric KQLQueryset. The Eventhouse is identified by the WorkspaceId and KQLQuerysetId.

.PARAMETER WorkspaceId
    Id of the Fabric Workspace for which the KQLQueryset should be removed. The value for WorkspaceId is a GUID. 
    An example of a GUID is '12345678-1234-1234-1234-123456789012'. This parameter is mandatory.

.PARAMETER KQLQuerysetId
    The Id of the KQLQueryset to remove. The value for KQLQuerysetId is a GUID. An example of a GUID is '12345678-1234-1234-1234-123456789012'.
    This parameter is mandatory.
    
.EXAMPLE
    Remove-RtiKQLQueryset `
        -WorkspaceId '12345678-1234-1234-1234-123456789012' `
        -KQLQuerysetId '12345678-1234-1234-1234-123456789012'

.NOTES
    TODO: Add functionality to remove Eventhouse by name.

#>


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