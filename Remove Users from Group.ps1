Import-Module ActiveDirectory 
Import-Csv -Path "CSV File Path" | ForEach-Object {Remove-ADGroupMember -Identity "GROUPNAME" -Members $_.'UserName'}