$basepath = 'C:\Users\fgeisler\repos\github\powerrit\powerrti'

Invoke-ScriptAnalyzer `
    -Path $basepath `
    -Recurse `
    -Severity All