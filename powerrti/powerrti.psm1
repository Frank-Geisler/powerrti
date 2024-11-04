<#
.DESCRIPTION
Powershell Modul that provides cmdlets to interact with the Real-Time Intelligence API 
of Microsoft Fabric.
#>
$scriptRoot = $PSScriptRoot + '\Public'

Get-ChildItem $scriptRoot *.ps1 | ForEach-Object {
    . $_.FullName
}

$scriptRoot = $PSScriptRoot + '\Private'

Get-ChildItem $scriptRoot *.ps1 | ForEach-Object {
    . $_.FullName
}

$RTISession = [ordered]@{
    BaseFabricUrl       = 'https://api.fabric.microsoft.com'
    FabricToken         = $null
    HeaderParams        = $null
    ContentType         = @{'Content-Type' = "application/json"}
}