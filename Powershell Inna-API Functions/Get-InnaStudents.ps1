function Get-InnaStudents {
    <#
    .SYNOPSIS
        Gets students from Inna based on their student state/status.

    .DESCRIPTION
        This function retrieves student information from Inna API based on specified student states. 
        It allows filtering students by various states like new students, evening school students, 
        active students, graduates, etc. Multiple states can be specified simultaneously.

    .PARAMETER Nynemi
        Filter for new students

    .PARAMETER Kvoldskolanemi
        Filter for evening school students

    .PARAMETER I_nami
        Filter for currently enrolled students

    .PARAMETER Utskriftarefni
        Filter for students eligible for graduation

    .PARAMETER Student
        Filter for students with general student status

    .PARAMETER I_leyfi
        Filter for students on leave

    .PARAMETER Haettur
        Filter for dropped out students

    .PARAMETER Innritadur
        Filter for registered students

    .PARAMETER Utanskola
        Filter for external students

    .PARAMETER Utskrifadur
        Filter for graduated students

    .PARAMETER Fjarnamsnemi
        Filter for distance learning students

    .PARAMETER Kemur_ekki_a_naestu_onn
        Filter for students not returning next semester

    .PARAMETER Skiptir_um_braut
        Filter for students changing programs

    .PARAMETER Endurinnritadur
        Filter for re-enrolled students

    .PARAMETER Fell_a_onn
        Filter for students who failed the semester

    .PARAMETER Frjals_maeting
        Filter for students with flexible attendance

    .PARAMETER Haettur_a_thessari_onn
        Filter for students dropping out this semester

    .PARAMETER Bidlisti_1
        Filter for students on waiting list 1

    .PARAMETER Bidlisti_2
        Filter for students on waiting list 2

    .PARAMETER Oreglulegur
        Filter for irregular students

    .PARAMETER Utskrifast_a_naestu_onn
        Filter for students graduating next semester

    .PARAMETER Utsk_efni_verdur_a_naestu_onn
        Filter for students becoming eligible for graduation next semester

    .PARAMETER Skiptinemi
        Filter for exchange students

    .PARAMETER Dreifnam
        Filter for distributed learning students

    .PARAMETER Bidlisti_3
        Filter for students on waiting list 3

    .PARAMETER Grunnskolanemi
        Filter for elementary school students

    .PARAMETER Standard
        Uses a predefined set of common filters (Nynemi, I_nami, Utskriftarefni, Innritadur, 
        Fjarnamsnemi, Endurinnritadur, Bidlisti_1)

    .OUTPUTS
        Returns an array of student objects from Inna API containing student information

    .EXAMPLE
        Get-InnaStudents -I_nami
        Returns all currently enrolled students

    .EXAMPLE
        Get-InnaStudents -Standard
        Returns students matching the standard filter set

    .EXAMPLE
        Get-InnaStudents -Nynemi -Fjarnamsnemi
        Returns new students who are enrolled in distance learning

    .NOTES
        Requires valid Inna API authentication token in $global:InnaContext.access_Token
        Requires $Global:BaseUri to be set with the base URI for Inna API
    #>

#region Tab Completion
    [CmdletBinding()]
    #EndRegion

#region Parameters
    Param(
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=0, HelpMessage="Nynemi")]
        [Switch] $Nynemi,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=1, HelpMessage="Kvoldskolanemi")]
        [Switch] $Kvoldskolanemi,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=2, HelpMessage="I_nami")]
        [Switch] $I_nami,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=3, HelpMessage="Utskriftarefni")]
        [Switch] $Utskriftarefni,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=4, HelpMessage="Student")]
        [Switch] $Student,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=5, HelpMessage="I_leyfi")]
        [Switch] $I_leyfi,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=6, HelpMessage="Haettur")]
        [Switch] $Haettur,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=7, HelpMessage="Innritadur")]
        [Switch] $Innritadur,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=8, HelpMessage="Utanskola")]
        [Switch] $Utanskola,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=9, HelpMessage="Utskrifadur")]
        [Switch] $Utskrifadur,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=10, HelpMessage="Fjarnamsnemi")]
        [Switch] $Fjarnamsnemi,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=11, HelpMessage="Kemur_ekki_a_naestu_onn")]
        [Switch] $Kemur_ekki_a_naestu_onn,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=12, HelpMessage="Skiptir_um_braut")]
        [Switch] $Skiptir_um_braut,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=13, HelpMessage="Endurinnritadur")]
        [Switch] $Endurinnritadur,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=14, HelpMessage="Fell_a_onn")]
        [Switch] $Fell_a_onn,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=15, HelpMessage="Frjals_maeting")]
        [Switch] $Frjals_maeting,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=16, HelpMessage="Haettur_a_thessari_onn")]
        [Switch] $Haettur_a_thessari_onn,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=17, HelpMessage="Bidlisti_1")]
        [Switch] $Bidlisti_1,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=18, HelpMessage="Bidlisti_2")]
        [Switch] $Bidlisti_2,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=19, HelpMessage="Oreglulegur")]
        [Switch] $Oreglulegur,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=20, HelpMessage="Utskrifast_a_naestu_onn")]
        [Switch] $Utskrifast_a_naestu_onn,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=21, HelpMessage="Utsk_efni_verdur_a_naestu_onn")]
        [Switch] $Utsk_efni_verdur_a_naestu_onn,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=22, HelpMessage="Skiptinemi")]
        [Switch] $Skiptinemi,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=23, HelpMessage="Dreifnam")]
        [Switch] $Dreifnam,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=24, HelpMessage="Bidlisti_3")]
        [Switch] $Bidlisti_3,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=25, HelpMessage="Grunnskolanemi")]
        [Switch] $Grunnskolanemi,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, position=26, HelpMessage="Standard")]
        [Switch] $Standard

    )
    #EndRegion

