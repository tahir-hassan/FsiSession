using namespace System.Text
using namespace System.IO
using namespace System.Diagnostics.CodeAnalysis

Function New-FsiSession {
    [SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
	param(
		[string]$WorkingDirectory = ".",
		[string[]]$IncludePath = @()
	)

	$sbOut = [StringBuilder]::new()
	$sbErr = [StringBuilder]::new()
	$inReader = [StringReader]::new("")
	$outWriter = [StringWriter]::new($sbOut)
	$errWriter = [StringWriter]::new($sbErr)
	$allArgs = "fsi","--noninteractive","--gui-"

	if ($IncludePath.Count) {
		$allArgs += @(
		"--lib:$(($IncludePath | foreach { Resolve-Path $_ }) -join ';')");
	}

	$fsiConfig = [FSharp.Compiler.Interactive.Shell+FsiEvaluationSession]::GetDefaultConfiguration()

	try {
		$savedCurrentDirectory = [System.Environment]::CurrentDirectory;
		[System.Environment]::CurrentDirectory = (Resolve-Path $WorkingDirectory).Path;

		$fsiSession = [FSharp.Compiler.Interactive.Shell+FsiEvaluationSession]::Create($fsiConfig, $allArgs, $inReader, $outWriter, $errWriter, $null, $null);
		$fsiSession | Add-Member -NotePropertyMembers @{
			InReader = $inReader
			OutStringBuilder = $sbOut
			ErrorStringBuilder = $sbErr
			OutWriter = $outWriter
			ErrorWriter = $errWriter
		};
		$fsiSession;
	}
	finally {
		[System.Environment]::CurrentDirectory = $savedCurrentDirectory;
	}
}

Function Invoke-FsiSession {
    [CmdletBinding(DefaultParameterSetName = 'Expression')]
    param(
        [Parameter(Mandatory, ParameterSetName = 'Expression', Position = 0)]
        [Parameter(Mandatory, ParameterSetName = 'Interaction', Position = 0)]
        [Parameter(Mandatory, ParameterSetName = 'Path', Position = 0)]
        [Parameter(Mandatory, ParameterSetName = 'LiteralPath', Position = 0)]
		$Session,

        [Parameter(Mandatory, ParameterSetName = 'Expression')]
        [string]$Expression,

        [Parameter(Mandatory, ParameterSetName = 'Interaction')]
        [string]$Interaction,

        [Parameter(Mandatory, ParameterSetName = 'Path')]
        [string]$Path,

        [Parameter(Mandatory, ParameterSetName = 'LiteralPath')]
        [string]$LiteralPath,

		[Parameter(ParameterSetName = 'Expression')]
		[Parameter(ParameterSetName = 'Interaction')]
		[Parameter(ParameterSetName = 'Path')]
		[Parameter(ParameterSetName = 'LiteralPath')]
		[hashtable]$Values
    )

	if ($PSBoundParameters.ContainsKey('Values')) {
		foreach ($key in $Values.Keys) {
			$session.AddBoundValue($key, $Values[$key]);
		}
	}

    $result = switch ($PSCmdlet.ParameterSetName) {
        'Expression' {
			$session.EvalExpressionNonThrowing($Expression);
		}
        'Interaction' {
			#
			$session.EvalInteractionNonThrowing($Interaction, $null);
		}
        'Path' {
			$resolvedPath = (Resolve-Path $Path).Path;
			$session.EvalScriptNonThrowing($resolvedPath);
		}
        'LiteralPath' {
			$session.EvalScriptNonThrowing($LiteralPath);
		}
    }
	if ($result.Item1.IsChoice2Of2) {
		Write-Error $result.Item2.Message;
		$result.Item2;
	} elseif ($result.Item1.Item) {
		$result.Item1.Item.Value.ReflectionValue
	}
}

Function Remove-FsiSession {
    [SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
	param(
        [Parameter(Mandatory)]
		$Session
	)

	$Session.Dispose();
}
