# Invoke-RtiKQLCommand

## SYNOPSIS
Executes a KQL command in a Kusto Database.

## SYNTAX

```
Invoke-RtiKQLCommand [[-WorkspaceId] <String>] [[-KQLDatabaseName] <String>] [[-KQLDatabaseId] <String>]
 [[-KQLCommand] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Executes a KQL command in a Kusto Database.
The KQL command is executed in the Kusto Database 
that is specified by the KQLDatabaseName or KQLDatabaseId parameter.
The KQL command is executed 
in the context of the Fabric Real-Time Intelligence session that is established by the 
Connect-RTISession cmdlet.

## EXAMPLES

### EXAMPLE 1
```
Invoke-RtiKQLCommand `
    -WorkspaceId '12345678-1234-1234-1234-123456789012' `
    -KQLDatabaseName 'MyKQLDatabase' `
    -KQLCommand '.create table MyTable (MyColumn: string)'
```

This example will create a table named 'MyTable' with a column named 'MyColumn' in 
the KQLDatabase 'MyKQLDatabase'.

## PARAMETERS

### -KQLCommand
The KQL command that should be executed in the Kusto Database. 
The KQL command is a string.
An example of a string is '.create table MyTable (MyColumn: string)'.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -KQLDatabaseId
The Id of the KQLDatabase in which the KQL command should be executed.
This parameter cannot be used together with KQLDatabaseName. 
The value for KQLDatabaseId is a GUID.
An example of a GUID is '12345678-1234-1234-1234-123456789012'.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -KQLDatabaseName
The name of the KQLDatabase in which the KQL command should be executed.
This parameter cannot be used together with KQLDatabaseId.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: System.Management.Automation.ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WorkspaceId
Id of the Fabric Workspace for which the KQL command should be executed.
The value for WorkspaceId is a GUID. 
An example of a GUID is '12345678-1234-1234-1234-123456789012'.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
