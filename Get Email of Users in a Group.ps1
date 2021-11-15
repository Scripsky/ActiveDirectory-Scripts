$GroupMembers = Get-ADGroupMember groupname
foreach($Member in $GroupMembers){
    $User = Get-ADUser $Member -Properties mail | Select-Object -Property mail
    $EmailAddress = $User.Mail
    $EmailAddress >> 'path'
}