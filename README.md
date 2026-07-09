# FsiSession

Given a file `Sample.fsx` with the following content:

```fsharp
let twenty = 10 + 10
```

with this module you can do:

```powershell
$session = New-FsiSession
Invoke-FsiSession $session -Path Sample.fsx
Invoke-FsiSession $session -Expression Sample.twenty
```

and you will get the result `20`.

When calling `New-FsiSession` you can provide `IncludePath` to a folder containing your scripts, and then for `Invoke-FsiSession` you can pass `LiteralPath` to a path to a script in an included path.  If you use `Path` then it will resolve the path.


## Benefits

This module lets you create an F# Interactive session, load scripts and evaluate expressions, directly from PowerShell. Running `dotnet fsi <script>` faces a significant startup cost each time it is run, so re-using the same session will be faster. 
