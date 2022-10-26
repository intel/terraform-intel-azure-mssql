### INTEL LICENSE STARTS BELOW
# INTEL CONFIDENTIAL
# Copyright (C) 2021-2022 Intel Corporation
# This software and the related documents are Intel copyrighted materials, and your use of them is governed by the express license under which they were provided to you ("License"). Unless the License provides otherwise, you may not use, modify, copy, publish, distribute, disclose or transmit this software or the related documents without Intel's prior written permission.
# This software and the related documents are provided as is, with no express or implied warranties, other than those that are expressly stated in the License.
### INTEL LICENSE END
output "cloud-environment" {
  description = "Cloud environment outputs"
  value       = module.cloud-env
}

output "db_ip" {
  description = "Database public IP address."
  value       = module.cloud-env.cloud_public_ips.vm-mysql-0-publicip
}

output "stresser_ip" {
  description = "Stresser public IP address."
  value       = var.dbOnly ? "" : module.cloud-env.cloud_public_ips.vm-hammerdb-0-publicip
}

output "db-only" {
  description = "Output db-only variable for output check"
  value       = var.dbOnly
}

output "vm_admin_password" {
  description = "Administrator password for VM"
  value       = local.admin_password
}

output "vm_admin_username" {
  description = "Administrator username for VM"
  value       = local.admin_username
}

output "vm_db" {
  description = "VMs to use for db dashboard"
  value       = module.vm-mysql[0]
}

output "vm_stresser" {
  description = "VMs to use for stresser dashboard creation"
  value       = var.dbOnly ? null : module.vm-hammerdb[0]
}

output "workload_variables" {
  description = "Workload-specific variables"
  value       = ""
}
