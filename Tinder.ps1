[Console]::OutputEncoding = [System.Text.Encoding]::UTF8 
 
Remove-Variable * -ErrorAction SilentlyContinue; Remove-Module *; $error.Clear(); Clear-Host 
 
#$DEBUG = $true 
 
Import-Module -name "$PSScriptRoot\Modules\SPIntegration.psm1" -Force #import the real stuff here 
Import-Module -name "$PSScriptRoot\Modules\DataAccessLayer.psm1" -Force
Import-Module -name "$PSScriptRoot\Modules\txtimg.dll" -Verbose -Force

Write-Host "Welcome to Psinder!" 
$domain = [Environment]::UserDomainName 
$uname = [Environment]::UserName 
$fullusername = ($domain + "\" + $uname)
Write-Host "You are: $domain\$uname" 
 
 
function Main-Loop() { 
 
    
 
    $prof = Get-RandomProfile

    $fullrecipientname = ($domain + "\" + $prof.Id)
    
    # This variable will be true if you previously liked or disliked the profile
    $PreviouslyLikedOrDisliked = Check-IfInstagatedPreviously -InstigatorAccountName $fullusername -RecipientAccountName $fullrecipientname

    # If previously liked or disliked, restart the loop
    if($PreviouslyLikedOrDisliked -eq $true)
    {
        Main-Loop
    }
    else
    {

        $ImgUrl = "http://dev/_layouts/15/userphoto.aspx?accountname=$fullrecipientname&size=L"
        Write-Output $ImgUrl
        $Picture = Get-ImageAsAscii -Url $ImgUrl
        Write-Host $Picture
        Write-Host "<-: Dislike, ->: Like, Q: quit" 
        Write-Host "$($prof.Name)`nAge: $($prof.Age), Sex: $($prof.Sex)" 
        Write-Host "Bio: $($prof.Bio)" 
        #Write-Host $ascii 
    
        # wait for input 

        $in = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") 

        if ($DEBUG) { 
            Write-Host $in 
        } 
 
        if ($in.Character -eq "q") { 
            # quit 
            Write-Host "Bye" 
        } 
        else { 

        # if Like
        if($in.VirtualKeyCode -eq 39)
        {
            $fullrecipientname = ($domain + "\" + $prof.Id)
            $MatchAcquired = Insert-Swipe -InstigatorAccountName $fullusername -RecipientAccountName  $fullrecipientname -SwipeAction 1

            if($MatchAcquired)
            {
                $MatchName = $prof.Name
                Write-Host "You've matched with $MatchName!" -ForegroundColor Green
                Read-Host
            }
        } # if Dislike
        elseif($in.VirtualKeyCode -eq 37)
        {
            $fullrecipientname = ($domain + "\" + $prof.Id)
            Insert-Swipe -InstigatorAccountName $fullusername -RecipientAccountName  $fullrecipientname -SwipeAction 0
        }
            # recur 
            Clear-Host 
            Main-Loop 
       } 
   }
} 
 
Main-Loop 
