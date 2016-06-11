[String]$DatabaseServer = "DEV"

[string]$DatabaseName = "Tinder"

[String]$SwipesTableName = "Swipes"

[String]$MatchesTableName = "Matches"

[String]$DatabaseInstance = $null

function Run-SQLCmd($Query)
{
    Invoke-Sqlcmd -Query $Query -ServerInstance $DatabaseServer -Database $DatabaseName
}

# Return true if the swipe resulted in a match, return false otherwise
function Insert-Swipe([string]$InstigatorAccountName, [String]$RecipientAccountName, [int32]$SwipeAction)
{
    # Query for inserting 1 swipe into table Swipes
    $Query = "INSERT INTO $SwipesTableName VALUES ('$InstigatorAccountName','$RecipientAccountName',$SwipeAction)"

    # Insert Swipe
    Run-SQLCmd -Query $Query

    if($SwipeAction -eq 1)
    {
        # Check if swipe was a match, if match, enter data into match table
        [Bool]$IsMatch = Check-IfMatch -Instigator $InstigatorAccountName -Recipient $RecipientAccountName

        if($IsMatch)
        {
            # Insert match into match table
            Insert-Match -InstigatorAccountName $InstigatorAccountName -RecipientAccountName $RecipientAccountName

            # notify user
            return $true

        }
        else
        {
            return $false
        }
    }
}

function Check-IfMatch([String]$InstigatorAccountName,[String]$RecipientAccountName)
{
    $Query = "SELECT s1.instigator, s1.recipient FROM Swipes s1 WHERE s1.swipeAction = 1 AND s1.instigator = '$RecipientAccountName' AND s1.recipient = '$InstigatorAccountName'"

    $ResultSet = Run-SQLCmd -Query $Query

    if($ResultSet -ne $null)
    {
        return $true
    }
    else
    {
        return $false
    }
}

function Check-IfInstagatedPreviously([String]$InstigatorAccountName, [String]$RecipientAccountName)
{
    $Query = "SELECT * FROM Swipes WHERE recipient = '$RecipientAccountName' AND instigator = '$InstigatorAccountName'"

    $ResultSet = Run-SQLCmd -Query $Query

    if($ResultSet)
    {
        return $true
    }
    else
    {
        return $false
    }
}

function Insert-Match([string]$InstigatorAccountName, [String]$RecipientAccountName)
{
    $Query = "INSERT INTO $MatchesTableName VALUES ('$InstigatorAccountName','$RecipientAccountName')"

    Run-SQLCmd -Query $Query
}

<#
function Get-AllMatchesForPerson($PersonName)
{
    [string]$Query = "SELECT * FROM Matches WHERE personA = '$PersonName' OR personB = '$PersonName'"

    $ResultSet = Run-SQLCmd -Query $Query

    
}
#>
