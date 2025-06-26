# Inna
Powershell Functions for Inna API

Quick setup

powershell as admin Paste the following code into your powershell terminal:



if((Test-path $profile) -eq $false){
    # Create the profile if it does not exist
    New-Item -Path $profile -ItemType File -Force
    #Seting the execution policy to allow script execution
    Set-ExecutionPolicy -ExecutionPolicy remotesigned
}
#path to inna functions
$uris = (
"https://raw.githubusercontent.com/SideQuest-is/Inna/refs/heads/main/Powershell%20Inna-API%20Functions/Connect-InnaApi.ps1",
"https://raw.githubusercontent.com/SideQuest-is/Inna/refs/heads/main/Powershell%20Inna-API%20Functions/Get-InnaStudentByKennitala.ps1",
"https://raw.githubusercontent.com/SideQuest-is/Inna/refs/heads/main/Powershell%20Inna-API%20Functions/Get-InnaStudents.ps1",
"https://raw.githubusercontent.com/SideQuest-is/Inna/refs/heads/main/Powershell%20Inna-API%20Functions/Set-InnaStudentSchoolEmail.ps1"
)
#Importing functions into the profile
foreach ($uri in $uris){
Invoke-RestMethod -method GET -uri $uri | out-file $profile -Append
}
