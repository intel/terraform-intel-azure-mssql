# optimizedcloudstack

Documentation of ansible part of intel-ocs project.

## Tags:

- `installation` - This tag indicates tasks that perform installations and configuration of neccessary components & tools.

- `experiments` - This tag is related to tasks connected with benchmarking, i.e. preparing experiment running HammerDB and collecting results, metrics, etc.

- `export` - This tag indicates tasks that are related to image exporting to local cloud galleries in supported workloads.

- `destroy` - This tag indicates tasks that destroy the infrastructure after exporting tasks, which leave infrastructure unsuitable for destruction using Terraform.

## Variables:

### Collect_metrics:

- `metrics_list_vms`: `[ Percentage CPU, Disk Read Bytes, Disk Write Bytes, Disk Read Operations/sec, Disk Write Operations/sec, Data Disk Queue Depth, OS Disk Queue Depth ]` - List of metrics to retrieve from VMs via API
- `metrics_list_disks`: `[ Composite Disk Read Bytes/sec, Composite Disk Write Bytes/sec, Composite Disk Read Operations/sec, Composite Disk Write Operations/sec ]` - List of metrics to retrieve from disks via API
- `metrics_auth_vars`: `[ subscription_id, client_id, client_secret, resourcegroup, tenant_id]` - List of neccessary variables to check if they are defined for proper authorization [CAN BE OVERWRITEN]
- `metrics_api_parameters`: `` - List with neccessary variables for requests, which include resource lists endpoints, API's versions for different resources and URL methods used
- `metrics_encoded_list`: `` - Dict with encoded comma-separated metrics to retrieve from given resource
- `tmp, list_of_jsons, resources_urls, metrics_values, resource_types`: `[]` - some temporary and/or 'global' variables to keep tasks code clean
- `metrics_auth_body_url`: `https://management.core.windows.net` - Beginning of URL used for authentication with metrics API
- `metrics_api_version`: `api-version=2018-01-01` - Most recent working Azure metrics API version
- `metrics_base_url`: `https://management.azure.com` - Beginning of URL used for metrics collection
- `metrics_endpoint_url`: `providers/microsoft.insights/metrics` - Endpoint of URL for metrics collection
- `metrics_period_start`: `` - Indicates start of metrics collection period (if not provided during benchamrk, defaults to now(UTC=True) )
- `metrics_period_end`: `` - Indicates start of metrics collection period (if not provided during benchamrk, defaults to now() )
- `collect_metrics_missing_vars`: `` - Indicate if all variables are defined

### Common:

- `mysql_hammerdb`: `[MYSQL]` - Dict with URLs to different archives of HammerDB
- `mysql_pkg`: `[MYSQL]` - Dict with URLs to MySQL yum packages
- `common_rhel_dependencies`: `[MYSQL]` - List of Linux dependencies to install
- `hammerdb_version`: `4.2` - Version of HammerDB. Supported version: 3.2, 3.3, 4.0, 4.2. Can be overriden from launcher in perform stage
- `mysql_version`: `8.0.22 [MYSQL]` - Version of MySQL database. Can be overriden from launcher in perform stage
- `lock_default`: `""` - Amount of time to wait for the yum lockfile to be freed. (RedHat Only) lock_default: ""
- `update_cache`: `` - Update package manager cache before installing package update_cache: true/false
- `mysql_service`: `mysql` - Define service name to restart/stop on different distribution
- `mysql_rpm_key_fingerprint`: `` - A fingerprint of the GPG key for RPM repository with MySQL

### Connection:

- `with_cloud_init`: `` - If true, wait for cloud init complete

### Disks:

- `disk_partition_number`: `1` - Number of partition, which will be prepared for attached disk.
- `disk_label_type`: `gpt` - Label type, which will be used for attached disk.
- `fstab_path`: `/etc/fstab` - Path to fstab file.
- `available_devices`: `{}` - Map with all devices and their types (temp_disk, log_disk, data_disk). [DO NOT SET]
- `azure_disk_device_path`: `/dev/disk/azure` - Path to disk devices on Azure VM

### Export_image:

