function Set-RtiKQLDatabase {
#Requires -Version 7.1

<#
.SYNOPSIS
    Updates Properties of an existing Fabric KQLDatabase

.DESCRIPTION
    Updates Properties of an existing Fabric KQLDatabase. The KQLDatabase is updated 
    in the specified Workspace. The KQLDatabaseId is used to identify the KQLDatabase
    that should be updated. The KQLDatabaseNewName and KQLDatabaseDescription are the 
    properties that can be updated.

.PARAMETER WorkspaceId
    Id of the Fabric Workspace for which the KQLDatabase should be updated. The value for WorkspaceId is a GUID. 
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.PARAMETER KQLDatabaseId
    The Id of the KQLDatabase to update. The value for KQLDatabaseId is a GUID. 
    An example of a GUID is '12345678-1234-123-1234-123456789012'.

.PARAMETER KQLDatabaseNewName
    The new name of the KQLDatabase.

.PARAMETER KQLDatabaseDescription
    The new description of the KQLDatabase. The description can be up to 256 characters long.

.EXAMPLE
    Set-RtiKQLDatabase `
        -WorkspaceId '12345678-1234-1234-1234-123456789012' `
        -KQLDatabaseId '12345678-1234-1234-1234-123456789012' `
        -KQLDatabaseNewName 'MyNewKQLDatabase' `
        -KQLDatabaseDescription 'This is my new KQLDatabase'

    This example will update the KQLDatabase with the Id '12345678-1234-1234-1234-123456789012'.
    It will update the name to 'MyNewKQLDatabase' and the description to 'This is my new KQLDatabase'.

.NOTES

    Revsion History:
    
    - 2024-11-07 - FGE: Implemented SupportShouldProcess
    - 2024-11-09 - FGE: Added DisplaName as Alias for KQLDatabaseName

.LINK
 
#>

[CmdletBinding(SupportsShouldProcess)]
    param (

        [Parameter(Mandatory=$true)]
        [string]$WorkspaceId, 

        [Parameter(Mandatory=$true)]
        [Alias("Id")]
        [string]$KQLDatabaseId, 
        
        [Alias("Name", "DisplayName")]
        [string]$KQLDatabaseName,

        [Alias("Description")]
        [ValidateLength(0, 256)]
        [string]$KQLDatabaseDescription
        
    )

begin {
    # Check if session is established - if not throw error
    if ($null -eq $RTISession.headerParams) {
        throw "No session established to Fabric Real-Time Intelligence. Please run Connect-RTISession"
    }

    # Create body of request
    $body = @{}

    if ($PSBoundParameters.ContainsKey("KQLDatabaseName")) {
        $body["displayName"] = $KQLDatabaseName
    }

    if ($PSBoundParameters.ContainsKey("KQLDatabaseDescription")) {
        $body["description"] = $KQLDatabaseDescription
    }

    $body = $body `
                | ConvertTo-Json `
                    -Depth 1

    # Create KQLDatabase API URL
    $KQLDatabaseApiUrl = "$($RTISession.BaseFabricUrl)/v1/workspaces/$WorkspaceId/KQLDatabases/$KQLDatabaseId" 
    }

process {

    # Call KQLDatabase API
    if($PSCmdlet.ShouldProcess($EventhouseName)) {
        $response = Invoke-RestMethod `
                            -Headers $RTISession.headerParams `
                            -Method PATCH `
                            -Uri $KQLDatabaseApiUrl `
                            -Body ($body) `
                            -ContentType "application/json"

        $response
    }
}

end {}

}