$ListUsers = Get-ADUser -SearchBase "OU=Disabled,DC=ahml1,DC=ru" -Filter * -Properties DisplayName, AccountExpirationDate,Enabled, MemberOf, Description, msExchWhenMailboxCreated, ObjectGUID, LastLogonDate, Enabled, homeMDB | Where-Object {$_.homeMDB -ne $null}

$ListUsersndMailbox = Foreach ($user in $ListUsers)

{ 
	$mbx = Get-MailboxStatistics -Identity $user.SamAccountName
    $mbx2 = Get-Mailbox -Identity $User.SamAccountName
    
    $obj = New-Object -TypeName PSObject
    $obj | Add-Member -Type NoteProperty -Name User -Value $User.samaccountname
    $obj | Add-Member -Type NoteProperty -Name Description -Value $User.Description
    $obj | Add-Member -Type NoteProperty -Name msExchWhenMailboxCreated -Value $user.msExchWhenMailboxCreated
    $obj | Add-Member -Type NoteProperty -Name ObjectGUID -Value $user.ObjectGUID
    $obj | Add-Member -Type NoteProperty -Name DisplayName -Value $user.DisplayName
    $obj | Add-Member -Type NoteProperty -Name MailboxLastLogonTime -Value $mbx.LastLogonTime
    $obj | Add-Member -Type NoteProperty -Name AccountExpirationDate -Value $user.AccountExpirationDate
    $obj | Add-Member -Type NoteProperty -Name IsUserEnabled -Value $user.Enabled
    $obj | Add-Member -Type NoteProperty -Name AccountLastLogonDate -Value $user.LastLogonDate
    $obj | Add-Member -Type NoteProperty -Name ForwardingAddress -Value $mbx2.ForwardingAddress
   

    $obj
    }
$ListUsersndMailbox |  Export-Csv -Path "C:\Users\kguznin\Desktop\Disabled.csv" -Delimiter ";" -Encoding UTF8 -NoTypeInformation