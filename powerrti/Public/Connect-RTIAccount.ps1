function Connect-RTIAccount {
#Requires -Version 7.1

<#
.SYNOPSIS
    Connects to the Real-Time Intelligence WebAPI.
.DESCRIPTION
    Connects to the Real-Time Intelligence WebAPI.
.EXAMPLE
    Connect-RTIAccount `
        -TenantID '12345678-1234-1234-1234-123456789012'
#>

[CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$TenantID
    )

begin {
}

process {
    Connect-AzAccount `
            -TenantId $TenantId | `
                Out-Null

    # Get authentication token
    $RTISession.FabricToken = (Get-AzAccessToken `
                                    -ResourceUrl $RTISession.BaseFabricUrl).Token

    # Setup headers for API call
    $RTISession.HeaderParams = @{'Authorization'="Bearer {0}" -f $RTISession.FabricToken}

}

end {}

}