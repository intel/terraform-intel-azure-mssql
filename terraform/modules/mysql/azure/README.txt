

input.expose_rdp (required)
Should RDP rule be created?

input.rdp_allowed_ips (required)
RDP allowed IPs

input.ssh_allowed_ips (required)
SSH allowed IPs

input.dbOnly (false)
Create the database VM only (without HammerDB).

input.global_tags ({})
Tags applied to whole deployment

input.linux (true)
If should run linux-based benchmark.

input.location ("West US")
Region to create Azure resources in.

input.make_key_vault (true)
If true, key vault will be created and SSH keys uploaded into it.

input.prefix ("mysql")
The Prefix used for all resources in module.

input.resourcegroup ("GoldenImageResourceGroup")
The Azure resource group in which the resources should be created.

input.server_disks_data_size ("512")
Disk size (GB) for SQL data disk in servers.

input.server_hammerdb_instancetype ("Standard_E32_v4")
HammerDB Instance type name - must be a full name (e.g. Standard_E4ds_v4)

input.server_instancetype ("Standard_E4ds_v4")
Instance type name - must be a full name (e.g. Standard_E4ds_v4).

input.server_os_disksize (1024)
Size of MySQL OS disk in GB.

input.server_os_name ("CentOS8.1")
Sets which OS will be used for the virtual machines. For now "CentOS8.1" and "RHEL8.1" are supported.

input.server_os_storagetype ("Standard")
Disk type standard/standardSSD/premium/ultraSSD for Operating System

input.server_storagetype ("Standard")
Disk type standard/standardSSD/premium/ultraSSD.

input.spawn_disks (false)
Should the data disks be spawned?

input.vm_tags ({})
Tags applied to VMs

input.windows (false)
If should run windows-based benchmark.


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
