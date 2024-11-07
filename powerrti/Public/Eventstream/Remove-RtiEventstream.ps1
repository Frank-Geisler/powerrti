function Remove-RtiEventstream {
#Requires -Version 7.1

<#
.SYNOPSIS
    Removes an existing Fabric Eventstream

.DESCRIPTION
    Removes an existing Fabric Eventstream

.PARAMETER WorkspaceId
    Id of the Fabric Workspace for which the Eventstream should be deleted. The value for WorkspaceId is a GUID. 
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.PARAMETER EventstreamId
    The Id of the Eventstream to delete. The value for Eventstream is a GUID. 
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.EXAMPLE
    Remove-RtiEventstream `
        -WorkspaceId '12345678-1234-1234-1234-123456789012' `
        -EventstreamId '12345678-1234-1234-1234-123456789012'

    This example will delete the Eventstream with the Id '12345678-1234-1234-1234-123456789012' from
    the Workspace.

.EXAMPLE
    Remove-RtiEventstream `
        -WorkspaceId '12345678-1234-1234-1234-123456789012' `
        -EventstreamName 'MyEventstream'

    This example will delete the Eventstream with the name 'MyEventstream' from the Workspace.

.NOTES

    Revsion History:
    
    - 2024-11-07 - FGE: Implemented SupportShouldProcess

#>



[CmdletBinding(SupportsShouldProcess)]
    param (

        [Parameter(Mandatory=$true)]
        [string]$WorkspaceId, 
        
        [Alias("Id")]
        [string]$EventstreamId,

        [Alias("Name")]
        [string]$EventstreamName

    )

begin {
    # Check if session is established - if not throw error
    if ($null -eq $RTISession.headerParams) {
        throw "No session established to Fabric Real-Time Intelligence. Please run Connect-RTISession"
    }

     # You can either use EventstreamName or EventstreamID
    if ($PSBoundParameters.ContainsKey("EventstreamId") -and $PSBoundParameters.ContainsKey("EventstreamName")) {
        throw "Parameters EventstreamId and EventstreamName cannot be used together"    
    }

    if ($PSBoundParameters.ContainsKey("EventstreamName")) {
        $eh = Get-RtiEventstream `
                    -WorkspaceId $WorkspaceId `
                    -EventstreamName $EventstreamName

        $EventstreamId = $eh.id
    }

    # Create Eventhouse API URL
    $eventstreamApiUrl = "$($RTISession.BaseFabricUrl)/v1/workspaces/$WorkspaceId/eventstreams/$EventstreamId" 

}

process {

    # Call Eventstream API
    if($PSCmdlet.ShouldProcess($EventstreamName)) {
        $response = Invoke-RestMethod `
                            -Headers $RTISession.headerParams `
                            -Method DELETE `
                            -Uri $eventstreamApiUrl `
                            -ContentType "application/json"

        $response
    }
}

end {}

}