## Inputs

The following input variables are supported:

### <a name="input_cloud_env_params"></a> [cloud\_env\_params](#input\_cloud\_env\_params)

Description: Plugin for cloud-env outputs.

Default: n/a

### <a name="input_script_definitions"></a> [script\_definitions](#input\_script\_definitions)

Description: Dictionary of scripts to run on a specific VM. Each object is made of "command\_to\_execute" field, "filepath" from where the script can be templated, "template\_parameters" which are passed to templatefile function and "vm" on which the script will be applied. "template\_parameters" is optional if there is nothing to template in a script file and should be set to "null" then.

Default: n/a

### <a name="input_prefix"></a> [prefix](#input\_prefix)

Description: Prefix used for all resources in this module.

Default: `"psscripts"`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: Tags to apply to resources. Can be null.

Default: `null`

## Outputs

No outputs.
