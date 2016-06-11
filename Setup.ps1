#sets the two new properties Age and Sex
[xml]$global:config = Get-Content .\App.config
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Import-Module -name "$scriptDir\Modules\SPIntegration.psm1" -Force #-ErrorAction SilentlyContinue -DisableNameChecking
New-UserProfileProperty -Propertyname "T-Age" -Propertydisplayname "Age" -Description "User Age"
New-UserProfileProperty -Propertyname "T-Sex" -Propertydisplayname "Sex" -Description "M for Male, F for Female"

function New-Users {
    $DomainController = $env:COMPUTERNAME
    $Users = Import-Csv -Delimiter ";" -Path ".Misc\UserList-sn.csv" -Encoding Default  
    foreach ($User in $Users)            
    {            
        $Displayname = $User.Firstname + " " + $User.Lastname            
        $UserFirstname = $User.Firstname            
        $UserLastname = $User.Lastname            
        $OU = $User.OU            
        $SAM = $User.SAM            
        $UPN = $User.Firstname + "." + $User.Lastname + "@" + $User.Maildomain            
        $Description = $User.Description            
        $Password = $User.Password            
        New-ADUser -Name "$Displayname" -DisplayName "$Displayname" -SamAccountName $SAM -UserPrincipalName $UPN -GivenName "$UserFirstname" -Surname "$UserLastname" -Description "$Description" -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) -Enabled $true -Path "$OU" -ChangePasswordAtLogon $false –PasswordNeverExpires $true -server $DomainController        
    }
}