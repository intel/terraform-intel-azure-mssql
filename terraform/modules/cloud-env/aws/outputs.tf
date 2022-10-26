### INTEL LICENSE STARTS BELOW
# INTEL CONFIDENTIAL
# Copyright (C) 2021-2022 Intel Corporation
# This software and the related documents are Intel copyrighted materials, and your use of them is governed by the express license under which they were provided to you ("License"). Unless the License provides otherwise, you may not use, modify, copy, publish, distribute, disclose or transmit this software or the related documents without Intel's prior written permission.
# This software and the related documents are provided as is, with no express or implied warranties, other than those that are expressly stated in the License.
### INTEL LICENSE END
output "cloud_network_interfaces" {
  description = "Object with network interfaces information"
  value = {
    for interface in aws_network_interface.cenv :
    interface.tags.InternalName => interface.id
  }
}

output "cloud_public_ips" {
  description = "Public IP addresses of VMs"
  value = {
    for public_ip in aws_eip.cenv :
    public_ip.tags.InternalName => public_ip.public_ip
  }
}

output "random_id" {
  value = var.make_ssh_keys ? lower(random_id.key_name_suffix[0].hex) : ""
}

output "key_name" {
  description = "Keypair name for EC2 instances to use"
  value       = aws_key_pair.creds.key_name
}

output "kms_key_arn" {
  description = "AWS KMS key ARN for disks encryption"
  value       = aws_kms_key.iocs_key.arn
}

#output "vm_access_key_public_name" {
#  description = "Name of the VM public key in the key vault."
#  value       = var.make_key_vault ? azurerm_key_vault_secret.vm_access_key_store_public[0].name : ""
#}
#
#
#output "vm_access_key_private_name" {
#  description = "Name of the VM private key in the key vault."
#  value       = var.make_key_vault ? azurerm_key_vault_secret.vm_access_key_store_private[0].name : ""
#}

output "vm_access_key_store_public" {
  description = "VM public key in OpenSSH format."
  value       = var.make_ssh_keys ? tls_private_key.vm_access_key[0].public_key_openssh : ""
}
