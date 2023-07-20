<# 
.SYNOPSIS 
    Deobfuscate scripts or files that have been obfuscated using reordered format strings. 

.DESCRIPTION 
    This PowerShell script deobfuscates other PowerShell scripts that have been obfuscated using a technique where format strings are reordered. See: https://www.securonix.com/blog/hiding-the-powershell-execution-flow/

.NOTES 
    Use at your own risk. 
 
.LINK 
    https://github.com/bobby-tablez/Format-String-Deobfuscator

.Parameter f 
    Specifies the PowerShell file name to deobfuscate. The deobfuscated lines will appear as console output. Lines with no format strings will be ignored.
    
.Example 
    # Example: Deobfuscate a file:
    fs_deobfuscator.ps1 -f oobfuscated_file.ps1

.Parameter s 
    Specifies the script to deobfuscate. Supply a format string directly as a parameter.
    
.Example 
    # Example: Deobfuscate a script one-liner:
    fs_deobfuscator.ps1 -s '(  "{0}{3}{4}{1}{2}" -f "S","Mo","de","et-Stri","ct")'

.Parameter b 
    Specifies the script to deobfuscate that is base64 encoded. This is useful when quotation marks could potentially break formatting when reading in parameters in PowerShell.

.Example 
    # Example: Deobfuscate a script one-liner that is base64 encoded:
    fs_deobfuscator.ps1 -b KCAiIHswfXszfXs0fXsxfXsyfSAiIC1mICdTJywnTW8nLCdkZScsJ2V0LVN0cmlkJywnY3QnICk=
#>

Param(
    [Parameter(Mandatory=$false)]
    [string]$f,

    [Parameter(Mandatory=$false)]
    [string]$s,

    [Parameter(Mandatory=$false)]
    [string]$b
)

Function formatString ($line, $lineNum) {
    $parser = '\(\s*"\s*\{(.+?)\}\s*"\s*-f\s*(.+?)\s*\)' 
    $fsLine = [regex]::Matches($line, $parser)

    Foreach($match in $fsLine) {
        $formatExp = $match.Value
        Try {
            $deobfuscated = Invoke-Expression $formatExp
            If ($lineNum -eq 0 ) {
                Write-Host -f Yellow "`nDeobfuscated string`:"
                Write-Host $deobfuscated
            } Else {
                Write-Host -f Yellow "`nLine $lineNum`:"
                Write-Host $deobfuscated
            }
        } Catch {
            Write-Host -f Red "A format string detected, but an error occured at line: $lineNum $formatExp`n"
        }
    Write-Host ""
    }
    
}

If ($f) {
    If (-not (Test-Path $f)) {
        Throw "File not found: $f"
    }

    $inFile = Get-Content -Path $f
    $lineNum = 0

    Foreach($line in $inFile){
        $lineNum++
        formatString $line $lineNum
    }
}
Elseif ($s) {
    formatString $s 0
}
Elseif ($b) {
    $decode = [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($b))
    formatString $decode 0
}
Else {
    Throw "Please provide a valid parameter -f (file) -s (string) -b (base64 string)."
}

   
