function Invoke-RtiKQLCommand {
#Requires -Version 7.1

<#
.SYNOPSIS
    Executes a KQL command in a Kusto Database.

.DESCRIPTION
    Executes a KQL command in a Kusto Database. The KQL command is executed in the Kusto Database
    that is specified by the KQLDatabaseName or KQLDatabaseId parameter. The KQL command is executed
    in the context of the Fabric Real-Time Intelligence session that is established by the
    Connect-RTISession cmdlet.

.PARAMETER WorkspaceId
    Id of the Fabric Workspace for which the KQL command should be executed. The value for WorkspaceId is a GUID.
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.PARAMETER KQLDatabaseName
    The name of the KQLDatabase in which the KQL command should be executed. This parameter cannot be used together with KQLDatabaseId.

.PARAMETER KQLDatabaseId
    The Id of the KQLDatabase in which the KQL command should be executed. This parameter cannot be used together with KQLDatabaseName.
    The value for KQLDatabaseId is a GUID. An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.PARAMETER KQLCommand
    The KQL command that should be executed in the Kusto Database.
    The KQL command is a string. An example of a string is '.create table MyTable (MyColumn: string)'.

.EXAMPLE
    Invoke-RtiKQLCommand `
        -WorkspaceId '12345678-1234-1234-1234-123456789012' `
        -KQLDatabaseName 'MyKQLDatabase' `
        -KQLCommand '.create table MyTable (MyColumn: string)'

    This example will create a table named 'MyTable' with a column named 'MyColumn' in
    the KQLDatabase 'MyKQLDatabase'.

.NOTES

    Revsion History:

    - 2024-12-22 - FGE: Added Verbose Output

#>

[CmdletBinding()]
    param (

        [string]$WorkspaceId,

        [string]$KQLDatabaseName,

        [string]$KQLDatabaseId,

        [string]$KQLCommand
    )

begin {

    Write-Verbose "Check if session is established - if not throw error"
    if ($null -eq $RTISession.headerParams) {
        throw "No session established to Fabric Real-Time Intelligence. Please run Connect-RTISession"
    }

    Write-Verbose "Check if KQLDatabaseName and KQLDatabaseId are used together"
    if ($PSBoundParameters.ContainsKey("KQLDatabaseName") -and $PSBoundParameters.ContainsKey("KQLDatabaseId")) {
        throw "Parameters KQLDatabaseName and KQLDatabaseId cannot be used together"
    }

    Write-Verbose "Get Kusto Database"
    if ($PSBoundParameters.ContainsKey("KQLDatabaseName")) {
        Write-Verbose "Getting Kusto Database by Name: $KQLDatabaseName"
        $kustDB = Get-RtiKQLDatabase `
                        -WorkspaceId $WorkspaceId `
                        -KQLDatabaseName $KQLDatabaseName
    }

    if ($PSBoundParameters.ContainsKey("KQLDatabaseId")) {
        Write-Verbose "Getting Kusto Database by Id: $KQLDatabaseId"
        $kustDB = Get-RtiKQLDatabase `
                        -WorkspaceId $WorkspaceId `
                        -KQLDatabaseId $KQLDatabaseId
    }

    Write-Verbose "Check if Kusto Database was found"
    if ($null -eq $kustDB) {
        throw "Kusto Database not found"
    }
}

process {

    Write-Verbose "Authenticate against Kusto"
    $kustoToken = (Get-AzAccessToken `
                        -ResourceUrl $RTISession.KustoURL).Token

    $headerParams = @{'Authorization'="Bearer {0}" -f $kustoToken}

    Write-Verbose "Generate the query API URL"
    $queryAPI = "$($kustDB.queryServiceUri)/v1/rest/mgmt"

    $KQLCommand = $KQLCommand | Out-String

    Write-Verbose "It is crucial to have the .execute database script <| in the beginning, otherwise the Kusto API will not execute the script."
    if (-not ($KQLCommand -match "\.execute database script <\|")) {
        $KQLCommand = ".execute database script <| $KQLCommand"
    }

    Write-Verbose "The KQL-Command is: $KQLCommand"

    Write-Verbose "Create body of the request"
    $body = @{
    'csl' = $KQLCommand;
    'db'= $kustDB.displayName
    } | ConvertTo-Json -Depth 1

    Write-Verbose "Calling Query API"
    Write-Verbose "-----------------"
    Write-Verbose "Sending the following values to the Query API:"
    Write-Verbose "Headers: $($Rtisession.headerParams | Format-List | Out-String)"
    Write-Verbose "Method: POST"
    Write-Verbose "URI: $queryAPI"
    Write-Verbose "Body of request: $body"    
    Write-Verbose "ContentType: application/json"

    Invoke-RestMethod `
        -Headers $headerParams `
        -Method POST `
        -Uri $queryAPI `
        -Body ($body) `
        -ContentType "application/json; charset=utf-8"
}

end {}

}