- `export_vm_name_full`: `<workload-specific>` - Specify which image will be used in image creation procedure. By default it's database virtual machine. Need to be full virtual machine id
- `export_vm_name`: `<workload-specific>` - Specify which image will be used in image creation procedure. By default it's database virtual machine.
- `export_image_name`: `intel_optimized_cloud_image` - Specify name for image created in export step
- `client_id`: `""` - (Service principal only) Used in authorization with az login command. Can be overriden from launcher in perform stage. Mandatory for export action step.
- `client_secret`: `""` - (Service principal only) Used in authorization with az login command. Can be overriden from launcher in perform stage. Mandatory for export action step.
- `resourcegroup`: `""` - (Service principal only) Used in authorization with az login command. Can be overriden from launcher in perform stage. Mandatory for export action step.
- `tenant_id`: `""` - (Service principal only) Used in authorization with az login command. Can be overriden from launcher in perform stage. Mandatory for export action step.
- `temporary_files`: `__pycache__, terraform/.terraform, terraform/.terraform.lock.hcl, terraform/terraform.tfstate, terraform/terraform.tfvars, terraform/terraform.tfstate.backup` - Used to clean temporary files in export destroy mode,
- `target_resourcegroup`: `{{ resourcegroup }}_IMAGS` - Used in exporting image to other resource group.
- `location`: `"westus"` - Used in exporting image to specify destination Azure region. Can be overriden from launcher in perform stage. Mandatory for export action step.
- `export_image_mandatory_vars`: `client_id, client_secret, resourcegroup, tenant_id` - Used in validation, validate mandatory variables

### Hammerdb:

- `hammerdb_bin_dir`: `[MSSQL]` - Sets path for HammerDB binaries, loaded from group_vars/os_windows.yaml
- `hammerdb_urls`: `` - Dict with HammerDB zip URLs for each OS, loaded from group*vars/os*<used_os>.yaml hammerdb_urls:
- `mssql_hammerdb`: `[MSSQL]` - Dict with paths neccessary for installation and benchmarking
- `mysql_hammerdb`: `[MYSQL]` - Dict with paths necessary for installation and benchmarking
- `mysql_client_dependencies`: `[MYSQL]` - Name of MySQL client yum package
- `hammerdb_version`: `4.2` - Version of HammerDB. Supported version: 3.2, 3.3, 4.0, 4.2. Can be overriden from launcher in perform stage
- `execution_count`: `1` - [MSSQL] Count of test execution to perform. Can be overriden from launcher in perform stage. Currently not supported other value then 1.
- `database_name`: `tpcc_200WH` - [MSSQL] Name of database to create. Can be overriden from launcher in perform stage.
- `restoredb`: `no` - [MSSQL] Decide if schema should be restored before test. Value yes/no. Can be overriden from launcher in perform stage.
- `hammerdb_install_path`: `/opt/HammerDB<VERSION>` - [MYSQL] Set in common role. Decide where install hammerdb.
- `v_users`: `12` - Number of virtual users used in benchmark. Can be overriden from launcher in perform stage.
- `results_dir_name`: `"{{ base_dir }}/benchmark-results"` - Directory where results will be stored.
- `windows_odbc_driver`: `"{ODBC Driver 17 for SQL Server}"` - Name of driver used during windows test.
- `linux_odbc_driver`: `"{ODBC Driver 17 for SQL Server}"` - Name of driver used during linux test.
- `warehouses`: `200` - Number of warehouses used during benchmark. Can be overriden from launcher in perform stage.
- `driver_name`: `"test"` - Set driver used in hammerdb benchmark. If hammerdb version == 4.0 use test, otherwise timed driver_name: "test"
- `rampup_duration`: `10` - Specify rampup duration. Can be overriden from launcher in perform stage.
- `test_duration`: `5` - Specify test duration. Can be overriden from launcher in perform stage.

### Mssql:

