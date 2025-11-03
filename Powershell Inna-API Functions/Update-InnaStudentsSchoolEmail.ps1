function Update-InnaStudentsSchoolEmail {
    <#
    .SYNOPSIS
      Gets all accounts from a AD OU
      Gets All Students from Inna matching the selected student state
      Matches AD And Inna accounts by KT
      If Inna Account School email is not the same as the AD school email that user is added to the array to update.
      Finaly posts the update to Inna via API.
    .DESCRIPTION
        Long description of the function.

    .EXAMPLE
  
    .NOTES
        Author: Sidequest.is    
        Email: sidequest@sidequest.is
        Date: 30. Okt. 2025
        Version: 1.0
    #>

#region Tab Completion
    [CmdletBinding()]
    #EndRegion

#region Parameters
    Param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=0, HelpMessage="Distinguised name of AD OU")]
        [String] $ADOrganisationalUnit,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=1, HelpMessage="Nynemi")]
        [Switch] $Nynemi,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=2, HelpMessage="Kvoldskolanemi")]
        [Switch] $Kvoldskolanemi,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=3, HelpMessage="I_nami")]
        [Switch] $I_nami,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=4, HelpMessage="Utskriftarefni")]
        [Switch] $Utskriftarefni,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=5, HelpMessage="Student")]
        [Switch] $Student,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=6, HelpMessage="I_leyfi")]
        [Switch] $I_leyfi,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=7, HelpMessage="Haettur")]
        [Switch] $Haettur,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=8, HelpMessage="Innritadur")]
        [Switch] $Innritadur,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=9, HelpMessage="Utanskola")]
        [Switch] $Utanskola,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=10, HelpMessage="Utskrifadur")]
        [Switch] $Utskrifadur,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=11, HelpMessage="Fjarnamsnemi")]
        [Switch] $Fjarnamsnemi,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=12, HelpMessage="Kemur_ekki_a_naestu_onn")]
        [Switch] $Kemur_ekki_a_naestu_onn,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=13, HelpMessage="Skiptir_um_braut")]
        [Switch] $Skiptir_um_braut,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=14, HelpMessage="Endurinnritadur")]
        [Switch] $Endurinnritadur,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=15, HelpMessage="Fell_a_onn")]
        [Switch] $Fell_a_onn,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=16, HelpMessage="Frjals_maeting")]
        [Switch] $Frjals_maeting,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=17, HelpMessage="Haettur_a_thessari_onn")]
        [Switch] $Haettur_a_thessari_onn,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=18, HelpMessage="Bidlisti_1")]
        [Switch] $Bidlisti_1,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=19, HelpMessage="Bidlisti_2")]
        [Switch] $Bidlisti_2,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=20, HelpMessage="Oreglulegur")]
        [Switch] $Oreglulegur,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=21, HelpMessage="Utskrifast_a_naestu_onn")]
        [Switch] $Utskrifast_a_naestu_onn,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=22, HelpMessage="Utsk_efni_verdur_a_naestu_onn")]
        [Switch] $Utsk_efni_verdur_a_naestu_onn,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=23, HelpMessage="Skiptinemi")]
        [Switch] $Skiptinemi,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=24, HelpMessage="Dreifnam")]
        [Switch] $Dreifnam,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=25, HelpMessage="Bidlisti_3")]
        [Switch] $Bidlisti_3,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=26, HelpMessage="Grunnskolanemi")]
        [Switch] $Grunnskolanemi,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=27, HelpMessage="Standard")]
        [Switch] $Standard
    )
    #EndRegion
#Region Variables
    #inna Get Variables
    $state = @()
    $AllInnaUsers = @()
    #Inna Update Variables
    $Method = "Patch"
    $uriPrefix = $Global:BaseUri
    $uriSuffix = "/api/EducationCloud/users/email"
    $uri = $uriPrefix, $uriSuffix -join("")

    $header = @{
        Authorization = 'Bearer ' + $global:InnaContext.access_Token;
        "Accept" = "text/plain";
        "Content-Type" = "application/json";
    }    
    
    $body = @{
        userEmailUpdates = @(

        )
    } 
    
    #AD Variables
    $Properties = ("UserPrincipalName","extensionAttribute11")
    $ADUsers = @()

    #EndRegion

