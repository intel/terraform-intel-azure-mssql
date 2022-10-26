

input.instancetype (required)
VM instance size.

input.module_cloud_env (required)
Plugin for cloud-env module outputs.

input.name (required)
VM name.

input.nic_name (required)
Network Interface to attach.

input.os_name (required)
Name of OS that will be used. For now "CentOS8.1" and "RHEL8.1" and "Ubuntu20.04" are supported.

input.tags (required)
Tags which will be applied to VM-related resources.

input.admin_username ("adminuser")
Username which will be used for administrator account. Defaults to "adminuser".

input.custom_data (null)
Cloud-config data encoded as base64.

input.os_disksize (null)
(Optional) Size of OS disk. If left unset, defaults to OS image size.

input.os_storagetype ("Standard")
(Optional) Type of OS disk. If left unset, defaults 'Standard' disk type.


output.vm
VM object created by this module.

output.vm_info
Object which contains additional information about VM.
