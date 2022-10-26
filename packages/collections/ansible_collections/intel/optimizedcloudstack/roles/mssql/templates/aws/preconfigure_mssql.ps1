Param
(
  [Parameter(Mandatory=$true)]
  [string]$dbname,
  [Parameter(Mandatory=$true)]
  [string]$user,
  [Parameter(Mandatory=$true)]
  [string]$pass,
  [Parameter(Mandatory=$true)]
  [int]$no_data_disk
)
Start-Transcript

  $hostname = hostname
  $inst = $inst = $hostname

  # Run Amazon tools for NVMe mapping to get device paths
  $mappings = .\disks_mapping.ps1
  $mappings # print the elements
  # Format all xvd[f-z] drives on AWS here - raw disk formatting in "configure_mssql_no_invoke" won't be ran 
  $disks = $mappings | Where-Object Device -like '*xvd*' | Sort-Object -Property Device
  $count = 0
  $letters = 70..89 | ForEach-Object { [char]$_ } # F..Z letters
  $labels = $letters | ForEach-Object { "xvd$_".ToLower() } # label with names according to device_names
  foreach ($disk in $disks) {
      $driveLetter = $letters[$count].ToString()
      Get-Disk $disk.Disk | # retrieves MSFT disk based on physical disk number
      Initialize-Disk -PartitionStyle GPT -PassThru |
      New-Partition -UseMaximumSize -DriveLetter $driveLetter |
      Format-Volume -FileSystem NTFS  -AllocationUnitSize 65536 -NewFileSystemLabel $labels[$count] -Confirm:$false -Force
      $count++
  }

  # Enable Mixed Mode Authentication
  Set-ItemProperty -Path "HKLM:\Software\Microsoft\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQLSERVER" -Name "LoginMode" -Value 2
  
  Write-Output "ENABLING IFI"

  # Enable Instant File Initialization for AWS only
  Secedit /configure /cfg enable_ifi.inf /db C:\Windows\security\database\enable_ifi.sdb /log enable_ifi.log
  
  # Print Secedit results
  Get-Content "C:\\Users\\testadmin\\AppData\\Local\\Temp\\enable_ifi.log"

  # Restart MSSQL Server service
  $svc = Get-Service 'MSSQLSERVER'
  Stop-Service -Name 'MSSQLSERVER' -Force
  Start-Service -Name 'MSSQLSERVER'
  $svc.WaitForStatus('Running','00:00:30')

  # Stop and disable MSSQLServerOLAPService and SSASTELEMETRY
  Stop-Service -Name 'MSSQLServerOLAPService'
  Set-Service -Name 'MSSQLServerOLAPService' -StartupType Disabled
  Stop-Service -Name 'SSASTELEMETRY'
  Set-Service -Name 'SSASTELEMETRY' -StartupType Disabled

  # Create new login for admin_username with proper permissions
  $create_user = "
  USE [master]
  GO
  CREATE LOGIN $user WITH PASSWORD = '$pass', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
  GO
  CREATE USER $user FOR LOGIN $user
  GO
  ALTER SERVER ROLE sysadmin ADD MEMBER $user
  GO"

  Out-File -FilePath 'create_user.sql' -InputObject $create_user -Encoding ASCII  

  sqlcmd -E -S $inst -X -i create_user.sql

  #Create F:\SQLData because it doesn't exist on AWS
  cmd /C IF NOT EXIST "F:\SQLData \" MKDIR "F:\SQLData\"
  #Create G:\SQLLog because it doesn't exist on AWS
  cmd /C IF NOT EXIST "G:\SQLLog \" MKDIR "G:\SQLLog\"

Stop-Transcript
