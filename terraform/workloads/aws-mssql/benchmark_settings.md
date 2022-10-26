## Inputs

The following input variables are supported:

### <a name="input_scenario"></a> [scenario](#input\_scenario)

Description: Select scenario for benchmark.

Default: n/a

### <a name="input_ssh_allowed_ips"></a> [ssh\_allowed\_ips](#input\_ssh\_allowed\_ips)

Description: IPs to allow through SSH firewall. This field must be populated for any of benchmark automation to work! Using an empty list and literal range "0.0.0.0/0" is not allowed. Ranges are only correct if passed in form 'x.x.x.x/y'.

Default: n/a

### <a name="input_access_key"></a> [access\_key](#input\_access\_key)

Description: AWS Access Key to use.

Default: `null`

### <a name="input_custom_profile"></a> [custom\_profile](#input\_custom\_profile)

Description: Select preprepared custom scenario for benchmark test.

Default: `""`

### <a name="input_database_password"></a> [database\_password](#input\_database\_password)

Description: Password for MS SQL database. If not set password will be randomly generated

Default: `null`

### <a name="input_dbOnly"></a> [dbOnly](#input\_dbOnly)

Description: If set to "true", only the database VM is deployed.

Default: `false`

### <a name="input_expose_rdp"></a> [expose\_rdp](#input\_expose\_rdp)

Description: Should RDP be exposed to the Internet?

Default: `false`

### <a name="input_global_tags"></a> [global\_tags](#input\_global\_tags)

Description: Dictionary of tags that will be applied to deployment.

Default: `{}`

### <a name="input_linux"></a> [linux](#input\_linux)

Description: Run benchmark on Linux.

Default: `true`

### <a name="input_location"></a> [location](#input\_location)

Description: What AWS region should be used for the resources.

Default: `"us-west-1"`

### <a name="input_make_key_vault"></a> [make\_key\_vault](#input\_make\_key\_vault)

Description: If true, key vault will be created and keys uploaded into it.

Default: `true`

### <a name="input_rdp_allowed_ips"></a> [rdp\_allowed\_ips](#input\_rdp\_allowed\_ips)

Description: IPs to allow through RDP firewall. By default allows no addresses. This value is only used when expose\_rdp is set to true simultaneously. Using literal range "0.0.0.0/0" is not allowed. Ranges are only correct if passed in form 'x.x.x.x/y'.

Default: `null`

### <a name="input_resourcegroup"></a> [resourcegroup](#input\_resourcegroup)

Description: What resource group should be used to spawn the resources.

Default: `"IOCS"`

### <a name="input_secret_key"></a> [secret\_key](#input\_secret\_key)

Description: AWS Secret Key to use.

Default: `null`

### <a name="input_server_disks_data_disks"></a> [server\_disks\_data\_disks](#input\_server\_disks\_data\_disks)

Description: Used only in MSSQL benchmark. How many data disks to use. Value can't be bigger than 16 disks and must be compliant to selected VM.

Default: `2`

### <a name="input_server_disks_data_iops"></a> [server\_disks\_data\_iops](#input\_server\_disks\_data\_iops)

Description: IOPS for supported AWS disks (io1, io2, gp3). Ignored on other storage types.

Default: `3000`

### <a name="input_server_disks_data_size"></a> [server\_disks\_data\_size](#input\_server\_disks\_data\_size)

Description: How big should each data disk be in GB? Minimally 1. Used in MSSQL, MySQL and Oracle (together with "spawn\_disks"=true and mysql\_mount\_dir set to "/mnt/mysqldata" and oracle\_mount\_dir set to "/mnt/oracledata").

Default: `512`

### <a name="input_server_disks_data_throughput"></a> [server\_disks\_data\_throughput](#input\_server\_disks\_data\_throughput)

Description: Throughput in MiB/s for AWS GP3 disks. Ignored on other storage types.

Default: `125`

