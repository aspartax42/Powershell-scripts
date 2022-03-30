<#.NOTES
	File Name: Login-history.ps1
	Author: Aspartax
	Contact Info: 
		Website: https://aspartax.fr
#>

$UserProperty = @{n="user";e={(New-Object System.Security.Principal.SecurityIdentifier $_.ReplacementStrings[1]).Translate([System.Security.Principal.NTAccount])}}
$TypeProperty = @{n="Action";e={if($_.EventID -eq 7001) {"Logon"} else {"Logoff"}}}
$TimeProeprty = @{n="Time";e={$_.TimeGenerated}}
Get-EventLog System -Source Microsoft-Windows-Winlogon | select $UserProperty,$TypeProperty,$TimeProeprty | export-csv -path c:\track.csv -NoTypeInformation