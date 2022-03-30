clear

Write-Host "           __          ________     ________          __          ________    _________        __                   " -ForegroundColor Green 
Write-Host "          /  \        |            |        |        /  \        |        |       |           /  \        \       / " -ForegroundColor Green
Write-Host "         /    \       |            |        |       /    \       |        |       |          /    \        \     /  " -ForegroundColor Green
Write-Host "        /______\      |________    |________|      /______\      |________|       |         /______\        \___/   " -ForegroundColor Green
Write-Host "       /        \              |   |              /        \     |    \           |        /        \       /   \   " -ForegroundColor Green
Write-Host "      /          \             |   |             /          \    |     \          |       /          \     /     \  " -ForegroundColor Green
Write-Host "     /            \    ________|   |            /            \   |      \         |      /            \   /       \ " -ForegroundColor Green




 

#--------------BOUCLE--------------------------------------------------------------------
$continuer = 'y' 
Do  
{ 
###############################################################################################
#                                       BOUCLE CHOIX                                          #
###############################################################################################

#Start-Sleep -Seconds 3 #Delay de 3s
Write-Host ""
Write-Host "==================================================================================" -ForegroundColor Red
Write-Host "[1] SCRIPT 'Configuration IP statique'" -ForegroundColor green
Write-Host "[2] SCRIPT 'Renommer serveur'" -ForegroundColor green
Write-Host "[3] SCRIPT 'Création AD" -ForegroundColor green
Write-Host "[4] SCRIPT 'Ajout Controleur de domaine" -ForegroundColor green
Write-Host "[5] SCRIPT 'Ajout poste au domaine'" -ForegroundColor green
Write-Host "[6] SCRIPT 'Création DHCP'" -ForegroundColor green
Write-Host "[7] SCRIPT 'Création d'OU'" -ForegroundColor green
Write-Host "[8] SCRIPT 'Création User'" -ForegroundColor green
Write-Host "[9] SCRIPT 'Création Groupe'" -ForegroundColor green
Write-Host "[10] SCRIPT 'Sortir du script'" -ForegroundColor green
Write-Host "===================================================================================" -ForegroundColor Red

Write-Host "Press Ctrl C to stop script"

$choix = Read-Host "Sélectionner le script qui vous intéresses"

Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Confirm:$False -Force 

###############################################################################################
#                                       CONFIGURATION IP STATIQUE                             #
###############################################################################################

if ($choix -eq '1')
{

    #Demande des nouveaux paramètres
    Write-Host "SCRIPT ADRESSAGE IP" 
    Write-Host "Configuration réseau actuel :" 
    Get-NetIPConfiguration
    $interface  = Read-Host 'Saisir numéro interface (InterfaceIndex) : '
    Write-Host "Votre interface est : $interface" 
    $ip = Read-Host 'Saisir la nouvelle IP : '
    Write-Host "Votre ip sera : $ip" 
    $defaultGateway = Read-Host "Saisir l'IP de la passerelle : "
    $defaultDNS = Read-Host "Saisir l'IP du DNS par défaut"
    Write-Host "L'IP de la passerelle sera $defaultGateway et l'IP du DNS $defaultDNS"

    #Début modification configuration réseau

    Remove-NetRoute -Confirm:$False  #enleve demande de confirmation
    Remove-NetIPAddress -Confirm:$False #enleve demande de confirmation
    Set-DnsClientServerAddress -InterfaceIndex $interface -ResetServerAddresses
    Write-Host "[INFO] IP + DNS supprimés."
    Write-Host "[INFO] Configuration de la nouvelle adresse IP." 
    New-NetIPAddress -InterfaceIndex $interface -IPAddress $ip -PrefixLength "24" -DefaultGateway $defaultGateway
    Set-DnsClientServerAddress -InterfaceIndex $interface -ServerAddresses $defaultDNS
    Write-Host "[INFO] Affichage de la configuration actuel :" 
    Get-NetIPConfiguration
    PAUSE
}
###############################################################################################
#                                       RENOMMER LE PC                                        #
###############################################################################################

if ($choix -eq '2')
{
    Write-Host "[INFO] SCRIPT Renomer le serveur":

    $OldServerName = hostname
    Write-Host "[INFO] Nom actuel du Serveur : $OldServerName"

    $NewServerrName = Read-Host "[ASK] Saisir le nouveau nom du Serveur"
    Rename-Computer -ComputerName $OldServerName -NewName $NewServerName -DomainCredential $OldServerName\info

    shutdown -r -t 15
    Write-host "Le serveur va redémarrer dans 15 secondes"
    PAUSE
}


###############################################################################################
#                                       Création AD                                           #
###############################################################################################

if ($choix -eq '3')
{
    Write-Host "[INFO] SCRIPT Création AD":

    $DomainName = Read-Host "Enter the domain name"
    $DomainNetBiosName = Read-Host "Enter the Netbios domain name"

    Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

    Install-ADDSForest -DomainName "$DomainName" -DomainNetBiosName "$DomainNetBiosName" -InstallDns

    Restart-Computer
    PAUSE
}



###############################################################################################
#                               Ajout controleur de domaine                                   #
###############################################################################################

if ($choix -eq '4')

{
    Write-Host "[INFO] SCRIPT Ajout controleur de domaine":

    $DomainName = Read-Host "Enter the domain name"
    $Credential = Read-Host "Enter administrator credentials informations (DOMAIN\administrateur)"

    Install-WindowsFeature AD-Domain-Services -IncludeManagementTools


    Install-ADDSDomainController -DomainName "$DomainName" -InstallDns:$true -Credential (Get-Credential "$Credential")
    PAUSE
}

###############################################################################################
#                                  Ajout poste au domaine                                     #
###############################################################################################

if ($choix -eq '5')

{
    Write-Host "[INFO] SCRIPT Ajout poste au domaine":

    $ComputerName = Read-Host "Enter the Computer Name"
    $Domain = Read-Host "Enter the netbios domain name"
    $AdminAccount = Read-Host "Enter the Admin domain account"
    $AdminPassword = Read-Host "Enter the Admin domain password"
    $OU = Read-Host "Enter the OU where the compute is stock (ex:OU=PC,DC=Test,DC=LAN)"

    netdom join $ComputerName /domain:$Domain /ud:$AdminAccount /pd:$AdminPassword /OU:$OU /reboot
    PAUSE
}



###############################################################################################
#                                       Création DHCP                                           #
###############################################################################################

if ($choix -eq '6')
{
    Write-Host "[INFO] SCRIPT Création DHCP":
    
    Install-WindowsFeature -Name DHCP -IncludeManagementTools
    Add-DhcpServerSecurityGroup
    Restart-Service dhcpserver
    $DHCPName = HOSTNAME.EXE
    $IP_DHCP = Read-Host "Veuillez saisir l'IP du serveur DHCP : "

    Add-DhcpServerInDC -DnsName $DHCPName -IPAddress $IP_DHCP

    Set-ItemProperty –Path registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\ServerManager\Roles\12 –Name ConfigurationState –Value 2

    PAUSE
}

###############################################################################################
#                                    Création d'OU                                            #
###############################################################################################

if ($choix -eq '7')
{
    Write-Host "[INFO] SCRIPT Création d'OU":

    $Name=Read-Host "Veuillez entre le nom de l'OU à créer"
    $Path1=Read-Host "Veuillez entre le nom de l'OU ou créer l'unité d'organisation"
    $Path2=Read-Host "Veuillez entre la première partie du nom de domaine (Ex: toto.lan => toto)"
    $Path3=Read-Host "Veuillez entre la dernière partie du nom de domaine (Ex: toto.lan => lan)"


    $Test=New-ADOrganizationalUnit -Name "$Name" -Path "OU=$Path1,DC=$Path2,DC=$Path3"

    echo "L'OU $Name a été rajouté dans le domaine $Path2.$Path3"
    PAUSE
}

###############################################################################################
#                                       Création User                                         #
###############################################################################################

if ($choix -eq '8')

{
    Write-Host "[INFO] SCRIPT Création User":

    $Domain = Read-Host "Merci de rentrer le nom du domaine pour l'adresse mail (ex: test.lan => test.fr)"
    $nom = Read-Host "Merci de Rentrer le Nom et le Prénom de l’Utilisateur à Créer"
    $login = Read-Host "Merci de Rentrer le Login de l’Utilisateur à Créer"
    $mdp = Read-Host "Merci de Rentrer le Mot de Passe de l’Utilisateur à Créer"
    
    New-ADUser -Name $nom -SamAccountName $login -UserPrincipalName $login@$Domain -AccountPassword (ConvertTo-SecureString -AsPlainText $mdp -Force) -PasswordNeverExpires $true -CannotChangePassword $true -Enabled $true


    PAUSE
}

###############################################################################################
#                                     Création Groupe                                         #
###############################################################################################

if ($choix -eq '9')

{
    Write-Host "[INFO] SCRIPT Création Groupe":

    $groupe = Read-Host "Merci de Rentrer le Nom du Groupe à Créer"
    New-ADGroup $groupe -GroupScope Global

    [int] $nombre = Read-Host "Merci de Rentrer le Nombre d’Utilisateurs à Insérer dans le Groupe"
    for ($i=1; $i -le $nombre; $i++)
    {
        $nom = Read-Host "Merci de Rentrer le Nom de l’Utilisateur à Insérer dans le Groupe $groupe"
        Add-ADGroupMember -identity $groupe -Members $nom
        Write-Host "L'utilisateur $nom a bien été inséré dans le groupe $Groupe"
    }

    PAUSE
}

###############################################################################################
#                                       END                                                   #
###############################################################################################

if ($choix -eq '10')
{
    exit
    Start-Sleep -Seconds 4
}

} #FIN DE BOUCLE
While ($continuer -ieq 'y')

Write-Host "Fin du script !" -ForegroundColor Red