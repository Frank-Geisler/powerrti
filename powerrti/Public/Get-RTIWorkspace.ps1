function Get-RTIWorkspace {
#Requires -Version 7.1

<#
.SYNOPSIS
    Retrieves Fabric Workspaces
.DESCRIPTION
    Retrieves Fabric Workspaces
.EXAMPLE
    Get-RTIWorkspace 
#>

[CmdletBinding()]
    param (
        [string]$Name
    )

begin {
}

process {

# Create Workspace API
$workspaceAPI = 'https://api.fabric.microsoft.com/v1/admin/workspaces' 

# Call Eventhouse create API
$response = Invoke-RestMethod `
                -Headers $RTISession.headerParams `
                -Method GET `
                -Uri $workspaceAPI `
                -ContentType "application/json"


$response.Workspaces
}

end {}

}