### <a name="input_server_disks_wal_iops"></a> [server\_disks\_wal\_iops](#input\_server\_disks\_wal\_iops)

Description: IOPS for supported AWS disks (io1, io2, gp3). Ignored on other storage types.

Default: `3000`

### <a name="input_server_disks_wal_size"></a> [server\_disks\_wal\_size](#input\_server\_disks\_wal\_size)

Description: Used only in MSSQL benchmark. Specify the disk size used for SQL Server write-ahead log.

Default: `128`

### <a name="input_server_disks_wal_throughput"></a> [server\_disks\_wal\_throughput](#input\_server\_disks\_wal\_throughput)

Description: Throughput in MiB/s for AWS GP3 disks. Ignored on other storage types.

Default: `125`

### <a name="input_server_hammerdb_instancetype"></a> [server\_hammerdb\_instancetype](#input\_server\_hammerdb\_instancetype)

Description: Which instance type to use for HammerDB.

Default: `"m5.8xlarge"`

### <a name="input_server_instancetype"></a> [server\_instancetype](#input\_server\_instancetype)

Description: Which instance type to use.

Default: `"m6i.4xlarge"`

### <a name="input_server_os_disksize"></a> [server\_os\_disksize](#input\_server\_os\_disksize)

Description: Size of database OS disk. Might need to be customized when not using spawn\_disks set to "true" with large warehouses.

Default: `1024`

### <a name="input_server_os_name"></a> [server\_os\_name](#input\_server\_os\_name)

Description: Sets which operating will be used for the database virtual machine.

Default: `"SQLServer2019"`

### <a name="input_server_os_storagetype"></a> [server\_os\_storagetype](#input\_server\_os\_storagetype)

Description: Type of disks to use. Can be "io1", "io2", "gp2" and "gp3" and "standard".

Default: `"standard"`

### <a name="input_server_storagetype"></a> [server\_storagetype](#input\_server\_storagetype)

Description: Type of disks to use. Can be "io1", "io2", "gp2" and "gp3".

Default: `"gp2"`

### <a name="input_vm_tags"></a> [vm\_tags](#input\_vm\_tags)

Description: Dictionary of additional tags that will be applied to VMs only.

Default: `{}`

### <a name="input_windows"></a> [windows](#input\_windows)

Description: Run benchmark on Windows.

Default: `false`

## Outputs

The following outputs are exported:

### <a name="output_x_0_db_ip"></a> [x\_0\_db\_ip](#output\_x\_0\_db\_ip)

Description: Database public IP for access

### <a name="output_x_0_private_key_filename"></a> [x\_0\_private\_key\_filename](#output\_x\_0\_private\_key\_filename)

Description: Path to private key file.

### <a name="output_x_0_stresser_ip"></a> [x\_0\_stresser\_ip](#output\_x\_0\_stresser\_ip)

Description: Stresser public IP for access

### <a name="output_x_2_private_key_secret"></a> [x\_2\_private\_key\_secret](#output\_x\_2\_private\_key\_secret)

Description: Name of the private key in Secret Manager - used for sharing access to VMs

### <a name="output_x_3_vm_admin_password"></a> [x\_3\_vm\_admin\_password](#output\_x\_3\_vm\_admin\_password)

Description: Administrator password for VM

### <a name="output_x_3_vm_admin_username"></a> [x\_3\_vm\_admin\_username](#output\_x\_3\_vm\_admin\_username)

Description: Administrator username for VM

### <a name="output_x_3_vm_windows_aws_random_passwords"></a> [x\_3\_vm\_windows\_aws\_random\_passwords](#output\_x\_3\_vm\_windows\_aws\_random\_passwords)

Description: Random Windows passwords generated from AWS

### <a name="output_x_98_workload_variables"></a> [x\_98\_workload\_variables](#output\_x\_98\_workload\_variables)

Description: Workload-specific variables

### <a name="output_x_99_benchmark"></a> [x\_99\_benchmark](#output\_x\_99\_benchmark)

Description: Benchmark module outputs
