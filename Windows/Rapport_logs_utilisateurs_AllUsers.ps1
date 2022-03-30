<#.NOTES
	File Name: Export-logs-AllUsers.ps1
	Author: Aspartax
	Contact Info: 
		Website: https://aspartax.fr
#>

# Exporte l'historique des ouvertures et fermetures de sessions utilisateurs (locaux ou du domaine), dans un fichiers txt.

# Variable

$CheminExport = Read-Host "Entrez le chemin d'export de l'historique"

############################################

$UserProperty = @{n="Utilisateur";e={(New-Object System.Security.Principal.SecurityIdentifier $_.ReplacementStrings[1]).Translate([System.Security.Principal.NTAccount])}}
$TypeProperty = @{n="Action";e={if($_.EventID -eq 7001) {"Ouverture de session"} else {"Fermeture de session"}}}
$TimeProeprty = @{n="Date et heure";e={$_.TimeGenerated}}
Get-EventLog System -Source Microsoft-Windows-Winlogon | select $UserProperty,$TypeProperty,$TimeProeprty | export-csv $CheminExport