#region Working Code

#Region States

    $state = @()
    if($Nynemi) {
        $state += "Nynemi"
    }
    if($Kvoldskolanemi) {
        $state += "Kvoldskolanemi"
    }
    if($I_nami) {
        $state += "I_nami"
    }
    if($Utskriftarefni) {
        $state += "Utskriftarefni"
    }
    if($Student) {
        $state += "Student"
    }
    if($I_leyfi) {
        $state += "I_leyfi"
    }
    if($Haettur) {
        $state += "Haettur"
    }
    if($Innritadur) {
        $state += "Innritadur"
    }
    if($Utanskola) {
        $state += "Utanskola"
    }
    if($Utskrifadur) {
        $state += "Utskrifadur"
    }
    if($Fjarnamsnemi) {
        $state += "Fjarnamsnemi"
    }
    if($Kemur_ekki_a_naestu_onn) {
        $state += "Kemur_ekki_a_naestu_onn"
    }
    if($Skiptir_um_braut) {
        $state += "Skiptir_um_braut"
    }
    if($Endurinnritadur) {
        $state += "Endurinnritadur"
    }
    if($Fell_a_onn) {
        $state += "Fell_a_onn"
    }
    if($Frjals_maeting) {
        $state += "Frjals_maeting"
    }
    if($Haettur_a_thessari_onn) {
        $state += "Haettur_a_thessari_onn"
    }
    if($Bidlisti_1) {
        $state += "Bidlisti_1"
    }
    if($Bidlisti_2) {
        $state += "Bidlisti_2"
    }
    if($Oreglulegur) {
        $state += "Oreglulegur"
    }
    if($Utskrifast_a_naestu_onn) {
        $state += "Utskrifast_a_naestu_onn"
    }
    if($Utsk_efni_verdur_a_naestu_onn) {
        $state += "Utsk_efni_verdur_a_naestu_onn"
    }
    if($Skiptinemi) {
        $state += "Skiptinemi"
    }
    if($Dreifnam) {
        $state += "Dreifnam"
    }
    if($Bidlisti_3) {
        $state += "Bidlisti_3"
    }
    if($Grunnskolanemi) {
        $state += "Grunnskolanemi"
    }
    if ($Standard) {
        $state = @("Nynemi",
        "I_nami",
        "Utskriftarefni",
        "Innritadur",
        "Fjarnamsnemi",
        "Endurinnritadur",
        "Bidlisti_1")
    }
          
     #EndRegion
    $Notendur = @()
     $uriPrefix = $Global:BaseUri 
     #Region Create the paraemeter and get the Students
     foreach ( $s in $state) {
        $uri = @()
        $uri = ($uriPrefix  + "/api/EducationCloud/users?studentState=$s")

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
                return $Notendur
               #EndRegion


    #endregion

    #region Powershell menu settings
    # Enables strict mode, which helps detect common coding errors
    Set-StrictMode -Version Latest
    # Sets the Tab key to the MenuComplete function, which provides tab-completion for parameter names
    Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
    #endregion
}