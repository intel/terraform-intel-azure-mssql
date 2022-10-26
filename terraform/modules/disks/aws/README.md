## Inputs

The following input variables are supported:

### <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone)

Description: Availability zone to use. Should be set to VMs AZ.

Default: n/a

### <a name="input_device_path"></a> [device\_path](#input\_device\_path)

Description: Device name to mount at. Refer to AWS "Device names on Windows instances" and "Device names on Linux instances" guides to understand allowed device names.

Default: n/a

### <a name="input_module_cloud_env"></a> [module\_cloud\_env](#input\_module\_cloud\_env)

Description: Takes Cloud-env object.

Default: n/a

### <a name="input_size"></a> [size](#input\_size)

Description: Size of created disk.

Default: n/a

### <a name="input_storagetype"></a> [storagetype](#input\_storagetype)

Description: Type of storage to use.

Default: n/a

### <a name="input_tags"></a> [tags](#input\_tags)

Description: Tags which to attach to disk.

Default: n/a

### <a name="input_vm_id"></a> [vm\_id](#input\_vm\_id)

Description: ID of VM object to which disks should be attached.

Default: n/a

### <a name="input_vm_name"></a> [vm\_name](#input\_vm\_name)

Description: Name of VM object to which disks should be attached.

Default: n/a

### <a name="input_iops"></a> [iops](#input\_iops)

Description: IOPS parameter of created disk (only supported on some disk types). If omitted, uses default.

Default: `null`

### <a name="input_throughput"></a> [throughput](#input\_throughput)

Description: Throughput parameter of created disk (only supported on some disk types). If omitted, uses default.

Default: `null`

## Outputs

No outputs.
