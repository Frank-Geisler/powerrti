function Get-RtiDebugInfo {
    #Requires -Version 7.1

<#
.SYNOPSIS
    Shows internal debug information about the current session.

.DESCRIPTION
    Shows internal debug information about the current session. It is useful for troubleshooting purposes.
    It will show you the current session object. This includes the bearer token. This can be useful
    for connecting to the REST API directly via Postman.

.Example
    Get-RtiDebugInfo

    This example shows the current session object.
    
#>

[CmdletBinding()]
    param (

    )

begin {
}

process {
    $RTISession
}

end {
}

}