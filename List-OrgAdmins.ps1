Clear-Host
# List Organziation Admins

$global:token = $env:intercomapi #Keep this private https://developers.intercom.com/building-apps/docs/authentication-types / You need write-conversation permission

Function List-OrgAdmins
{    
    param([Parameter(Mandatory=$false)] [String]$Token = $global:token)

    $headers = @{    
        "Authorization" = "Bearer $global:token"
        "Accept" = "application/json"
    }

    Invoke-WebRequest -Uri "https://api.intercom.io/admins" -Method Get -Headers $headers -UseBasicParsing | ConvertFrom-Json
}

$OrgAdmins = List-OrgAdmins
$OrgAdmins.admins | Select-Object -Property id,name,email | Sort-Object -Property name