#Region States
    if($Nynemi) {
        $state += "-Nynemi"
    }
    if($Kvoldskolanemi) {
        $state += "-Kvoldskolanemi"
    }
    if($I_nami) {
        $state += "-I_nami"
    }
    if($Utskriftarefni) {
        $state += "-Utskriftarefni"
    }
    if($Student) {
        $state += "-Student"
    }
    if($I_leyfi) {
        $state += "-I_leyfi"
    }
    if($Haettur) {
        $state += "-Haettur"
    }
    if($Innritadur) {
        $state += "-Innritadur"
    }
    if($Utanskola) {
        $state += "-Utanskola"
    }
    if($Utskrifadur) {
        $state += "-Utskrifadur"
    }
    if($Fjarnamsnemi) {
        $state += "-Fjarnamsnemi"
    }
    if($Kemur_ekki_a_naestu_onn) {
        $state += "-Kemur_ekki_a_naestu_onn"
    }
    if($Skiptir_um_braut) {
        $state += "-Skiptir_um_braut"
    }
    if($Endurinnritadur) {
        $state += "-Endurinnritadur"
    }
    if($Fell_a_onn) {
        $state += "-Fell_a_onn"
    }
    if($Frjals_maeting) {
        $state += "-Frjals_maeting"
    }
    if($Haettur_a_thessari_onn) {
        $state += "-Haettur_a_thessari_onn"
    }
    if($Bidlisti_1) {
        $state += "-Bidlisti_1"
    }
    if($Bidlisti_2) {
        $state += "-Bidlisti_2"
    }
    if($Oreglulegur) {
        $state += "-Oreglulegur"
    }
    if($Utskrifast_a_naestu_onn) {
        $state += "-Utskrifast_a_naestu_onn"
    }
    if($Utsk_efni_verdur_a_naestu_onn) {
        $state += "-Utsk_efni_verdur_a_naestu_onn"
    }
    if($Skiptinemi) {
        $state += "-Skiptinemi"
    }
    if($Dreifnam) {
        $state += "-Dreifnam"
    }
    if($Bidlisti_3) {
        $state += "-Bidlisti_3"
    }
    if($Grunnskolanemi) {
        $state += "-Grunnskolanemi"
    }
    if ($Standard) {
        $state = @("-Nynemi",
        "-I_nami",
        "-Utskriftarefni",
        "-Innritadur",
        "-Fjarnamsnemi",
        "-Endurinnritadur",
        "-Bidlisti_1")
    }
          
    #EndRegion

#region Working Code
    #Get user information from AD
    $ADUsers = Get-ADUser -Filter * -searchbase $ADOrganisationalUnit -Properties $Properties |Select-Object "UserPrincipalName","extensionAttribute11"
    #Get users from Inna
    $AllInnaUsers = Invoke-Expression -Command "Get-InnaStudents $state"

    foreach ($User in $AllInnaUsers) {

        $currentAD = $ADUsers |? {$_.extensionAttribute11 -eq $user.personalid}
        if ($currentAD.UserPrincipalName -ne $user.email -AND $currentAD.UserPrincipalName -ne $null) {
            $member = [ordered]@{
                userId = $user.userId
                email = $currentAD.UserPrincipalName
            }            
            $body.userEmailUpdates += $member

            if($body.userEmailUpdates.count -gt 490){
                try { 
                    $json = $body |ConvertTo-Json -depth 2 -orde            
                    $response = Invoke-Restmethod -uri $uri -Method $Method -header $header -body $json -ErrorAction Stop
                    $response
                } catch {
                    Write-Host "Error: Status $($_.Exception.Response.StatusCode.value__)"
                }
                $body = @{
                    userEmailUpdates = @(
                    )
                } 
            }
        }     
    }

        try {
            $json = $body |ConvertTo-Json -depth 2   
            $response = Invoke-Restmethod -uri $uri -Method $Method -header $header -body $json -ErrorAction Stop
            $response
        } catch {
            Write-Host "Error: Status $($_.Exception.Response.StatusCode.value__)"
        }  

    #endregion

#region Powershell menu settings
    # Enables strict mode, which helps detect common coding errors
    Set-StrictMode -Version Latest
    # Sets the Tab key to the MenuComplete function, which provides tab-completion for parameter names
    Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
    #endregion
}
