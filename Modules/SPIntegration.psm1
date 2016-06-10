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