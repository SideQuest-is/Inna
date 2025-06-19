function Get-InnaStudentByKennitala {
    <#
    .SYNOPSIS
        Gets students from Inna based on their kennitala (Icelandic ID number).

    .DESCRIPTION
        This function retrieves student information from Inna API using kennitala(s).
        It returns detailed user information for each provided kennitala from the Inna system.
        The function requires an active Inna authentication context with a valid access token.

    .PARAMETER Kenntolur
        An array of kennitala (Icelandic ID numbers) to look up.
        The kennitala should be in the format "DDMMYYXXXX".
        Multiple kennitolur can be provided either as an array or through pipeline input.

    .EXAMPLE
        Get-InnaStudentByKennitala -Kenntolur "1203902229"
        Returns the student information for the specified kennitala

    .EXAMPLE
        "1203902229","130495-2319" | Get-InnaStudentByKennitala
        Returns student information for multiple kennitolur passed through the pipeline

    .INPUTS
        System.Array
        You can pipe kennitala values to this function

    .OUTPUTS
        PSCustomObject
        Returns user objects containing detailed student information from Inna

    .NOTES
        Requires:
        - Valid Inna API authentication context 

    #>

#region Tab Completion
    [CmdletBinding()]
    #EndRegion

#region Parameters
    Param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=0, HelpMessage="Nynemi")]
        [array] $Kenntolur 
    )
    #EndRegion

#region Working Code


    $Notendur = @()
     $uriPrefix = $Global:BaseUri 
     #Region Create the paraemeter and get the Students
     foreach ( $KT in $Kenntolur ) {
        $uri = @()
        $uri = ($uriPrefix  + "/api/EducationCloud/users/$KT")

        $params = @()
        $params = @{uri = $uri;
                    Method = 'Get'; 
                    Headers = @{Authorization = 'Bearer ' + $global:InnaContext.access_Token;} #end headers hash table
        } 
        $Notendur += Invoke-Restmethod @params |ConvertTo-Json -Depth 3
        }
            #EndRegion
        $Notendur = $notendur |ConvertFrom-Json 
        #Region Return the results
                return $Notendur.users
               #EndRegion


    #endregion

    #region Powershell menu settings
    # Enables strict mode, which helps detect common coding errors
    Set-StrictMode -Version Latest
    # Sets the Tab key to the MenuComplete function, which provides tab-completion for parameter names
    Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
    #endregion
}