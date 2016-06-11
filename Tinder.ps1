[Console]::OutputEncoding = [System.Text.Encoding]::UTF8 
 
Remove-Variable * -ErrorAction SilentlyContinue; Remove-Module *; $error.Clear(); Clear-Host 
 
#$DEBUG = $true 
#$PSScriptRoot = "."
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Import-Module -name "$scriptDir\Modules\SPIntegration.psm1" -Force -DisableNameChecking # -ErrorAction SilentlyContinue 
Import-Module -name "$scriptDir\Modules\DataAccessLayer.psm1" -Force -DisableNameChecking #-ErrorAction SilentlyContinue
Import-Module -name "$scriptDir\Modules\UI.psm1" -Force -DisableNameChecking #-ErrorAction SilentlyContinue
Import-Module -name "$scriptDir\Modules\txtimg.dll" -Force -DisableNameChecking # -ErrorAction SilentlyContinue

[xml]$global:config = Get-Content $scriptDir\App.config

$WelcomeImage = Get-ImageAsAscii -Url "http://5pz91qmfi1-flywheel.netdna-ssl.com/wp-content/uploads/2014/08/Screen-Shot-2014-08-13-at-5.52.38-AM-640x250.jpg"

Write-Host $WelcomeImage 

Write-Host ""
Write-Host ""

Write-Host "Welcome to Psinder!" 
Write-Host "Log in as: "
$LoginName = Read-Host
$domain = [Environment]::UserDomainName 
$fullusername = ($domain + "\" + $LoginName)
Write-Host "You are: $domain\$LoginName" 
 
 
function Main-Loop() {

    $prof = Get-RandomProfile

    $fullrecipientname = ($domain + "\" + $prof.Id)
    
    # This variable will be true if you previously liked or disliked the profile
    $PreviouslyLikedOrDisliked = Check-IfInstagatedPreviously -InstigatorAccountName $fullusername -RecipientAccountName $fullrecipientname

    # If previously liked or disliked, restart the loop
    if($PreviouslyLikedOrDisliked -eq $true -or [String]::IsNullOrEmpty($prof.Name))
    {
        Main-Loop
    }
    else
    {
        Clear-Host

        Write-Host $WelcomeImage 

        Write-Host ""
        Write-Host ""
        $url = $global:config.settings.sp.mysiteurl
        $ImgUrl = "$url/_layouts/15/userphoto.aspx?accountname=$fullrecipientname&size=L"

        $Picture = Get-ImageAsAscii -Url $ImgUrl
        $Name = $prof.Name
        $Age = $prof.Age
        $Sex = $prof.Sex

        Write-Host $Picture
        Write-Host "<-: Dislike, ->: Like, Q: quit" 
        Write-Host $Name -ErrorAction SilentlyContinue
        Write-Host "Age: $Age, Sex: $Sex" 
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
                Show-BalloonTip -Title "Match!" -Message "You've matched with $MatchName!"
                Write-Host "Press enter to continue!"
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
