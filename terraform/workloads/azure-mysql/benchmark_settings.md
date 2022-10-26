## Inputs

The following input variables are supported:

### <a name="input_scenario"></a> [scenario](#input\_scenario)

Description: Select scenario for benchmark.

Default: n/a

### <a name="input_ssh_allowed_ips"></a> [ssh\_allowed\_ips](#input\_ssh\_allowed\_ips)

Description: IPs to allow through SSH firewall. This field must be populated for any of benchmark automation to work! Using "*", "Any", an empty list and literal ranges "224.0.0.0/4", "255.255.255.255/32", "127.0.0.0/8", "169.254.0.0/16", "168.63.129.16/32" and "0.0.0.0/0" is not allowed.

Default: n/a

### <a name="input_auto_update"></a> [auto\_update](#input\_auto\_update)

Description: (MySQL) If true, update all packages (including kernel and os package). Currently update to the newest Centos 8 (f.e 8.5)

Default: `false`

### <a name="input_client_id"></a> [client\_id](#input\_client\_id)

Description: Azure Client ID to use.

Default: `null`

### <a name="input_client_secret"></a> [client\_secret](#input\_client\_secret)

Description: Azure Service Principal secret to use.

Default: `null`

### <a name="input_custom_profile"></a> [custom\_profile](#input\_custom\_profile)

Description: Select preprepared custom scenario for benchmark test.

Default: `""`

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

Description: What Azure region should be used for the resources.

Default: `"West US"`

### <a name="input_make_key_vault"></a> [make\_key\_vault](#input\_make\_key\_vault)

Description: If true, key vault will be created and keys uploaded into it.

Default: `true`

### <a name="input_rdp_allowed_ips"></a> [rdp\_allowed\_ips](#input\_rdp\_allowed\_ips)

Description: IPs to allow through RDP firewall. By default allows no addresses. This value is only used when expose\_rdp is set to true simultaneously. Using literal ranges"224.0.0.0/4", "255.255.255.255/32", "127.0.0.0/8", "169.254.0.0/16", "168.63.129.16/32" and "0.0.0.0/0" is not allowed.

Default: `null`

### <a name="input_resourcegroup"></a> [resourcegroup](#input\_resourcegroup)

Description: What resource group should be used to spawn the resources.

Default: `"IntelOptimizedCloudStack"`

### <a name="input_server_disks_data_size"></a> [server\_disks\_data\_size](#input\_server\_disks\_data\_size)

Description: How big should each data disk be in GB? Minimally 1. Used in MSSQL, MySQL and Oracle (together with "spawn\_disks"=true and mysql\_mount\_dir set to "/mnt/mysqldata" and oracle\_mount\_dir set to "/mnt/oracledata").

Default: `512`

### <a name="input_server_hammerdb_instancetype"></a> [server\_hammerdb\_instancetype](#input\_server\_hammerdb\_instancetype)

Description: Which instance type to use for HammerDB.

Default: `"Standard_E32_v4"`

### <a name="input_server_instancetype"></a> [server\_instancetype](#input\_server\_instancetype)

Description: Which instance type to use.

Default: `"Standard_E64ds_v4"`

### <a name="input_server_os_disksize"></a> [server\_os\_disksize](#input\_server\_os\_disksize)

Description: Size of database OS disk. Might need to be customized when not using spawn\_disks set to "true" with large warehouses.

Default: `1024`

### <a name="input_server_os_name"></a> [server\_os\_name](#input\_server\_os\_name)

Description: Sets which operating will be used for the database virtual machine.

Default: `"CentOS8.1"`

### <a name="input_server_os_storagetype"></a> [server\_os\_storagetype](#input\_server\_os\_storagetype)

Description: Type of disks to use for Operating System. Currently supports Standard and Premium.

Default: `"Standard"`

### <a name="input_server_storagetype"></a> [server\_storagetype](#input\_server\_storagetype)

Description: Type of disks to use. Currently supports Standard and Premium.

Default: `"Premium"`

### <a name="input_spawn_disks"></a> [spawn\_disks](#input\_spawn\_disks)

Description: (MySQL) If set to false, creates DB on os disk. If set to true, spawns %server\_disks\_data\_size% GB sized disk for database. It does not install the database on it unless respective paramter in ansible is set.

Default: `false`

### <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id)

Description: Azure Subscription ID to use.

Default: `null`

### <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id)

Description: Azure Tenant ID to use.

Default: `null`

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

### <a name="output_x_1_key_vault_name"></a> [x\_1\_key\_vault\_name](#output\_x\_1\_key\_vault\_name)

Description: Key Vault name to use for sharing the keys

### <a name="output_x_2_key_vault_private_key"></a> [x\_2\_key\_vault\_private\_key](#output\_x\_2\_key\_vault\_private\_key)

Description: Name of the private key in Key Vault - used for sharing access to VMs

### <a name="output_x_3_vm_admin_password"></a> [x\_3\_vm\_admin\_password](#output\_x\_3\_vm\_admin\_password)

Description: Administrator password for VM

### <a name="output_x_3_vm_admin_username"></a> [x\_3\_vm\_admin\_username](#output\_x\_3\_vm\_admin\_username)

Description: Administrator username for VM

### <a name="output_x_98_workload_variables"></a> [x\_98\_workload\_variables](#output\_x\_98\_workload\_variables)

Description: Workload-specific variables

### <a name="output_x_99_benchmark"></a> [x\_99\_benchmark](#output\_x\_99\_benchmark)

Description: Benchmark module outputs
