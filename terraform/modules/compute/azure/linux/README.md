## Inputs

The following input variables are supported:

### <a name="input_instancetype"></a> [instancetype](#input\_instancetype)

Description: VM instance size.

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

Description: Name of OS that will be used. For now "CentOS8.1" and "RHEL8.1" and "Ubuntu20.04" are supported.

Default: n/a

### <a name="input_tags"></a> [tags](#input\_tags)

Description: Tags which will be applied to VM-related resources.

Default: n/a

### <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username)

Description: Username which will be used for administrator account. Defaults to "adminuser".

Default: `"adminuser"`

### <a name="input_custom_data"></a> [custom\_data](#input\_custom\_data)

Description: Cloud-config data encoded as base64.

Default: `null`

### <a name="input_os_disksize"></a> [os\_disksize](#input\_os\_disksize)

Description: (Optional) Size of OS disk. If left unset, defaults to OS image size.

Default: `null`

### <a name="input_os_storagetype"></a> [os\_storagetype](#input\_os\_storagetype)

Description: (Optional) Type of OS disk. If left unset, defaults 'Standard' disk type.

Default: `"Standard"`

## Outputs

The following outputs are exported:

### <a name="output_vm"></a> [vm](#output\_vm)

Description: VM object created by this module.

### <a name="output_vm_info"></a> [vm\_info](#output\_vm\_info)

Description: Object which contains additional information about VM.
