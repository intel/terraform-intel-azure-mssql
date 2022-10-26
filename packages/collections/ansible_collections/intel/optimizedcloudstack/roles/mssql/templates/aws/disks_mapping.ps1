# Works on Nitro instances (e.g. m5, m6i, m5a), since EBS is exposed as NVMe
# Won't work on non-Nitro, will need a different scheme
function GetNvmeVolume {
    param($Number)
    $output = Invoke-Expression -Command "C:\PROGRAMDATA\AMAZON\Tools\ebsnvme-id.exe $Number"
    $output = $output.Split([Environment]::NewLine)
    $Volume = New-Object PSObject -Property @{
      Disk        = (($output[0].Split(":"))[1]).Trim()
      VolumeId    = (($output[1].Split(":"))[1]).Trim()
      Device      = (($output[2].Split(":"))[1]).Trim()
    }
    return $Volume
}

$Disks = @()
foreach($DiskNumber in (Get-Disk).Number)
{
  $Disk = GetNvmeVolume -Number $DiskNumber
  $Disks += $Disk
}

$Disks
