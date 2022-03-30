echo "Creation Script for Active Directory"

$DomainName = Read-Host "Enter the domain name"
$DomainNetBiosName = Read-Host "Enter the Netbios domain name"

Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

Install-ADDSForest -DomainName "$DomainName" -DomainNetBiosName "$DomainNetBiosName" -InstallDns:$true

Restart-Computer
