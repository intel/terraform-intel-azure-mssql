

input.expose_rdp (required)
Should RDP firewall rule be created?

input.rdp_allowed_ips (required)
RDP allowed IPs

input.rdp_vars_check (required)
Internal testing variable, do not set or override.

input.server_os_name (required)
Sets which Windows OS will be used for the database VM. For now "SQLServer2019" is supported.

input.ssh_allowed_ips (required)
SSH allowed IPs

input.database_password (null)
Password for MS SQL database

input.database_startup_flags ([])
Which parameter flags use for MS SQL server startup.

input.dbOnly (false)
Create the database VM only (without HammerDB).

input.dbname ("tpcc_200WH")
DB name to created

input.global_tags ({})
Tags applied to whole deployment

input.linux (false)
Should we run linux-based benchmark? Currently unsupported here

input.location ("West US")
Region to create Azure resources in

input.make_key_vault (true)
If true, key vault will be created and SSH keys uploaded into it.

input.prefix ("mssql")
The Prefix used for all resources in module

input.resourcegroup ("OCS")
The Azure resource group in which the resources should be created

input.server_disks_data_disks (1)
How many data disks should be created for database?

input.server_disks_data_iops (null)
IOPS for supported AWS disks (io1, io2, gp3). Ignored on other storage types.

input.server_disks_data_size ("100")
Disk size (GiB) for SQL servers data disks

input.server_disks_data_throughput (null)
IOPS for AWS GP3 disks. Ignored on other storage types.

input.server_disks_wal_iops (null)
IOPS for supported AWS disks (io1, io2, gp3). Ignored on other storage types.

input.server_disks_wal_size ("100")
Disk size (GiB) for SQL servers WAL disk

input.server_disks_wal_throughput (null)
IOPS for AWS GP3 disks. Ignored on other storage types.

input.server_hammerdb_instancetype ("m5.4xlarge")
Instance type name - must be a full name (e.g. m5.4xlarge)

input.server_instancetype ("m5.2xlarge")
SQL instance type name - must be a full name (e.g. m5.2xlarge)

input.server_os_storagetype ("standard")
OS disk type

input.server_storagetype ("standard")
Data disk type.

input.vm_tags ({})
Tags applied to VMs

input.windows (true)
Should we run windows-based benchmark?

input.windows-config_file ("../templates/common.ps1")
Path to Windows SSH Configuration script


output.cloud-environment
Cloud environment outputs

output.db-only
Output db-only variable for output check

output.db_ip
Database public IP address.

output.stresser_ip
Stresser public IP address.

output.vm_admin_password
Administrator password for VM

output.vm_admin_username
Administrator username for VM

output.vm_db
VMs to use for db dashboard

output.vm_stresser
VMs to use for stresser dashboard creation

output.workload_variables
Workload-specific variables
