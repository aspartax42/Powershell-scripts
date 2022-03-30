<#.NOTES
	File Name: AD-choice.ps1
	Author: Aspartax
	Contact Info: 
		Website: https://aspartax.fr
#>


cls
Write-Host "           __          ________     ________          __          ________    _________        __                   " -ForegroundColor Green 
Write-Host "          /  \        |            |        |        /  \        |        |       |           /  \        \       / " -ForegroundColor Green
Write-Host "         /    \       |            |        |       /    \       |        |       |          /    \        \     /  " -ForegroundColor Green
Write-Host "        /______\      |________    |________|      /______\      |________|       |         /______\        \___/   " -ForegroundColor Green
Write-Host "       /        \              |   |              /        \     |    \           |        /        \       /   \   " -ForegroundColor Green
Write-Host "      /          \             |   |             /          \    |     \          |       /          \     /     \  " -ForegroundColor Green
Write-Host "     /            \    ________|   |            /            \   |      \         |      /            \   /       \ " -ForegroundColor Green


$continuer = 'y'

Do{
Write-Host "Script DHCP"
Write-Host "[1] Installation du rôle DHCP" -ForegroundColor Green
Write-Host "[2] Ajout d'un nouveau Scope DHCP" -ForegroundColor Green
Write-Host "[3] Obtention des Scopes DHCP" -ForegroundColor Green
Write-Host "[4] Quitter le script" -ForegroundColor Green

Write-Host "Press Ctrl C to stop script"
$Choix= Read-Host "Merci de faire votre choix : 1-4"


Write-Host "Vous avez choisi $Choix !"

Write-Host "Press Ctrl C to stop script"


if ($Choix -eq '1')
{
    cls
    Write-Host "Installation du rôle DHCP":
    Write-Host "L'installation du service DHCP entrenera un rédémarrage du serveur. Ne pas executer si le serveur est en production" -ForegroundColor Red
    Write-Host "[A] Installer le rôle et redémarrer le serveur" -ForegroundColor Cyan
    Write-Host "[B] Ne pas installer le rôle et retourner au menu" -ForegroundColor Cyan
    $ChoixInstall = Read-Host "Etes-vous sûr de vouloir installer le rôle et redémarrer le serveur ?"
    if ($ChoixInstall -eq 'A')
    {
        Install-WindowsFeature –name 'dhcp'
        Restart-Computer
    }
    if ($ChoixInstall -eq 'B')
    {
        Write-Host "Script DHCP":
        Write-Host "[1] Installation du rôle DHCP" -ForegroundColor Green
        Write-Host "[2] Ajout d'un nouveau Scope DHCP" -ForegroundColor Green
        Write-Host "[3] Obtention des Scopes DHCP" -ForegroundColor Green
        Write-Host "[4] Quitter le script" -ForegroundColor Green
        
        Write-Host "Press Ctrl C to stop script"

        $Choix= Read-Host "Merci de faire votre choix : 1-4"

        Write-Host "Vous avez choisi $Choix !"

    }
}


if ($Choix -eq '2')
{
    cls
    Write-Host "Ajout d'un nouveau Scope DHCP"
    $ScopeName = Read-Host "Veuillez entrer le nom du scope : "
    $ScopeStartR = Read-Host "Veuillez entrer l'IP de départ de la plage DHCP : "
    $ScopeEndR = Read-Host "Veuillez entrer l'IP de fin de la plage DHCP : "
    $ScopeMask = Read-Host "Veuillez entrer le masque de la plage DHCP : "
    $ScopeID = $ScopeStartR
    $ScopeDuration = Read-Host "Veuillez entrer la durée du bail DHCP"
    Add-DhcpServerv4Scope -EndRange $ScopeEndR -Name $ScopeName -StartRange $ScopeStartR -SubnetMask $ScopeMask -Type Dhcp

    Set-DhcpServerv4Scope -ScopeId $ScopeID -LeaseDuration $ScopeDuration

    Write-Host "La plage DHCP $ScopeName ayant pour IP de départ $ScopeStartR et IP de fin $ScopeEndR , comme masque $ScopeMask et comme durée de bail $ScopeDuration a bien été créée !"

    PAUSE
}

if ($Choix -eq '3')
{
    cls
    Write-Host "Obtention des Scopes DHCP"
    Get-DhcpServerv4Scope
    PAUSE
}

if ($Choix -eq '4')
{
    cls
    Write-Host "Quitter le script"
    exit
    Start-Sleep -Seconds 4
}
}While ($continuer -ieq 'y')

Write-Host "Fin du script !" -ForegroundColor Green