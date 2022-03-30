<#.NOTES
	File Name: Control-sessions.ps1
	Author: Aspartax
	Contact Info: 
		Website: https://aspartax.fr
#>

$Server = Read-Host "Entrez le nom du serveur"

query session /server:$Server

# Variables	
$IDSESSION = Read-Host "Entrez le numero de la session"

mstsc /shadow:$IDSESSION /control /v:$Server