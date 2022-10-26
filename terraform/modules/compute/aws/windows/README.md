## Inputs

The following input variables are supported:

### <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password)

Description: Passwords which will be used for administrator account. Does not have a default value and has to be set.

Default: n/a

### <a name="input_instancetype"></a> [instancetype](#input\_instancetype)

Description: AWS VM instance type.

Default: n/a

### <a name="input_module_cloud_env"></a> [module\_cloud\_env](#input\_module\_cloud\_env)

Description: Plugin for cloud-env module outputs.

Default: n/a

### <a name="input_name"></a> [name](#input\_name)

Description: VM name.

Default: n/a

### <a name="input_nic_name"></a> [nic\_name](#input\_nic\_name)

Description: Network Interface to attach.

Default: n/a

### <a name="input_os_name"></a> [os\_name](#input\_os\_name)

Description: Name of OS that will be used. Currently can be "WindowsServer2019" or "SQLServer2019".

Default: n/a

### <a name="input_tags"></a> [tags](#input\_tags)

Description: Tags which will be applied to VM-related resources.

Default: n/a

### <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username)

Description: Username which will be used for administrator account. Defaults to "adminuser".

Default: `"adminuser"`

### <a name="input_os_disksize"></a> [os\_disksize](#input\_os\_disksize)

Description: (Optional) Size of OS disk. If left unset, defaults to OS image size.

Default: `null`

### <a name="input_os_storagetype"></a> [os\_storagetype](#input\_os\_storagetype)

Description: (Optional) Type of OS disk. If left unset, defaults 'standard' disk type.

Default: `"standard"`

### <a name="input_user_data"></a> [user\_data](#input\_user\_data)

Description: List of templatefile outputs passed to user-data parameter, used to launch short EC2Launch scripts. This can run Powershell and other scripts.

Default: `null`

### <a name="input_windows-powershell-template_file"></a> [windows-powershell-template\_file](#input\_windows-powershell-template\_file)

Description: Path to AWS Powershell user\_data template

Default: `"../templates/aws-userdata.tmpl"`

### <a name="input_windows-user-config_file"></a> [windows-user-config\_file](#input\_windows-user-config\_file)

Description: Path to Windows Administrator user modification script

Default: `"../templates/modify-admin-account.ps1"`

## Outputs

The following outputs are exported:

### <a name="output_vm"></a> [vm](#output\_vm)

Description: VM object created by this module.

### <a name="output_vm_info"></a> [vm\_info](#output\_vm\_info)

Description: Object which contains additional information about VM.
