function Connect-Inna {
    <#
     .SYNOPSIS
         Connects to the Inna API and retrieves an authentication token.    
     .DESCRIPTION
         This function connects to the Inna API using provided credentials and returns
         an authentication token. It prompts for username and password using secure credential input.    
     .PARAMETER uri
         The API endpoint URL for authentication.
         Excample    
     .OUTPUTS
         Returns the API response containing the authentication token and related information.    
     .EXAMPLE
         Connect-Inna -School Origo
         Connects to the default API endpoint using prompted credentials    
     .EXAMPLE
         Connect-Inna -uri 
         Connects to a custom API endpoint using prompted credentials    
     .NOTES

     #>
     
 
 #region Tab Completion
     [CmdletBinding()]
     #EndRegion
 
 #region Parameters
     Param(
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=0, HelpMessage="Prod Connection")]
        [switch] $Prod, 
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=1, HelpMessage="Test Connection")]
        [switch] $Test,
        
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=2, HelpMessage="Client ID")]
        [string] $ClientID,
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=3, HelpMessage="Client Secret")]
        [SecureString] $ClientSecret
          

     )
     #EndRegion


 #Region Variables
        if ($Prod) {
            $authUri = "https://heimdallur.inna.is/api/auth/token"
            $baseuri = "https://api-v3.inna.is"  
        }
        if ($Test) {
            $authUri = "https://heimdallur-test.inna.is/api/auth/token"
            $baseuri = "https://api-v3-test.inna.is"         
        }

        $Expring = (Get-Date).AddMinutes(15) 

        #$baseuri = "https://$SchoolName-api.starfsmenn.is"
         #Global variable to store the base URI for API calls
         $Global:BaseUri = $baseuri
         # This is the authentication URL for the Inna API
         #AuthUri = $Global:BaseUri + "/auth/token" 
        #EndRegion
 #region Working Code

 
     $headers = @{
        'accept' = 'application/json'
        'Content-Type' = 'application/x-www-form-urlencoded'
    }
    
    $client_id = $ClientID
    # Convert the encrypted client secret to plain text
    $client_secret = $ClientSecret | ConvertFrom-SecureString -AsPlainText
    
    $body = @{
        client_id = $client_id
        client_secret = $client_secret
        grant_type = 'client_credentials'
    }

    $uri = $authUri
    
    $response = Invoke-RestMethod -Uri $uri -Method 'POST' -Headers $headers -Body $body
    
     # Create a global variable to store the access token
     $Global:InnaContext = @{
        Client_ID = $client_id
        Access_token = $response.Access_token
        Expires = $Expring
        }

 
     #return $response
 
     #endregion
 
     #region Powershell menu settings
     # Enables strict mode, which helps detect common coding errors
     Set-StrictMode -Version Latest
     # Sets the Tab key to the MenuComplete function, which provides tab-completion for parameter names
     Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
     #endregion
 }
