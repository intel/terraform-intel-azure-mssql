## Inputs

The following input variables are supported:

### <a name="input_vms"></a> [vms](#input\_vms)

Description: The list with vms names.

Default: n/a

### <a name="input_expose_rdp"></a> [expose\_rdp](#input\_expose\_rdp)

Description: Should RDP firewall rule be created?

Default: `false`

### <a name="input_global_tags"></a> [global\_tags](#input\_global\_tags)

Description: Tags that will be applied to the infrastructure. Not all of the resources support adding tags and these will not be tagged.

Default: `{}`

### <a name="input_make_key_vault"></a> [make\_key\_vault](#input\_make\_key\_vault)

Description: Create a key vault and upload SSH keys (public and private) into it.

Default: `true`

### <a name="input_make_ssh_keys"></a> [make\_ssh\_keys](#input\_make\_ssh\_keys)

Description: Create a keypair.

Default: `true`

### <a name="input_prefix"></a> [prefix](#input\_prefix)

Description: Prefix used for all resources in this module. Will be merged with random id from Terraform.

Default: `"iocs"`

### <a name="input_rdp_allowed_ips"></a> [rdp\_allowed\_ips](#input\_rdp\_allowed\_ips)

Description: Comma-separated IPs (in CIDR format) which are allowed through the RDP firewall rules.

Default: `null`

### <a name="input_ssh_allowed_ips"></a> [ssh\_allowed\_ips](#input\_ssh\_allowed\_ips)

Description: Comma-separated IPs (in CIDR format) which are allowed through the SSH firewall rules.

Default:

```json
[
  "127.0.0.0/8"
]
```

## Outputs

The following outputs are exported:

### <a name="output_cloud_network_interfaces"></a> [cloud\_network\_interfaces](#output\_cloud\_network\_interfaces)

Description: Object with network interfaces information

### <a name="output_cloud_public_ips"></a> [cloud\_public\_ips](#output\_cloud\_public\_ips)

Description: Public IP addresses of VMs

### <a name="output_key_name"></a> [key\_name](#output\_key\_name)

Description: Keypair name for EC2 instances to use

### <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn)

Description: AWS KMS key ARN for disks encryption

### <a name="output_random_id"></a> [random\_id](#output\_random\_id)

Description: n/a

### <a name="output_vm_access_key_store_public"></a> [vm\_access\_key\_store\_public](#output\_vm\_access\_key\_store\_public)

Description: VM public key in OpenSSH format.
