  Param
  (
    [Parameter(Mandatory=$true)]
    [string]$dbname,
    [Parameter(Mandatory=$true)]
    [string]$user,
    [Parameter(Mandatory=$true)]
    [string]$pass,
    [Parameter(Mandatory=$true)]
    [int]$no_data_disk,
    [Parameter(Mandatory=$true)]
    [AllowEmptyString()]
    [string]$startup_flags
  )

  Write-Output $dbname
  Write-Output $user
  Write-Output $pass
  Write-Output $no_data_disk
  Write-Output $startup_flags

  # cast string startup_flags to array

  # set instance and database name variables
  $hostname = hostname
  $inst = $inst = $hostname

  $disks = Get-Disk | Where-Object partitionstyle -eq 'raw' | sort number
  $letters = 72..89 | ForEach-Object { [char]$_ }
  $count = 0
  $labels = "data1","data2"
  foreach ($disk in $disks) {
      $driveLetter = $letters[$count].ToString()
      $disk |
      Initialize-Disk -PartitionStyle GPT -PassThru |
      New-Partition -UseMaximumSize -DriveLetter $driveLetter |
      Format-Volume -FileSystem NTFS  -AllocationUnitSize 65536 -NewFileSystemLabel $labels[$count] -Confirm:$false -Force
      $count++
  }

  #Set Backup Folder
  New-Item -ItemType Directory -Force -Path F:\SQLBackups

  #Set TempDB based on if ephemeral disk exists and if it is large enough
  $temp_volume = Get-Volume "D"
  if ($temp_volume) {
    [int]$temp_volume_size = $temp_volume.Size / 1GB
    if ($temp_volume_size -lt 100) {
      $temp_drive = "G:\SQLTemp"
    } else {
      $temp_drive = "D:\SQLTemp"
    }
  }else {
    $temp_drive = "G:\SQLTemp"
  }

  cmd /C IF NOT EXIST "$temp_drive \" MKDIR "$temp_drive\"
  icacls.exe "$temp_drive\" /grant "*S-1-5-80-3880718306-3832830129-1677859214-2598158968-1052248003:(OI)(CI)(F)"

  try {
	if ($startup_flags) {
		Write-Output "Provision SQL Startup Flags"
		$flags=$startup_flags.split(",")
        $SQLInstancePath="HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL15.MSSQLSERVER"
        # Remove default 3rd SQL Server startup parameter
        Remove-ItemProperty -Path "$SQLInstancePath\MSSQLServer\Parameters" -Name ("SQLArg3")
        (Get-ItemProperty "$SQLInstancePath\MSSQLServer\Parameters" | Select SQLArg*  | Format-List | Out-String ).trim() -replace "SQLArg","`tSQLArg"

        # Remove default 4th SQL Server startup parameter
        Remove-ItemProperty -Path "$SQLInstancePath\MSSQLServer\Parameters" -Name ("SQLArg4")
        (Get-ItemProperty "$SQLInstancePath\MSSQLServer\Parameters" | Select SQLArg*  | Format-List | Out-String ).trim() -replace "SQLArg","`tSQLArg"

		$argument_position=3
		foreach ($flag in $flags) {
			New-ItemProperty -Path "$SQLInstancePath\MSSQLServer\Parameters" -Name ("SQLArg$argument_position") -Value "-$flag" -PropertyType String -Force | Out-Null
			(Get-ItemProperty "$SQLInstancePath\MSSQLServer\Parameters" | Select SQLArg*  | Format-List | Out-String ).trim() -replace "SQLArg","`tSQLArg"
			$argument_position=$argument_position+1
		}
	}

	$data_disks_letters = @('F') + $letters
	Write-Output "Provision $no_data_disk no data disk"
	$db_partitions = ""
	for ($i=0; $i -le ($no_data_disk - 1); $i++) {
		cmd /C IF NOT EXIST "$($data_disks_letters[$i]):\SQLData \" MKDIR "$($data_disks_letters[$i]):\SQLData\"
		if ($i -eq 0) {
			$db_partitions += "`t( NAME = N'$dbname', FILENAME = N'$($data_disks_letters[$i]):\SQLData\$dbname.mdf' , SIZE = 1024MB , FILEGROWTH = 256MB )"
		}else {
			$db_partitions += "`t( NAME = N'$dbname`_$($i+1)', FILENAME = N'$($data_disks_letters[$i]):\SQLData\$dbname.mdf' , SIZE = 1024MB , FILEGROWTH = 256MB )"
		}
		if ($i -ne ($no_data_disk - 1)) {
			$db_partitions += ",`r`n"
		}
	}

	$cmd_db = "CREATE DATABASE [$dbname]
	CONTAINMENT = NONE
	ON  PRIMARY
	$db_partitions
	LOG ON
	( NAME = N'$dbname`_log', FILENAME = N'G:\SQLLog\$dbname`_log.ldf' , SIZE = 50000000KB , FILEGROWTH = 0 )
	GO
	ALTER DATABASE [$dbname] SET AUTO_SHRINK OFF
	GO
	ALTER DATABASE [$dbname] SET RECOVERY SIMPLE
	GO
	ALTER DATABASE [$dbname] SET TORN_PAGE_DETECTION OFF
	GO
	ALTER DATABASE [$dbname] SET PAGE_VERIFY NONE
	GO
	ALTER DATABASE [$dbname] set TARGET_RECOVERY_TIME = 0 seconds
	GO"

	Out-File -FilePath 'configure_disk.sql' -InputObject $cmd_db -Encoding ASCII
	sqlcmd -U $user -P $pass -S $inst -X -i 'configure_disk.sql'

	# Change TempDB Files number and placement
	#Invoke-Sqlcmd -InputFile $TempDB_file -ServerInstance $hostname -Database $dbname
	Write-Output "Prepare tempdb"
	$cmd_tempdb ="ALTER DATABASE tempdb MODIFY FILE ( NAME = tempdev , FILENAME ='$temp_drive\tempdb.mdf', SIZE = 256);
	GO
	ALTER DATABASE tempdb MODIFY FILE (NAME = temp2 , FILENAME = '$temp_drive\tempdb_mssql_2.ndf', SIZE = 256);
	GO
	ALTER DATABASE tempdb ADD FILE (NAME = temp3 , FILENAME = '$temp_drive\tempdb_mssql_3.ndf', SIZE = 256);
	ALTER DATABASE tempdb ADD FILE (NAME = temp4 , FILENAME = '$temp_drive\tempdb_mssql_4.ndf', SIZE = 256);
	ALTER DATABASE tempdb ADD FILE (NAME = temp5 , FILENAME = '$temp_drive\tempdb_mssql_5.ndf', SIZE = 256);
	ALTER DATABASE tempdb ADD FILE (NAME = temp6 , FILENAME = '$temp_drive\tempdb_mssql_6.ndf', SIZE = 256);
	ALTER DATABASE tempdb ADD FILE (NAME = temp7 , FILENAME = '$temp_drive\tempdb_mssql_7.ndf', SIZE = 256);
	ALTER DATABASE tempdb ADD FILE (NAME = temp8 , FILENAME = '$temp_drive\tempdb_mssql_8.ndf', SIZE = 256);
	-- MODIFYs are needed since temp3 and temp4 are created automatically and MODIFY doesn't hurt on other
	ALTER DATABASE tempdb MODIFY FILE (NAME = temp3 , FILENAME = '$temp_drive\tempdb_mssql_3.ndf', SIZE = 256);
	ALTER DATABASE tempdb MODIFY FILE (NAME = temp4 , FILENAME = '$temp_drive\tempdb_mssql_4.ndf', SIZE = 256);
	ALTER DATABASE tempdb MODIFY FILE (NAME = temp5 , FILENAME = '$temp_drive\tempdb_mssql_5.ndf', SIZE = 256);
	ALTER DATABASE tempdb MODIFY FILE (NAME = temp6 , FILENAME = '$temp_drive\tempdb_mssql_6.ndf', SIZE = 256);
	ALTER DATABASE tempdb MODIFY FILE (NAME = temp7 , FILENAME = '$temp_drive\tempdb_mssql_7.ndf', SIZE = 256);
	ALTER DATABASE tempdb MODIFY FILE (NAME = temp8 , FILENAME = '$temp_drive\tempdb_mssql_8.ndf', SIZE = 256);
	GO
	ALTER DATABASE tempdb MODIFY FILE ( NAME = templog , FILENAME = '$temp_drive\templog.ldf' , SIZE = 256MB )
	GO" # DB Resize was moved into next steps since 50GB on smaller drive this could fail before

	Out-File -FilePath 'configure_disk_tmp.sql' -InputObject $cmd_tempdb -Encoding ASCII
	sqlcmd -d $dbname -U $user -P $pass -S $inst -X -i 'configure_disk_tmp.sql'

	#GetRAM INFO
	Write-Output "Set RAM INFO"

	$RAMInfo = ((Get-CimInstance -ClassName 'Cim_PhysicalMemory' | Measure-Object -Property Capacity -Sum).Sum/1048576)
	$RAMInfo = [int]$RAMInfo - $RAMInfo * 0.10
	[int]$RAMInfo

	Write-Output "Tweak SQL Server settings"
	$cmd_advopt = "
	sp_configure 'show advanced options', 1;
	GO
	RECONFIGURE WITH OVERRIDE;
	GO
	sp_configure 'max server memory', $RAMInfo;
	GO
	RECONFIGURE WITH OVERRIDE;
	GO
	sp_configure 'min server memory', $RAMInfo;
	GO
	RECONFIGURE WITH OVERRIDE;
	GO
	sp_configure 'max worker threads', 0;
	GO
	RECONFIGURE WITH OVERRIDE;
	GO
	sp_configure 'recovery interval', 32767;
	GO
	RECONFIGURE WITH OVERRIDE;
	GO
	sp_configure 'max degree of parallelism', 1;
	GO
	RECONFIGURE WITH OVERRIDE;
	GO
	sp_configure 'cost threshold for parallelism', '50';
	GO
	RECONFIGURE WITH OVERRIDE;
	GO
	sp_configure 'priority boost', 1;
	GO
	sp_configure 'default trace enabled', 0;
	GO
	RECONFIGURE WITH OVERRIDE;
	GO
	"

	Out-File -FilePath 'configure_disk_advopt.sql' -InputObject $cmd_advopt -Encoding ASCII
	sqlcmd -d $dbname -U $user -P $pass -S $inst -X -i 'configure_disk_advopt.sql'
	#Invoke-Sqlcmd -ServerInstance $inst -Database Master -Query $cmd_advopt -Username $user -Password $pass

	Write-Output "Restart SQL Service"
	Stop-Service -Name 'MSSQLSERVER' -Force
	Start-Service -Name 'MSSQLSERVER'
	$svc = Get-Service 'MSSQLSERVER'
	$svc.WaitForStatus('Running', (New-TimeSpan -Minutes 5))

	Write-Output "Resize templog.ldf after DB restart on new path"
	$resize_templog = "ALTER DATABASE tempdb MODIFY FILE ( NAME = templog , FILENAME = '$temp_drive\templog.ldf' , SIZE = 50000000KB );
	GO"

	Out-File -FilePath 'resize_templog.sql' -InputObject $resize_templog -Encoding ASCII
	sqlcmd -U $user -P $pass -S $inst -X -i 'resize_templog.sql'

	Write-Output "Run SP Configure"
	sqlcmd -X -e -Q "sp_configure" -o c:\tpcSPConfig.tsv
	Copy-Item -Path "C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Log\ERRORLOG" -Destination "C:\ERRORLOG"

}

catch {
  $error[0] | Format-List * -force
}
