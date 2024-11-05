function Invoke-RtiKQLCommand {
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

        [string]$WorkspaceId,

        [string]$KQLDatabaseName,

        [string]$KQLDatabaseId,

        [string]$KQLCommand
    )

begin {

    # Check if session is established - if not throw error
    if ($null -eq $RTISession.headerParams) {
        throw "No session established to Fabric Real-Time Intelligence. Please run Connect-RTISession"
    }

    if ($PSBoundParameters.ContainsKey("KQLDatabaseName") -and $PSBoundParameters.ContainsKey("KQLDatabaseId")) {
        throw "Parameters KQLDatabaseName and KQLDatabaseId cannot be used together"    
    }

    # FGE: Get Kusto Database
    if ($PSBoundParameters.ContainsKey("KQLDatabaseName")) {
        Write-Warning "Getting Kusto Database by Name"
        $kustDB = Get-RtiKQLDatabase `
                        -WorkspaceId $WorkspaceId `
                        -KQLDatabaseName $KQLDatabaseName
    }

    if ($PSBoundParameters.ContainsKey("KQLDatabaseId")) {
        Write-Warning "Getting Kusto Database by Id"
        $kustDB = Get-RtiKQLDatabase `
                        -WorkspaceId $WorkspaceId `
                        -KQLDatabaseId $KQLDatabaseId
    }

    if ($null -eq $kustDB) {
        throw "Kusto Database not found"
    }
}

process {

    # Authenticate against Kusto
    $kustoToken = (Get-AzAccessToken `
                        -ResourceUrl $RTISession.KustoURL).Token

    $headerParams = @{'Authorization'="Bearer {0}" -f $kustoToken}

    # FGE: Generate the query API URL
    $queryAPI = "$($kustDB.queryServiceUri)/v1/rest/mgmt"
    Write-Warning "Query API: $queryAPI"

    $kustDB

    $KQLCommand = $KQLCommand | Out-String

    # Create body of the request
    $body = @{
    'csl' = $KQLCommand;
    'db'= $kustDB.displayName
    } | ConvertTo-Json -Depth 1


    #     "properties": {
    #     "Options": {
    #         "maxmemoryconsumptionperiterator": 68719476736,
    #         "max_memory_consumption_per_query_per_node": 68719476736,
    #         "servertimeout": "50m"
    #     },
    #     "Parameters": {
    #         "n": 10, "d": "dynamic([\"ATLANTIC SOUTH\"])"
    #     }
    # }

    $body

    $headerParams

    # Call Kusto API to run entities creation script
    Invoke-RestMethod `
        -Headers $headerParams `
        -Method POST `
        -Uri $queryAPI `
        -Body ($body) `
        -ContentType "application/json; charset=utf-8"
}

end {}

}