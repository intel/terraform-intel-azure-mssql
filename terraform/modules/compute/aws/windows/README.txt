

input.admin_password (required)
Passwords which will be used for administrator account. Does not have a default value and has to be set.

input.instancetype (required)
AWS VM instance type.

input.module_cloud_env (required)
Plugin for cloud-env module outputs.

input.name (required)
VM name.

input.nic_name (required)
Network Interface to attach.

input.os_name (required)
Name of OS that will be used. Currently can be "WindowsServer2019" or "SQLServer2019".

input.tags (required)
Tags which will be applied to VM-related resources.

input.admin_username ("adminuser")
Username which will be used for administrator account. Defaults to "adminuser".

input.os_disksize (null)
(Optional) Size of OS disk. If left unset, defaults to OS image size.

input.os_storagetype ("standard")
(Optional) Type of OS disk. If left unset, defaults 'standard' disk type.

input.user_data (null)
List of templatefile outputs passed to user-data parameter, used to launch short EC2Launch scripts. This can run Powershell and other scripts.

input.windows-powershell-template_file ("../templates/aws-userdata.tmpl")
Path to AWS Powershell user_data template

input.windows-user-config_file ("../templates/modify-admin-account.ps1")
Path to Windows Administrator user modification script


output.vm
VM object created by this module.

output.vm_info
Object which contains additional information about VM.
