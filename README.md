# Reordered Format String Deobfuscator
![format-string-deobfuscator](https://raw.githubusercontent.com/bobby-tablez/Format-String-Deobfuscator/main/fs_deobfuscator_header.png)

This script simply deobfuscates obfuscated PowerShell files or commands which leverage "Format String Reordering" in order to hide its original code. For more information on this obfuscation technique, see: https://www.securonix.com/blog/hiding-the-powershell-execution-flow/

The script has the ability to deobfuscate format strings in an entire file ( -f parameter) , or as one liners supplied in plain text ( -s ) or base64 encoded ( -b )



### Example: single script one-liner
```powershell
.\fs_deobfuscator.ps1 -s '(  "{0}{3}{4}{1}{2}" -f "S","Mo","de","et-Stri","ct")'
```
Output: `Set-StrictMode`
 


### Example: single script one-liner base64 encoded
```powershell
.\fs_deobfuscator.ps1 -b KCAiezB9ezN9ezR9ezF9ezJ9IiAtZiAnUycsJ01vJywnZGUnLCdldC1TdHJpJywnY3QnICk=
```
Output: `Set-StrictMode`



### Example: A sliver stager that has been obfuscated using Invoke-Obfuscation
```powershell
.\fs_deobfuscator.ps1 -f .\sliver_stager.ps1
```
Output:
```
Line 1:
Set-StrictMode

Line 18:
New-Object

Line 18:
Microsoft.CSharp.CSharpCodeProvider

Line 19:
New-Object

Line 19:
System.CodeDom.Compiler.CompilerParameters

Line 20:
System.dll

Line 24:
/EiD5PDozAAAAEFRQVBSUVZIMdJlSItSYEiLUhhIi1IgTTHJSA+3SkpIi3JQSDHArDxhfAIsIEHBy--[REDACTED]--/Vg/gAfShYQVdZaABAAABBWGoAWkG6Cy8PMP/VV1lBunVuTWH/1Un/zuk8////SAHDSCnGSIX2dbRB/+dYagBZScfC8LWiVv/V
```
![format-string-deobfuscator-example](https://raw.githubusercontent.com/bobby-tablez/Format-String-Deobfuscator/main/fs_deobfuscator.png)

Disclaimer: Use at your own risk.
