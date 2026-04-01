@{
    # Module manifest for InnaPs

    # Script module associated with this manifest
    RootModule        = 'InnaPs.psm1'

    # Version number of this module
    ModuleVersion     = '1.0.0'

    # ID used to uniquely identify this module
    GUID              = '3262c7c5-3224-4f89-b409-08f61ccaa7cd'

    # Author of this module
    Author            = 'Sidequest.is'

    # Company or vendor of this module
    CompanyName       = 'Sidequest.is'

    # Copyright statement for this module
    Copyright         = '(c) Sidequest.is. All rights reserved.'

    # Description of the functionality provided by this module
    Description       = 'PowerShell module for interacting with the Inna Education Cloud API. Provides functions to connect, query students, and manage student email addresses.'

    # Minimum version of the PowerShell engine required by this module
    PowerShellVersion = '5.1'

    # Functions to export from this module
    FunctionsToExport = @(
        'Connect-Inna',
        'Get-InnaContext',
        'Get-InnaStudentByKennitala',
        'Get-InnaStudents',
        'Set-InnaStudentSchoolEmail',
        'Update-InnaStudentsSchoolEmail',
        'Test-InnaPsVersion'
    )

    # Cmdlets to export from this module
    CmdletsToExport   = @()

    # Variables to export from this module
    VariablesToExport  = @()

    # Aliases to export from this module
    AliasesToExport    = @()

    # Private data to pass to the module specified in RootModule
    PrivateData = @{
        PSData = @{
            # Tags applied to this module for discoverability
            Tags         = @('Inna', 'Education', 'API', 'Student', 'Iceland')

            # A URL to the license for this module
            LicenseUri   = 'https://github.com/SideQuest-is/Inna/blob/main/LICENSE'

            # A URL to the main website for this project
            ProjectUri   = 'https://github.com/SideQuest-is/Inna'

            # Release notes for this module
            ReleaseNotes = 'Initial release of InnaPs module with functions for Inna Education Cloud API.'
        }
    }
}
