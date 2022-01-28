$report = "path to where csv file will be created"
$i      = 0
# Table name
$tabName = “Disabled User Licenses”

# Create Table object
$table = New-Object system.Data.DataTable “$tabName”

# Define Columns
$col1 = New-Object system.Data.DataColumn "E3",([string])
$col2 = New-Object system.Data.DataColumn "F3",([string])
$col3 = New-Object system.Data.DataColumn "Visio",([string])
$col4 = New-Object system.Data.DataColumn "Project",([string])
$col5 = New-Object system.Data.DataColumn "PowerBi",([string])

# Add Columns
$table.columns.add($col1)
$table.columns.add($col2)
$table.columns.add($col3)
$table.columns.add($col4)
$table.columns.add($col5)

# Get Users
$e3_group      = Get-ADGroupMember -Identity "Microsoft 365 E3"
$f3_group      = Get-ADGroupMember -Identity "Microsoft 365 F3"
$visio_group   = Get-ADGroupMember -Identity "Microsoft Visio"
$project_group = Get-ADGroupMember -Identity "Microsoft Project"
$powerbi_group = Get-ADGroupMember -Identity "Microsoft PowerBi Pro"

# Create Arrays
[System.Collections.ArrayList]$e3_users      = @()
[System.Collections.ArrayList]$f3_users      = @()
[System.Collections.ArrayList]$visio_users   = @()
[System.Collections.ArrayList]$project_users = @()
[System.Collections.ArrayList]$powerbi_users = @()

foreach($user in $e3_group){
    
    $e3_user = Get-ADUser $user
    if($e3_user.Enabled -match $false){
        $e3_users.Add($e3_user)
    }
}
foreach($user in $f3_group){
    
    $f3_user = Get-ADUser $user
    if($f3_user.Enabled -match $false){
        $f3_users.Add($f3_user)
    }
}
foreach($user in $visio_group){
    
    $visio_user = Get-ADUser $user
    if($visio_user.Enabled -match $false){
        $visio_users.Add($visio_user)
    }
}
foreach($user in $project_group){
    
    $project_user = Get-ADUser $user
    if($project_user.Enabled -match $false){
        $project_users.Add($project_user)
    }
}
foreach($user in $powerbi_group){
    
    $powerbi_user = Get-ADUser $user
    if($powerbi_user.Enabled -match $false){
        $powerbi_users.Add($powerbi_user)
    }
}

while($true){

    if($e3_users[$i].Enabled -eq $false -or $f3_users[$i].Enabled -eq $false -or $visio_users[$i].Enabled -eq $false -or $project_users[$i].Enabled -eq $false -or $powerbi_users[$i].Enabled -eq $false){
        $row = $table.NewRow()
    }
    if($e3_users[$i].Enabled -eq $false){
        $row."E3" = $e3_users[$i].SamAccountName
        $table.Rows.Add($row)
    }
    if($f3_users[$i].Enabled -eq $false){
        $row."F3" = $f3_users[$i].SamAccountName
        $table.Rows.Add($row)
    }
    if($visio_users[$i].Enabled -eq $false){
        $row."Visio" = $visio_users[$i].SamAccountName
        $table.Rows.Add($row)
    }
    if($project_users[$i].Enabled -eq $false){
        $row."Project" = $project_users[$i].SamAccountName
        $table.Rows.Add($row)
    }
    if($powerbi_users[$i].Enabled -eq $false){
        $row."PowerBi" = $powerbi_users[$i].SamAccountName
        $table.Rows.Add($row)
    }
    if($e3_users[$i] -eq $null -and $f3_users[$i] -eq $null -and $visio_users[$i] -eq $null -and $project_users[$i] -eq $null -and $powerbi_users[$i] -eq $null){
        break
    }
    $i++
}

$table | Select-Object -Property E3, F3, Visio, Project, PowerBi | Export-Csv -Path $report -NoTypeInformation

Send-MailMessage -Subject "Disabled User License Report" -Body "These disabled users are still assigned licenses" -Attachments $report `
-From 'From_Mail' -To 'To_Mail' -SmtpServer smtp.office365.com -Port 587 -Credential (get-credential) -UseSsl
