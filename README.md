# Inna

## PowerShell Functions for Inna API

PowerShell module and standalone functions for interacting with the **Inna Education Cloud API**.

---

## Installation (Recommended — PowerShell Module)

The **InnaPs** module is published as a NuGet package on **GitHub Packages**. Follow these steps to install it.

### Prerequisites

- PowerShell **5.1** or later (Windows PowerShell) or **PowerShell 7+** (cross-platform)
- A **GitHub account** with a **Personal Access Token (PAT)** that has `read:packages` scope

### Step 1 — Create a GitHub Personal Access Token

1. Go to [https://github.com/settings/tokens](https://github.com/settings/tokens)
2. Click **Generate new token (classic)**
3. Give it a descriptive name (e.g. `InnaPs-Module`)
4. Select the **`read:packages`** scope
5. Click **Generate token** and copy the token value

### Step 2 — Register the GitHub Packages Repository

Open PowerShell **as Administrator** and run:

```powershell
# Save your GitHub credentials (you will be prompted for username and PAT)
$cred = Get-Credential -Message "Enter your GitHub username and Personal Access Token (PAT) as the password"

# Register the SideQuest GitHub Packages feed as a PowerShell repository
Register-PSRepository -Name "SideQuestGitHub" `
    -SourceLocation "https://nuget.pkg.github.com/SideQuest-is/index.json" `
    -PublishLocation "https://nuget.pkg.github.com/SideQuest-is/" `
    -InstallationPolicy Trusted `
    -Credential $cred
```

> **Note:** You only need to register the repository once per machine.

### Step 3 — Install the Module

```powershell
Install-Module -Name InnaPs -Repository SideQuestGitHub -Credential $cred
```

### Step 4 — Import and Use

```powershell
Import-Module InnaPs

# Check available commands
Get-Command -Module InnaPs

# Connect to the Inna API (Production)
Connect-Inna -Prod -ClientID "your-client-id" -ClientSecret (ConvertTo-SecureString "your-secret" -AsPlainText -Force)

# Get students
Get-InnaStudents -Standard

# Check for module updates
Test-InnaPsVersion
```

### Updating the Module

To check if a new version is available:

```powershell
Test-InnaPsVersion
```

To update to the latest version:

```powershell
Update-Module -Name InnaPs
```

Or force a clean reinstall:

```powershell
Install-Module -Name InnaPs -Repository SideQuestGitHub -Credential $cred -Force
```

---

## Quick Setup (Standalone Scripts — Legacy)

If you prefer to use the individual script files directly without installing the module:

Open PowerShell as admin and paste the following code into your terminal:

```powershell
if ((Test-Path $profile) -eq $false) {
    # Create the profile if it does not exist
    New-Item -Path $profile -ItemType File -Force
    # Set the execution policy to allow script execution
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
}

# Paths to Inna functions
$uris = @(
    "https://raw.githubusercontent.com/SideQuest-is/Inna/refs/heads/main/Powershell%20Inna-API%20Functions/Connect-InnaApi.ps1",
    "https://raw.githubusercontent.com/SideQuest-is/Inna/refs/heads/main/Powershell%20Inna-API%20Functions/Get-InnaStudentByKennitala.ps1",
    "https://raw.githubusercontent.com/SideQuest-is/Inna/refs/heads/main/Powershell%20Inna-API%20Functions/Get-InnaStudents.ps1",
    "https://raw.githubusercontent.com/SideQuest-is/Inna/refs/heads/main/Powershell%20Inna-API%20Functions/Set-InnaStudentSchoolEmail.ps1"
)

# Import functions into the profile
foreach ($uri in $uris) {
    Invoke-RestMethod -Method GET -Uri $uri | Out-File $profile -Append
}
```

---

## Available Functions

| Function | Description |
|---|---|
| `Connect-Inna` | Connects to the Inna API using OAuth2 client credentials and sets up the authentication context |
| `Get-InnaContext` | Displays current connection context information (user, token, expiration) |
| `Get-InnaStudentByKennitala` | Retrieves student information by kennitala (Icelandic ID number) |
| `Get-InnaStudents` | Retrieves students filtered by student state/status |
| `Set-InnaStudentSchoolEmail` | Updates the school email for a single student |
| `Update-InnaStudentsSchoolEmail` | Batch updates school emails by matching AD users with Inna students |
| `Test-InnaPsVersion` | Checks for new versions of the InnaPs module and displays update instructions |

---

## Publishing (For Maintainers)

The module is automatically published to GitHub Packages when a version tag is pushed:

```bash
git tag v1.0.0
git push origin v1.0.0
```

The GitHub Actions workflow will:
1. Extract the version from the tag
2. Update the module manifest
3. Validate the module
4. Publish to GitHub Packages NuGet feed

---

## License

See the [LICENSE](LICENSE) file for details.
