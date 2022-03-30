<#

.SYNOPSIS

Simple powershell script - ping analogue that attaches a timestamp of ping request to every ICMP packet.

.EXAMPLE



#>

$ip = Read-Host "Please enter IP address"

$path = Read-Host "Save output to (for example, c:\temp\out.txt)"

test-connection $ip -count 999999999 -delay 1 -Verbose 2>&1 | format-table @{n='TimeStamp';e={Get-Date}}, Address, ResponseTime | out-file $path 