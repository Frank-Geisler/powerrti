# New-RtiKQLDashboard

## SYNOPSIS
Creates a new Fabric KQLDashboard

## SYNTAX

```
New-RtiKQLDashboard [-WorkspaceID] <String> [-KQLDashboardName] <String> [[-KQLDashboardDescription] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Creates a new Fabric KQLDashboard

## EXAMPLES

### EXAMPLE 1
```
New-RtiDashboard `
    -WorkspaceID '12345678-1234-1234-1234-123456789012' `
    -KQLDashboardName 'MyKQLDashboard' `
    -KQLDashboardDescription 'This is my KQLDashboard'
```

This example will create a new KQLDashboard with the name 'MyKQLDashboard' and the description 'This is my KQLDashboard'.

## PARAMETERS

### -KQLDashboardDescription
The description of the KQLDashboard to create.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases: Description

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -KQLDashboardName
The name of the KQLDashboard to create.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases: Name

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
Id of the Fabric Workspace for which the KQLDashboard should be created.
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
