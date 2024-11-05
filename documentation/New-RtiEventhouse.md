# New-RtiEventhouse

## SYNOPSIS
Creates a new Fabric Eventhouse

## SYNTAX

```
New-RtiEventhouse [-WorkspaceID] <String> [-EventhouseName] <String> [[-EventhouseDescription] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Creates a new Fabric Eventhouse

## EXAMPLES

### EXAMPLE 1
```
New-RtiEventhouse `
    -WorkspaceID '12345678-1234-1234-1234-123456789012' `
    -EventhouseName 'MyEventhouse' `
    -EventhouseDescription 'This is my Eventhouse'
```

This example will create a new Eventhouse with the name 'MyEventhouse' and the description 'This is my Eventhouse'.

## PARAMETERS

### -EventhouseDescription
The description of the Eventhouse to create.

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

### -EventhouseName
The name of the Eventhouse to create.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
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

### -WorkspaceID
Id of the Fabric Workspace for which the Eventhouse should be created.
The value for WorkspaceID is a GUID. 
An example of a GUID is '12345678-1234-1234-1234-123456789012'.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
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

[https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/create-eventhouse?tabs=HTTP](https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/create-eventhouse?tabs=HTTP)

