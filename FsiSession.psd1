@{
    RootModule            = 'FsiSession.psm1'
    ModuleVersion         = '0.1'
    CompatiblePSEditions  = @('Core')
    GUID                  = '925ded4a-2447-4bac-bc54-757f7054d414'
    Author                = 'Tahir Hassan'
    Description           = 'Module for creating an Fsi session instance'
    PowerShellHostVersion = '7.0.0'
    RequiredAssemblies    = @('FSharp.Compiler.Service.dll', 'FSharp.Core.dll')
    FunctionsToExport     = @('New-FsiSession', 'Invoke-FsiSession', 'Remove-FsiSession')
    CmdletsToExport       = @()
    AliasesToExport       = @()
    FileList              = @('FSharp.Compiler.Service.dll', 'FSharp.Core.dll', 'FsiSession.psm1', 'FsiSession.psd1')
}

