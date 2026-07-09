# FsiSession

Given a file `Sample.fsx` with the following content:

```fsharp
let twenty = 10 + 10
```

with this module you can do:

```powershell
$session = New-FsiSession
Invoke-FsiSession -Path Sample.fsx
Invoke-FsiSession -Expression Sample.twenty
```

and you will get the result `20`.

When calling `New-FsiSession` you can provide `IncludePath` to a folder containing your scripts, and then for `Invoke-FsiSession` you can pass `LiteralPath` to a path in one of those include paths.  If you use `Path` then it will resolve the path.


