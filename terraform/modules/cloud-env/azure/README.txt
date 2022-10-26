

input.vms (required)
The list with vms names.

input.expose_rdp (false)
Should RDP firewall rule be created?

input.global_tags ({})
Tags that will be applied to the infrastructure. Not all of the resources support adding tags and these will not be tagged.

input.location ("West US")
The Azure Region in which the resources in this example should exist.

input.make_key_vault (true)
Create a key vault and upload SSH keys (public and private) into it.

input.make_ssh_keys (true)
Create a keypair.

input.prefix ("cenv")
Prefix used for all resources in this module.

input.rdp_allowed_ips (null)
Comma-separated IPs (in CIDR format) which are allowed through the RDP firewall rules.

input.resourcegroup ("GoldenImageResourceGroup")
The Azure resource group in which the resources should be created.

input.ssh_allowed_ips ([
  "127.0.0.1/8"
])
Comma-separated IPs (in CIDR format) which are allowed through the SSH firewall rules.


output.azure_keyvault_name
Azure Key Vault Name to download private key from when sharing machines

output.cloud_network_interfaces
Object with network interfaces information

output.cloud_public_ips
Public IP addresses of VMs

output.random_id
n/a

output.resource_group_name
The name of the resource group created

output.resources_location
The name of Azure region

output.vm_access_key_private_name
Name of the VM private key in the key vault.

output.vm_access_key_public_name
Name of the VM public key in the key vault.

output.vm_access_key_store_public
VM public key in OpenSSH format.
