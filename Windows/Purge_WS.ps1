<#.NOTES
	File Name: Purge-WS.ps1
	Author: Aspartax
	Contact Info: 
		Website: https://aspartax.fr
#>

###Purge du dossier Temp###
Set-Location "C:\Windows\Temp"
Remove-Item * -Recurse -Force

###Purge du dossier prefetch###
Set-Location "C:\Windows\prefetch"
Remove-Item * -Recurse -Force

###Purge du dossier Documents and Settings###
Set-Location "C:\Documents and Settings"
Remove-Item ".\*\Local Settings\temp\*" -Recurse -Force

###Purge du dossier Temp d'AppData###
Set-Location "C:\Users"
Remove-Item ".\*\Appdata\Local\Temp\*" -Recurse -Force
