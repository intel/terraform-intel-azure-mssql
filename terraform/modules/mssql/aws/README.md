## Inputs

The following input variables are supported:

### <a name="input_expose_rdp"></a> [expose\_rdp](#input\_expose\_rdp)

Description: Should RDP firewall rule be created?

Default: n/a

### <a name="input_rdp_allowed_ips"></a> [rdp\_allowed\_ips](#input\_rdp\_allowed\_ips)

Description: RDP allowed IPs

Default: n/a

### <a name="input_rdp_vars_check"></a> [rdp\_vars\_check](#input\_rdp\_vars\_check)

Description: Internal testing variable, do not set or override.

Default: n/a

### <a name="input_server_os_name"></a> [server\_os\_name](#input\_server\_os\_name)

Description: Sets which Windows OS will be used for the database VM. For now "SQLServer2019" is supported.

Default: n/a

### <a name="input_ssh_allowed_ips"></a> [ssh\_allowed\_ips](#input\_ssh\_allowed\_ips)

Description: SSH allowed IPs

Default: n/a

### <a name="input_database_password"></a> [database\_password](#input\_database\_password)

Description: Password for MS SQL database

Default: `null`

### <a name="input_database_startup_flags"></a> [database\_startup\_flags](#input\_database\_startup\_flags)

Description: Which parameter flags use for MS SQL server startup.

Default: `[]`

### <a name="input_dbOnly"></a> [dbOnly](#input\_dbOnly)

Description: Create the database VM only (without HammerDB).

Default: `false`

### <a name="input_dbname"></a> [dbname](#input\_dbname)

Description: DB name to created

Default: `"tpcc_200WH"`

### <a name="input_global_tags"></a> [global\_tags](#input\_global\_tags)

Description: Tags applied to whole deployment

Default: `{}`

### <a name="input_linux"></a> [linux](#input\_linux)

Description: Should we run linux-based benchmark? Currently unsupported here

Default: `false`

### <a name="input_location"></a> [location](#input\_location)

Description: Region to create Azure resources in

Default: `"West US"`

### <a name="input_make_key_vault"></a> [make\_key\_vault](#input\_make\_key\_vault)

Description: If true, key vault will be created and SSH keys uploaded into it.

Default: `true`

### <a name="input_prefix"></a> [prefix](#input\_prefix)

Description: The Prefix used for all resources in module

Default: `"mssql"`

### <a name="input_resourcegroup"></a> [resourcegroup](#input\_resourcegroup)

Description: The Azure resource group in which the resources should be created

Default: `"OCS"`

### <a name="input_server_disks_data_disks"></a> [server\_disks\_data\_disks](#input\_server\_disks\_data\_disks)

Description: How many data disks should be created for database?

Default: `1`

### <a name="input_server_disks_data_iops"></a> [server\_disks\_data\_iops](#input\_server\_disks\_data\_iops)

Description: IOPS for supported AWS disks (io1, io2, gp3). Ignored on other storage types.

Default: `null`

### <a name="input_server_disks_data_size"></a> [server\_disks\_data\_size](#input\_server\_disks\_data\_size)

Description: Disk size (GiB) for SQL servers data disks

Default: `"100"`

### <a name="input_server_disks_data_throughput"></a> [server\_disks\_data\_throughput](#input\_server\_disks\_data\_throughput)

Description: IOPS for AWS GP3 disks. Ignored on other storage types.

Default: `null`

### <a name="input_server_disks_wal_iops"></a> [server\_disks\_wal\_iops](#input\_server\_disks\_wal\_iops)

Description: IOPS for supported AWS disks (io1, io2, gp3). Ignored on other storage types.

Default: `null`

### <a name="input_server_disks_wal_size"></a> [server\_disks\_wal\_size](#input\_server\_disks\_wal\_size)

Description: Disk size (GiB) for SQL servers WAL disk

Default: `"100"`

### <a name="input_server_disks_wal_throughput"></a> [server\_disks\_wal\_throughput](#input\_server\_disks\_wal\_throughput)

Description: IOPS for AWS GP3 disks. Ignored on other storage types.

Default: `null`

### <a name="input_server_hammerdb_instancetype"></a> [server\_hammerdb\_instancetype](#input\_server\_hammerdb\_instancetype)

Description: Instance type name - must be a full name (e.g. m5.4xlarge)

Default: `"m5.4xlarge"`

### <a name="input_server_instancetype"></a> [server\_instancetype](#input\_server\_instancetype)

Description: SQL instance type name - must be a full name (e.g. m5.2xlarge)

Default: `"m5.2xlarge"`

### <a name="input_server_os_storagetype"></a> [server\_os\_storagetype](#input\_server\_os\_storagetype)

Description: OS disk type

Default: `"standard"`

### <a name="input_server_storagetype"></a> [server\_storagetype](#input\_server\_storagetype)

Description: Data disk type.

Default: `"standard"`

### <a name="input_vm_tags"></a> [vm\_tags](#input\_vm\_tags)

Description: Tags applied to VMs

Default: `{}`

### <a name="input_windows"></a> [windows](#input\_windows)

Description: Should we run windows-based benchmark?

Default: `true`

### <a name="input_windows-config_file"></a> [windows-config\_file](#input\_windows-config\_file)

Description: Path to Windows SSH Configuration script

Default: `"../templates/common.ps1"`

## Outputs

The following outputs are exported:

### <a name="output_cloud-environment"></a> [cloud-environment](#output\_cloud-environment)

Description: Cloud environment outputs

### <a name="output_db-only"></a> [db-only](#output\_db-only)

Description: Output db-only variable for output check

### <a name="output_db_ip"></a> [db\_ip](#output\_db\_ip)

Description: Database public IP address.

### <a name="output_stresser_ip"></a> [stresser\_ip](#output\_stresser\_ip)

Description: Stresser public IP address.

### <a name="output_vm_admin_password"></a> [vm\_admin\_password](#output\_vm\_admin\_password)

Description: Administrator password for VM

### <a name="output_vm_admin_username"></a> [vm\_admin\_username](#output\_vm\_admin\_username)

Description: Administrator username for VM

### <a name="output_vm_db"></a> [vm\_db](#output\_vm\_db)

Description: VMs to use for db dashboard

### <a name="output_vm_stresser"></a> [vm\_stresser](#output\_vm\_stresser)

Description: VMs to use for stresser dashboard creation

### <a name="output_workload_variables"></a> [workload\_variables](#output\_workload\_variables)

Description: Workload-specific variables
