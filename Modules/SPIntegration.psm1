function Get-Profiles { 
    asnp *share* 
    $MySiteHostUrl = "http://dev"
 
    $MySiteHostSite = Get-SPSite $MySiteHostUrl 
 
    $Context = Get-SPServiceContext $MySiteHostSite 
 
    # Retrieve the Profile Manager 
    $ProfileManager = New-Object Microsoft.Office.Server.UserProfiles.UserProfileManager($Context) 
 
 
    $global:profiles =  $ProfileManager.GetEnumerator() | ForEach-Object {  
        new-object PSObject @{  
            Name = $_.DisplayName  
            Sex = $_["T-Sex"] 
            Age = $_["T-Age"] 
            Bio = $_["AboutMe"] 
            Id = $_["UserName"]
        }  
    }
    
     
} 
 
function Get-RandomProfile() {
    
    if(!$global:profiles)
    {
        Get-Profiles
    }
    else
    {
        $global:profiles | Get-Random 
    }
} 

function New-UserProfileProperty($Propertyname, $Propertydisplayname, $Description) { 
    asnp *share*
    $propertylength = 1024
    $IsUserEditable = $true 
    $datatype = "string"
    $ismultivalued = $false
    #todo: settings
    $mySiteUrl = "https://dev/my"
    $site = Get-SPSite $mySiteUrl;
    $context = Get-SPServiceContext($site);    
    $upcm = New-Object Microsoft.Office.Server.UserProfiles.UserProfileConfigManager($context);
    $ppm = $upcm.ProfilePropertyManager;
    $cpm = $ppm.GetCoreProperties();
    $ptpm = $ppm.GetProfileTypeProperties([Microsoft.Office.Server.UserProfiles.ProfileType]::User);    
    $psm = [Microsoft.Office.Server.UserProfiles.ProfileSubTypeManager]::Get($context);
    $ProfileSubType = [Microsoft.Office.Server.UserProfiles.ProfileSubtypeManager]::GetDefaultProfileName([Microsoft.Office.Server.UserProfiles.ProfileType]::User)
    $ps = $psm.GetProfileSubtype($ProfileSubType);
    $pspm = $ps.Properties;
    $coreProp = $cpm.GetPropertyByName($propertyname);
    if ($coreProp -eq $null)
    {
        $coreProp = $cpm.Create($false);
        $coreProp.Name = $propertyname;
        $coreProp.DisplayName = $propertydisplayname;
        $coreProp.Description = $description;
        $coreProp.Type = $datatype;
        $coreProp.IsMultivalued = $ismultivalued;
        $coreProp.Length = $propertylength;
        $coreProp.Commit();
        $profileTypeProp = $ptpm.Create($coreProp);
        $profileTypeProp.IsVisibleOnEditor = $true;
        $profileTypeProp.IsVisibleOnViewer = $true;
        $profileTypeProp.Commit();   
        $profileSubTypeProp = $pspm.Create($profileTypeProp);
        $profileSubTypeProp.DefaultPrivacy = [Microsoft.Office.Server.UserProfiles.Privacy]::Public;
        $profileSubTypeProp.IsUserEditable = $IsUserEditable;
        $profileSubTypeProp.Commit();
        #todo $Error Detection
        Write-Host "User Profile Property $PropertyName has been created" -ForegroundColor Green
    }else{
        write-host "User Profile Property $PropertyName already exists." -ForegroundColor DarkGray
    }
}