<#.NOTES
	File Name: Get-Password-SSID.ps1
	Author: Aspartax
	Contact Info: 
		Website: https://aspartax.fr
#>

$SSID= Read-Host "Veuillez entrer le nom du SSID"
netsh wlan show profile name="$SSID" key=clear
pause