$users = Get-ADGroupMember -Identity "GROUPNAME" | Select-Object -ExpandProperty SamAccountName

foreach ($user in $users){
    $aduser = Get-ADUser $user
    
    if ($aduser.Enabled -eq $false){
        $user | Out-File -FilePath "Path to CSV File"
    }
}
