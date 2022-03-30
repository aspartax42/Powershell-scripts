<#.NOTES
	File Name: Remote-desktop-history.ps1
	Author: Aspartax
	Contact Info: 
		Website: https://aspartax.fr
#>

$serverlist = Start-Job { Get-WinEvent -FilterHashtable @{LogName='Security';ID=4648} |
                              where {$_.Properties[5].Value -eq $env:UserName} |
                              foreach {“$($_.Properties[8].Value)” } | Out-File "$home\Desktop\servers.txt"
$file = "$home\Desktop\servers.txt"
(gc $file | Group-Object | %{$_.group | select -First 1}) | Where-Object {$_ -notmatch 'localhost'} | Set-Content $file
}

Wait-Job $serverlist
Receive-Job $serverlist 

function Get-LoggedOn

{


	[CmdletBinding()]
	[Alias('loggedon')]
	[OutputType([PSCustomObject])]
	
	Param
	(
		# Computer name to check
		[Parameter(ValueFromPipeline = $true,
				   ValueFromPipelineByPropertyName = $true,
			       Position = 0)]
		[Alias('ComputerName')]
		[string]
		$Name = $env:COMPUTERNAME,
		
		# Username to check against logged in users.
		[parameter()]
		[string]
		$CheckFor
	)
	
	Process
	{
		function QueryToObject ($Computer)
		{
			$Output = @()
			$Users = query user /server:$Computer.nwie.net 2>&1
			if ($Users -like "*No User exists*")
			{
				$Output += [PSCustomObject]@{
					ComputerName = $Computer
					Username = $null
					SessionState = $null
					SessionType = "[None Found]"
				}
			}
			elseif ($Users -like "*Error*")
			{
				$Output += [PSCustomObject]@{
					ComputerName = $Computer
					Username = $null
					SessionState = $null
					SessionType = "[Error]"
				}
			}
			else
			{
				$Users = $Users | ForEach-Object {
					(($_.trim() -replace ">" -replace "(?m)^([A-Za-z0-9]{3,})\s+(\d{1,2}\s+\w+)", '$1  none  $2' -replace "\s{2,}", "," -replace "none", $null))
				} | ConvertFrom-Csv
				
				foreach ($User in $Users)
				{
					$Output += [PSCustomObject]@{
						ComputerName = $Computer
						Username = $User.USERNAME
						SessionState = $User.STATE.Replace("Disc", "Disconnected")
						SessionType = $($User.SESSIONNAME -Replace '#','' -Replace "[0-9]+","")
					}
					
				}
			}
			return $Output | Sort-Object -Property ComputerName
		}
		
		if ($CheckFor)
		{
			$Usernames = @()
			$Sessions = @()
			$Result = @()
			$Users = QueryToObject -Computer $Name
			
			foreach ($User in $Users) {
				$Usernames += $User.Username
				$Sessions += $User.SessionType
			}
			
			if ("[Error]" -in $Sessions)
			{
				$Result += [PSCustomObject]@{
					ComputerName = $Name
					IsLoggedOn = "[ERROR]"
				}
			}
			elseif ($CheckFor -in $Usernames -and "[*]" -notin $Sessions)
			{
				$Result += [PSCustomObject]@{
					ComputerName = $Name
					IsLoggedOn = $true
				}
			}
			else
			{
				$Result += [PSCustomObject]@{
					ComputerName = $Name
					IsLoggedOn = $false
				}
			}
			return $Result | select ComputerName,IsLoggedOn
		}
		elseif (!$CheckFor)
		{
			$Result = QueryToObject -Computer $Name
			return $Result
		}
	}

}

$name=GC $home\Desktop\servers.txt
Foreach($list in $name){
Get-LoggedOn -Name $list -CheckFor $env:UserName | Out-File $home\Desktop\results.txt -Append
}