- `hammerdb_bin_dir`: `[MSSQL]` - Sets path for HammerDB binaries
- `hammerdb_urls`: `[MSSQL]` - Dict with HammerDB zip URLs imported per OS from group*vars/os*<used os>.yaml hammerdb_urls:
- `mssql_hammerdb`: `[MSSQL]` - Dict with paths used for installation and benchmarking
- `mssql`: `[MSSQL]` - Dict with neccessary mssql variables like port, username and password
- `vm_mssql_host_temp_path`: `[MSSQL]` - Path to temporary dir inside MSSQL virtual machine
- `server_disks_data_disks`: `[MSSQL]` - Passes number of used data disks for SQL preparation script
- `database_startup_flags`: `[MSSQL]` - Which parameter flags should be used during MS SQL server startup. Defaults to space so that argument has any value inside the script call.
- `database_name`: `tpcc_200WH` - [MSSQL] Name of database to create. Can be overriden from launcher in perform stage.

### Mysql:

- `hammerdb_urls`: `[MYSQL]` - Dict with HammerDB zip URLs for each os, loaded from group*vars/os*<used os>.yaml hammerdb_urls:
- `mysql_hammerdb`: `[MYSQL]` - Dict with URLs to different archives of HammerDB
- `mysql`: `[MYSQL]` - Dict with MySQL & HammerDB passwords and default installation dirs
- `mysql_conf`: `[MYSQL]` - Dict with InnoDB (storage engine) variables used to configure MySQL databsase
- `python_rhel_dependencies`: `[MYSQL]` - List of Python dependencies to install
- `mysql_server_dependencies`: `[MYSQL]` - List of MySQL dependencies to install
- `mysql_server_additional_dependencies`: `[MYSQL]` - List of additional MySQL dependencies to install (plugins) mysql_server_additional_dependencies: - "mysql-community-client-plugins-{{ mysql_version }}-1.el8"
- `mysql_mount_dir`: `"/var/lib"` - Define directory where mysql will store data. Very important if using additional drives. Should be change to /mnt/mysqldata in this case (Also required changes in prepare stage!). Can be overriden from launcher in perform stage.
- `mysql_dir`: `"{{ mysql_mount_dir }}/mysql"` - Define mysql directory. Set automatically during role run.
- `mysql_version`: `8.0.22 [MYSQL]` - Version of MySQL database. Can be overriden from launcher in perform stage
- `mysql_hammerdb_pass`: `"" [MYSQL]` - Auto generated during role run. Check log for task "Show generated mysql hammerdb database password".
- `huge_pages`: `"yes" [MYSQL]` - If yes MySQL database will use huge pages settings. Increase performance. Sizes are automatically calculated during run. Values: "yes|no" Can be overriden from launcher in perform stage.
- `numOfHugePages`: `[MYSQL]` - calculated during perform phase, depends from available memory numOfHugePages: ""
- `innodb_buffer_pool_size_KB`: `[MYSQL]` - extracted from database settings. Used in internal optimilization innodb_buffer_pool_size_KB: ""
- `totalMemForHugePages_KB`: `[MYSQL]` - calculated during perform phase, depends from available memory totalMemForHugePages_KB: ""
- `numOfNormalpages`: `[MYSQL]` - calculated during perform phase, depends from available memory numOfNormalpages: ""
- `innodbLargestBlockSize`: `[MYSQL]` - calculated during perform phase, depends from available memory innodbLargestBlockSize: ""
- `innodb_buffer_pool_size_B`: `[MYSQL]` - calculated during perform phase, depends from available memory innodb_buffer_pool_size_B: ""
- `lock_default`: `""` - Amount of time to wait for the yum lockfile to be freed. (RedHat Only) lock_default: ""
- `update_cache`: `` - Update package manager cache before installing package update_cache: true/false
- `mysql_password_args`: `` - Add arguments for mysql password change like socket or temporary password
- `login_unix_socket`: `` - login socket use during mysql operations login_unix_socket:

### Parse_results:

- `NOPM_REGEX`: `(?<=achieved).*(?=NOPM)` - REGEX expression for parsing NOPM benchmark result
- `TPM_REGEX`: `(?<=\\bNOPM from\\s)(\\w+)` - REGEX expression for parsing TPM benchmark result

### Vm_mitigation:

- `mitigation_dir`: `"{{ results_root }}/mitigation-results"` - Specify where save mitigation report.

Documentation generated using: [Ansible-autodoc](https://github.com/AndresBott/ansible-autodoc)
