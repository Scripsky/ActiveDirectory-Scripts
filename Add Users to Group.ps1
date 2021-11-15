Import-Module ActiveDirectory 
Import-Csv -Path "CSV File Path" | ForEach-Object {Add-ADGroupMember -Identity "GROUPNAME" -Members $_.'UserName'}