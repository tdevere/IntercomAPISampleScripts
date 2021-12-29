#Get Daily Closed Case List
Clear-Host

$global:token = $env:intercomapi #Keep this private https://developers.intercom.com/building-apps/docs/authentication-types / You need write-conversation permission
$global:UnixDate= (Get-Date (Get-Date).ToUniversalTime().AddDays(-1) -UFormat '%s')

Function Get-ClosedCasesByDate
{
    param(
    [Parameter(Mandatory=$false)] [String]$Token = $global:token,
    [Parameter(Mandatory)] [String]$AssigneeId,
    [Parameter(Mandatory=$false)] $UnixDate = $global:UnixDate)

    $headers = @{    
        "Authorization" = "Bearer $Token"
        "Accept" = "application/json"
    }

$body = 
@"
{
 "query":  {
    "operator": "AND",
    "value": [
      {
        "field": "admin_assignee_id",
        "operator": "=",
        "value": "$AssigneeId"
      },
      {
        "field": "updated_at",
        "operator": ">",
        "value": "$UnixDate"
      },
      {
        "field": "state",
        "operator": "=",
        "value": "closed"
      }
    ]
  }
}
"@

    Invoke-WebRequest -Uri "https://api.intercom.io/conversations/search" -Method Post -Body ($body) -Headers $headers -ContentType "application/json" -UseBasicParsing | ConvertFrom-Json   
   
}

$ClosedCaseList = Get-ClosedCasesByDate -AssigneeId 3315505 
$ClosedCaseList.conversations