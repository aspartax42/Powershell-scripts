<#.NOTES
	File Name: Create-VM-on-HyperV.ps1
	Author: Aspartax
	Contact Info: 
		Website: https://aspartax.fr
#>


#Set VM Name, Switch Name, Installation Media Path
$VMName = Read-Host "Veuillez entrer le nom de la VM à créer"
$GSwitch = get-vmswitch
$GSwitch
$VMSwitch = Read-Host "Choisir le VirtualSwitch à affecter à notre VM"
$ISO = Read-Host "Veuillez entrer le chemin du fichier ISO d'install"
$VHD = Read-Host "Veuillez entrer le chemin du VHD de la VM"
$VHDSize = Read-Host "Veuillez entrer la taille du disk de la VM"
$RAM = Read-Host "Veuillez entrer la taille de la RAM à allouer à la VM"

#Create New virtual Machine
New-VM -Name $VMName -MemoryStartupBytes $RAM -Generation 2 -NewVHDPath $VHD"$VMName\$VMName.vhdx" -NewVHDSizeBytes $VHDSize -Path $VHD"$VMName" -SwitchName $VMSwitch

#Add dvd drive to my VM
Add-VMScsiController -VMName $VMName
Add-VMDvdDrive -VMName $VMName -ControllerNumber 1 -ControllerLocation 0 -Path $ISO

#Mount installation media
$DVDDrive = Get-VMDvdDrive -VMName $VMName

Set-VMFirmware -VMName $VMName -FirstBootDevice $DVDDrive
Start-VM -Name $VMName
vmconnect.exe