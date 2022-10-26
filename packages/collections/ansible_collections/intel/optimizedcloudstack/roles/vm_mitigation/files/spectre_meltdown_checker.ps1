Set-ExecutionPolicy Unrestricted -Confirm:$false -Force
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module SpeculationControl -Confirm:$false -Force
Import-Module SpeculationControl
