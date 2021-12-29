#Useful DateTime Functions for Intercom APIs
#All temporal fields in the API are encoded as Unix timestamps and are by definition always treated as UTC
#https://developers.intercom.com/intercom-api-reference/reference/object-model

Clear-Host

Write-Host "Yesterday DateTime Unix Formatting"
Write-Host -ForegroundColor Blue (Get-Date (Get-Date).ToUniversalTime().AddDays(-1) -UFormat '+%Y-%m-%dT%H:%M:%S.000Z') 

Write-Host "Current DateTime Unix Formatting"
Write-Host -ForegroundColor Blue (Get-Date (Get-Date).ToUniversalTime() -UFormat '+%Y-%m-%dT%H:%M:%S.000Z') 

Write-Host "Tomorrow DateTime Unix Formatting"
Write-Host -ForegroundColor Blue (Get-Date (Get-Date).ToUniversalTime().AddDays(1) -UFormat '+%Y-%m-%dT%H:%M:%S.000Z')

#Intercom Specific
Write-Host "Current DateTime Unix Formatting"
Write-Host -ForegroundColor Blue (Get-Date (Get-Date).ToUniversalTime() -UFormat '%s') #In Seconds

#Convert Unix TimeStamp to Local Time 
Function Convert-FromUnixDate
{
    param([Parameter(Mandatory)] $UnixDate)    
    [timezone]::CurrentTimeZone.ToLocalTime(([datetime]'1/1/1970').AddSeconds($UnixDate))
}

Convert-FromUnixDate -UnixDate 1640735794
