# Set-RtiKQLQueryset

## SYNOPSIS
Updates Properties of an existing Fabric KQLQueryset

## SYNTAX

```
Set-RtiKQLQueryset [-WorkspaceId] <String> [-KQLQuerysetId] <String> [[-KQLQuerysetName] <String>]
 [[-KQLQuerysetDescription] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Updates Properties of an existing Fabric KQLQueryset.
The KQLQueryset is identified by 
the WorkspaceId and KQLQuerysetId.

## EXAMPLES

### EXAMPLE 1
```
Set-RTIKQLQueryset `
    -WorkspaceId '12345678-1234-1234-1234-123456789012' `
    -KQLQuerysetId '12345678-1234-1234-1234-123456789012' `
    -KQLQuerysetNewName 'MyKQLQueryset' `
    -KQLQuerysetDescription 'This is my KQLQueryset'
```

This example will update the KQLQueryset.
The KQLQueryset will have the name 'MyKQLQueryset'
and the description 'This is my KQLQueryset'.

## PARAMETERS

### -KQLQuerysetDescription
The new description of the KQLQueryset.
This parameter is optional.

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

### -KQLQuerysetId
The Id of the KQLQueryset to update.
The value for KQLQuerysetId is a GUID.
An example of a GUID is '12345678-1234-1234-1234-123456789012'.
This parameter is mandatory.

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

### -KQLQuerysetName
The new name of the KQLQueryset.
This parameter is optional.

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
Id of the Fabric Workspace for which the KQLQueryset should be updated.
The value for WorkspaceId is a GUID. 
An example of a GUID is '12345678-1234-1234-1234-123456789012'.
This parameter is mandatory.

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

[https://learn.microsoft.com/en-us/rest/api/fabric/KQLQueryset/items/create-KQLQueryset?tabs=HTTP](https://learn.microsoft.com/en-us/rest/api/fabric/KQLQueryset/items/create-KQLQueryset?tabs=HTTP)

