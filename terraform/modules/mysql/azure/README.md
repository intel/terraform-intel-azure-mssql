## Inputs

The following input variables are supported:

### <a name="input_expose_rdp"></a> [expose\_rdp](#input\_expose\_rdp)

Description: Should RDP rule be created?

Default: n/a

### <a name="input_rdp_allowed_ips"></a> [rdp\_allowed\_ips](#input\_rdp\_allowed\_ips)

Description: RDP allowed IPs

Default: n/a

### <a name="input_ssh_allowed_ips"></a> [ssh\_allowed\_ips](#input\_ssh\_allowed\_ips)

Description: SSH allowed IPs

Default: n/a

### <a name="input_dbOnly"></a> [dbOnly](#input\_dbOnly)

Description: Create the database VM only (without HammerDB).

Default: `false`

### <a name="input_global_tags"></a> [global\_tags](#input\_global\_tags)

Description: Tags applied to whole deployment

Default: `{}`

### <a name="input_linux"></a> [linux](#input\_linux)

Description: If should run linux-based benchmark.

Default: `true`

### <a name="input_location"></a> [location](#input\_location)

Description: Region to create Azure resources in.

Default: `"West US"`

### <a name="input_make_key_vault"></a> [make\_key\_vault](#input\_make\_key\_vault)

Description: If true, key vault will be created and SSH keys uploaded into it.

Default: `true`

### <a name="input_prefix"></a> [prefix](#input\_prefix)

Description: The Prefix used for all resources in module.

Default: `"mysql"`

### <a name="input_resourcegroup"></a> [resourcegroup](#input\_resourcegroup)

Description: The Azure resource group in which the resources should be created.

Default: `"GoldenImageResourceGroup"`

### <a name="input_server_disks_data_size"></a> [server\_disks\_data\_size](#input\_server\_disks\_data\_size)

Description: Disk size (GB) for SQL data disk in servers.

Default: `"512"`

### <a name="input_server_hammerdb_instancetype"></a> [server\_hammerdb\_instancetype](#input\_server\_hammerdb\_instancetype)

Description: HammerDB Instance type name - must be a full name (e.g. Standard\_E4ds\_v4)

Default: `"Standard_E32_v4"`

### <a name="input_server_instancetype"></a> [server\_instancetype](#input\_server\_instancetype)

Description: Instance type name - must be a full name (e.g. Standard\_E4ds\_v4).

Default: `"Standard_E4ds_v4"`

### <a name="input_server_os_disksize"></a> [server\_os\_disksize](#input\_server\_os\_disksize)

Description: Size of MySQL OS disk in GB.

Default: `1024`

### <a name="input_server_os_name"></a> [server\_os\_name](#input\_server\_os\_name)

Description: Sets which OS will be used for the virtual machines. For now "CentOS8.1" and "RHEL8.1" are supported.

Default: `"CentOS8.1"`

### <a name="input_server_os_storagetype"></a> [server\_os\_storagetype](#input\_server\_os\_storagetype)

Description: Disk type standard/standardSSD/premium/ultraSSD for Operating System

Default: `"Standard"`

### <a name="input_server_storagetype"></a> [server\_storagetype](#input\_server\_storagetype)

Description: Disk type standard/standardSSD/premium/ultraSSD.

Default: `"Standard"`

### <a name="input_spawn_disks"></a> [spawn\_disks](#input\_spawn\_disks)

Description: Should the data disks be spawned?

Default: `false`

### <a name="input_vm_tags"></a> [vm\_tags](#input\_vm\_tags)

Description: Tags applied to VMs

Default: `{}`

### <a name="input_windows"></a> [windows](#input\_windows)

Description: If should run windows-based benchmark.

Default: `false`

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
