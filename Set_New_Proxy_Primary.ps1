$users           = Get-ADGroupMember -Identity "group name"
$newPrimaryPoxy  = "domain"
$oldPrimaryProxy = "domain"
$primary         = "SMTP:"
$secondary       = "smtp:"

foreach($user in $users){
    
    $proxies = Get-ADUser $user.SamAccountName -Properties ProxyAddresses | Select-Object -ExpandProperty ProxyAddresses

    foreach($proxy in $proxies){
       
        if($proxy -cmatch $primary -and $proxy -match $oldPrimaryProxy){
                       
            $oldProxyEmail = $proxy.Replace("SMTP:", "")
            $x             = 1
        }
        if($proxy -cmatch $secondary -and $proxy -match $newPrimaryPoxy){
            
            $newProxyEmail = $proxy.Replace("smtp:", "")
            $y             = 1
        }
    }
    if($x -eq 1 -and $y -eq 1){
        Set-ADUser $user.SamAccountName -Remove @{ProxyAddresses="SMTP:$oldProxyEmail"}
        Set-ADUser $user.SamAccountName -Remove @{ProxyAddresses="smtp:$newProxyEmail"}
        Set-ADUser $user.SamAccountName -Add @{ProxyAddresses="smtp:$oldProxyEmail"}
        Set-ADUser $user.SamAccountName -Add @{ProxyAddresses="SMTP:$newProxyEmail"}
        $x = 0
        $y = 0
    }
        $x = 0
        $y = 0
}
