Clear-Host
# Script to use to get a list of cases to reassign. If someone leaves for example, you may need to grab all existing open cases and move to a team or individual
# to continue support

$global:token = $env:intercomapi #Keep this private https://developers.intercom.com/building-apps/docs/authentication-types / You need write-conversation permission


Function List-AllConversations
{
    param([Parameter(Mandatory=$false)] [String]$Token = $global:token)

    $headers = @{    
        "Authorization" = "Bearer $global:token"
        "Accept" = "application/json"
    }

    Invoke-WebRequest -Uri "https://api.intercom.io/conversations?order=desc&sort=updated_at" -Method Get -Headers $headers -ContentType "application/json" -UseBasicParsing | ConvertFrom-Json  
}

$AllConversations = List-AllConversations
$AllConversations.total_count