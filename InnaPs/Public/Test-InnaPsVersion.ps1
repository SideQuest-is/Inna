function Test-InnaPsVersion {
    <#
    .SYNOPSIS
        Checks for a newer version of the InnaPs module and displays update instructions.

    .DESCRIPTION
        This function queries the GitHub API for the latest release of the InnaPs module
        and compares it against the currently installed version. If a newer version is
        available, it displays a friendly message with instructions on how to update.

    .EXAMPLE
        Test-InnaPsVersion
        Checks for updates and displays a message if a new version is available.

    .OUTPUTS
        Displays a message indicating whether the module is up to date or if an update
        is available, along with instructions on how to update.

    .NOTES
        Author: Sidequest.is
        Email: support@sidequest.is
    #>
    [CmdletBinding()]
    param()

    $moduleName = 'InnaPs'
    $repoOwner = 'SideQuest-is'
    $repoName = 'Inna'

    # Get the currently installed module version
    $currentModule = Get-Module -Name $moduleName -ListAvailable | Sort-Object Version -Descending | Select-Object -First 1

    if (-not $currentModule) {
        Write-Warning "The $moduleName module is not installed. Install it with:"
        Write-Host ""
        Write-Host "  Install-Module -Name $moduleName -Repository SideQuestGitHub" -ForegroundColor Cyan
        Write-Host ""
        return
    }

    $currentVersion = $currentModule.Version

    # Query GitHub API for the latest release
    try {
        $apiUrl = "https://api.github.com/repos/$repoOwner/$repoName/releases/latest"
        $release = Invoke-RestMethod -Uri $apiUrl -Method Get -Headers @{ 'User-Agent' = 'InnaPs-PowerShell-Module' } -ErrorAction Stop

        # Extract version from tag (remove leading 'v' if present)
        $latestVersionString = $release.tag_name -replace '^v', ''
        $latestVersion = [Version]$latestVersionString
    }
    catch {
        # If the releases endpoint fails, try tags as a fallback
        try {
            $tagsUrl = "https://api.github.com/repos/$repoOwner/$repoName/tags"
            $tags = Invoke-RestMethod -Uri $tagsUrl -Method Get -Headers @{ 'User-Agent' = 'InnaPs-PowerShell-Module' } -ErrorAction Stop

            if ($tags.Count -eq 0) {
                Write-Host "[$moduleName] No releases found. You are running version $currentVersion." -ForegroundColor Yellow
                return
            }

            $latestVersionString = $tags[0].name -replace '^v', ''
            $latestVersion = [Version]$latestVersionString
        }
        catch {
            Write-Warning "Unable to check for updates. Could not reach the GitHub API."
            Write-Warning "Error: $($_.Exception.Message)"
            return
        }
    }

    # Compare versions
    if ($latestVersion -gt $currentVersion) {
        Write-Host ""
        Write-Host "  ╔══════════════════════════════════════════════════════════════╗" -ForegroundColor Green
        Write-Host "  ║           InnaPs Module Update Available!                   ║" -ForegroundColor Green
        Write-Host "  ╠══════════════════════════════════════════════════════════════╣" -ForegroundColor Green
        Write-Host "  ║                                                              ║" -ForegroundColor Green
        Write-Host "  ║  Current version : $($currentVersion.ToString().PadRight(40))║" -ForegroundColor Green
        Write-Host "  ║  Latest version  : $($latestVersion.ToString().PadRight(40))║" -ForegroundColor Green
        Write-Host "  ║                                                              ║" -ForegroundColor Green
        Write-Host "  ║  To update, run:                                             ║" -ForegroundColor Green
        Write-Host "  ║                                                              ║" -ForegroundColor Yellow
        Write-Host "  ║    Update-Module -Name InnaPs                                ║" -ForegroundColor Cyan
        Write-Host "  ║                                                              ║" -ForegroundColor Green
        Write-Host "  ║  Or reinstall:                                               ║" -ForegroundColor Green
        Write-Host "  ║                                                              ║" -ForegroundColor Yellow
        Write-Host "  ║    Install-Module -Name InnaPs -Force                        ║" -ForegroundColor Cyan
        Write-Host "  ║                                                              ║" -ForegroundColor Green
        Write-Host "  ╚══════════════════════════════════════════════════════════════╝" -ForegroundColor Green
        Write-Host ""
    }
    else {
        Write-Host "[$moduleName] You are running the latest version ($currentVersion). No update needed." -ForegroundColor Green
    }
}
