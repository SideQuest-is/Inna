# InnaPs PowerShell Module
# Root module script that loads all public functions

$Public = @(Get-ChildItem -Path (Join-Path $PSScriptRoot 'Public' '*.ps1') -ErrorAction SilentlyContinue)

foreach ($import in $Public) {
    try {
        . $import.FullName
    }
    catch {
        Write-Error "Failed to import function $($import.FullName): $_"
    }
}
