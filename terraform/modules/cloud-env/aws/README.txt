

input.vms (required)
The list with vms names.

input.expose_rdp (false)
Should RDP firewall rule be created?

input.global_tags ({})
Tags that will be applied to the infrastructure. Not all of the resources support adding tags and these will not be tagged.

input.make_key_vault (true)
Create a key vault and upload SSH keys (public and private) into it.

input.make_ssh_keys (true)
Create a keypair.

input.prefix ("iocs")
Prefix used for all resources in this module. Will be merged with random id from Terraform.

input.rdp_allowed_ips (null)
Comma-separated IPs (in CIDR format) which are allowed through the RDP firewall rules.

input.ssh_allowed_ips ([
  "127.0.0.0/8"
])
Comma-separated IPs (in CIDR format) which are allowed through the SSH firewall rules.


output.cloud_network_interfaces
Object with network interfaces information

output.cloud_public_ips
Public IP addresses of VMs

output.key_name
Keypair name for EC2 instances to use

output.kms_key_arn
AWS KMS key ARN for disks encryption

output.random_id
n/a

output.vm_access_key_store_public
VM public key in OpenSSH format.
