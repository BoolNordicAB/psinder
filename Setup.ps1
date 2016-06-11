#sets the two new properties Age and Sex
Import-Module -name ".\Modules\SPIntegration.psm1" -Force #-ErrorAction SilentlyContinue -DisableNameChecking
New-UserProfileProperty -Propertyname "T-Age" -Propertydisplayname "Age" -Description "User Age"
New-UserProfileProperty -Propertyname "T-Sex" -Propertydisplayname "Sex" -Description "M for Male, F for Female"

