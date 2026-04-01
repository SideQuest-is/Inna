function Get-InnaContext {
    <#
    .SYNOPSIS
        Gets the current Inna connection context information.

    .DESCRIPTION
        This function retrieves and displays information about the current Inna connection context,
        including the username, token type, issue time, and token expiration time in minutes.
        If no connection exists, it will display a message indicating that.

    .OUTPUTS
        PSCustomObject containing:
        - UserName: The connected user's name
        - TokenType: The type of authentication token
        - issued: When the token was issued
        - expiresInMinutes: How many minutes until the token expires

    .EXAMPLE
        Get-InnaContext
        Returns the current connection context information if connected to Inna.

    .NOTES
        Author: Sigurður R. Magnússon
        Email: srm@origo.is
        Date: 2025-May-07
        Version: 1.0
    #>

    #region Working Code
    if ($Global:InnaContext) {
       
        $Context = $Global:InnaContext
        if ($null -ne $Global:InnaContext.Refresh_Token) {
            $refresh = "Yes"
        } else {
            $refresh = "No"
        }
        $CustomObject = [PSCustomObject]@{
            UserName = $Global:InnaContext.UserName
            TokenType = $Global:InnaContext.token_type
            RefreshToken = $refresh
            Issued = $Global:InnaContext.'.issued'
            Expires = $Global:InnaContext.'.expires'
            ExpiresInMinutes = $timeInMinutes.Minutes
        }
        return $CustomObject
    }
    else {
        Write-Host "Not Connected to Inna"
        return
    }

    #endregion

    #region Powershell menu settings
    # Enables strict mode, which helps detect common coding errors
    Set-StrictMode -Version Latest
    # Sets the Tab key to the MenuComplete function, which provides tab-completion for parameter names
    Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
    #endregion
}
