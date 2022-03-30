<#.NOTES
	File Name: AD-choice.ps1
	Author: Aspartax
	Contact Info: 
		Website: https://aspartax.fr
#>


echo "Script de création d'OU"


$Name=Read-Host "Veuillez entre le nom de l'OU à créer"
$Path1=Read-Host "Veuillez entre le nom de l'OU ou créer l'unité d'organisation"
$Path2=Read-Host "Veuillez entre la première partie du nom de domaine (Ex: toto.lan => toto)"
$Path3=Read-Host "Veuillez entre la dernière partie du nom de domaine (Ex: toto.lan => lan)"


$Test=New-ADOrganizationalUnit -Name "$Name" -Path "OU=$Path1,DC=$Path2,DC=$Path3"

echo "L'OU $Name a été rajouté dans le domaine $Path2.$Path3"
pause