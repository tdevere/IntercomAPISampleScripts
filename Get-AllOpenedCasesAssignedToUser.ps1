#Get-AllOpenedCasesAssignedToUser
Clear-Host
# Script to use to get a list of cases to reassign. If someone leaves for example, you may need to grab all existing open cases and move to a team or individual
# to continue support

$global:token = $env:intercomapi #Keep this private https://developers.intercom.com/building-apps/docs/authentication-types / You need write-conversation permission

Function Get-AllOpenedCasesAssignedToUser
{
    #https://developers.intercom.com/intercom-api-reference/reference/search-for-conversations
    param([Parameter(Mandatory)] [String]$AssigneeIds,
    [Parameter(Mandatory=$false)] [String]$Token = $global:token)

    $headers = @{    
        "Authorization" = "Bearer $global:token"
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
        "value": "$AssigneeIds"
        },
        {
        "field": "open",
        "operator": "=",
        "value": true
        }
    ]
    }
}
"@

    Invoke-WebRequest -Uri "https://api.intercom.io/conversations/search" -Method Post -Body ($body) -Headers $headers -ContentType "application/json" -UseBasicParsing | ConvertFrom-Json   

}

$UsersAllOpenCases = Get-AllOpenedCasesAssignedToUser -AssigneeIds 3315505
$UsersAllOpenCases