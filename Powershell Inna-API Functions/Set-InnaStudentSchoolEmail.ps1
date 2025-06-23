function Set-InnaStudentSchoolEmail {
<#
.SYNOPSIS
    Sets the school email address for a student in the Inna system using their kennitala (Icelandic national ID).
.DESCRIPTION
    This function updates the school email address for a student record in the Inna API system. 
    It requires the student's kennitala (Icelandic national identification number) and the new school email address to be set. 
    The function communicates with the Inna API to perform the email update operation.
.NOTES
    - Requires valid Inna API credentials and connection
    - The kennitala must be in the correct 10-digit format
    - Email address should be a valid school domain email
    - Function may require appropriate permissions in the Inna system
.LINK
    https://docs.inna.is/api/students
.EXAMPLE
    Set-InnaStudentSchoolEmail -Kennitala "1234567890" -Email "student@school.is"    
    Sets the school email address for the student with kennitala "1234567890" to "student@school.is"
.EXAMPLE
    "1234567890" | Set-InnaStudentSchoolEmail -Email "newstudent@gymnasium.is"    
    Uses pipeline input to set the school email for the student with the specified kennitala
#>

#region Tab Completion
    [CmdletBinding()]
    #EndRegion

#region Parameters
    Param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=0, HelpMessage="Kennitala - Format '0000000000'")]
        [string] $Kennitala,
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=0, HelpMessage="Student School Email")]
        [string] $Email        
    )
    #EndRegion

#region Working Code
    
    $uriPrefix = $Global:BaseUri 
    #Region Create the paraemeter and update the Student account with the new email address    
    $body = @{
        updateUserRequest = @{
            email = $Email
        }
    } | ConvertTo-Json
    
        $uri = @()
        $uri = ($uriPrefix  + "/api/EducationCloud/users/$Kennitala")

        $params = @()
        $params = @{uri = $uri;
            Method = 'Put'; 
            Headers = @{Authorization = 'Bearer ' + $global:InnaContext.access_Token;} #end headers hash table
            ContentType = 'application/json';
            Body = $body
        }

        $return = Invoke-Restmethod @params 
    
        #EndRegion
        return $return
        #EndRegion


    #endregion

    #region Powershell menu settings
    # Enables strict mode, which helps detect common coding errors
    Set-StrictMode -Version Latest
    # Sets the Tab key to the MenuComplete function, which provides tab-completion for parameter names
    Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
    #endregion
}
