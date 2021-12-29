#AssignIntercomCaseToSpecificUser.ps1

Clear-Host
# Script to use to get a list of cases to reassign. If someone leaves for example, you may need to grab all existing open cases and move to a team or individual
# to continue support

$global:token = $env:intercomapi #Keep this private https://developers.intercom.com/building-apps/docs/authentication-types / You need write-conversation permission

#Cached Results of All Reassignment Function Calls
$ReassignmentResultsList = New-Object 'Collections.Generic.List[PSCustomObject]'

Function AssignIntercomCaseToSpecificUser
{
    #https://developers.intercom.com/intercom-api-reference/reference/assign-a-conversation

    param([Parameter(Mandatory)] [String]$AdminIdPerformingThisAction,
    [Parameter(Mandatory)] [String]$AssignToUserId,
    [Parameter(Mandatory=$false)] [String]$Token = $global:token,
    [Parameter(Mandatory)][String]$IntercomCaseId)

    $headers = @{    
        "Authorization" = "Bearer $global:token"
        "Accept" = "application/json"
        "Content-Type" = "application/json"
    }

$body = 
@"
{
    "type": "admin",
    "admin_id": "$AdminIdPerformingThisAction",
    "assignee_id": "$AssignToUserId",
    "message_type": "assignment",
    "body": "Andrew no longer works for App Center Support in CSS. Reassigning"
}
"@    

    $uri = "https://api.intercom.io/conversations/$IntercomCaseId/parts"
    $NewResultsObject = New-Object 'Collections.Generic.List[PSCustomObject]'

    #ensure we get a response even if an error's returned
    try 
    { 
        $results = Invoke-WebRequest -Uri $uri -Method Post -Body $body -Headers $headers -UseBasicParsing | ConvertFrom-Json
        $NewResultsObject += New-Object -TypeName psobject -Property @{IntercomCaseID=$IntercomCaseId; NewAssignee=$AssignToUserId; Results=$results}

    }
    catch [System.Exception] 
    { 
        $_.ErrorDetails.Message

        $NewResultsObject += New-Object -TypeName psobject -Property @{IntercomCaseID=$IntercomCaseId; NewAssignee=$AssignToUserId; Results=$_.ErrorDetails.Message}
        Write-Verbose "An exception was caught: $($_.Exception.Message)"
        $_.Exception.Response 
    } 
    
    $ReassignmentResultsList.Add($NewResultsObject)

}

AssignIntercomCaseToSpecificUser -AdminIdPerformingThisAction 3315505 -AssignToUserId 3315505 -IntercomCaseId 53577900103093
$ReassignmentResultsList