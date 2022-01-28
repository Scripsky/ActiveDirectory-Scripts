$member = Get-ADGroupMember "GROUPNAME"
foreach($member in $members){
    $users = Get-ADUser $member.SamAccountName -Properties Mail | Select-Object -ExpandProperty Mail | Out-File -FilePath "PATHTOFILE" -Append
}
