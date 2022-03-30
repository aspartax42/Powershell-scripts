#
# Script Windows PowerShell pour le déploiement d’AD DS
#
$DomainName=Read-Host "Enter your domain name"
$DomainNetbiosName=Read-Host "Enter your Netbios domain name"

Import-Module ADDSDeployment
Install-ADDSForest `
-CreateDnsDelegation:$false `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode "WinThreshold" `
-DomainName "$DomainName" `
-DomainNetbiosName "$DomainNetbiosName" `
-ForestMode "WinThreshold" `
-InstallDns:$true `
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion:$false `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true

