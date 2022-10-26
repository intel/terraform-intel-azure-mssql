### INTEL LICENSE STARTS BELOW
# INTEL CONFIDENTIAL
# Copyright (C) 2021-2022 Intel Corporation
# This software and the related documents are Intel copyrighted materials, and your use of them is governed by the express license under which they were provided to you ("License"). Unless the License provides otherwise, you may not use, modify, copy, publish, distribute, disclose or transmit this software or the related documents without Intel's prior written permission.
# This software and the related documents are provided as is, with no express or implied warranties, other than those that are expressly stated in the License.
### INTEL LICENSE END
locals {
#  db_ip                = module.benchmark.db_ip
#  stresser_ip          = module.benchmark.stresser_ip
#  random_id            = module.benchmark.cloud-environment.random_id
  infra_keys_path      = "${path.cwd}/infra_keys"
#  vm_admin_username    = module.benchmark.vm_admin_username
#  vm_db                = module.benchmark.vm_db
#  vm_stresser          = module.benchmark.vm_stresser
  private_key_filename = "${local.infra_keys_path}/ssh-key-${lower(local.random_id)}"
#  workload_variables   = module.benchmark.workload_variables
}

#output "x_99_benchmark" {
#  sensitive   = true # comment out to get RAW outputs
#  description = "Benchmark module outputs"
#  value       = module.benchmark
#}

#output "x_98_workload_variables" {
#  sensitive   = true # comment out to get RAW outputs
#  description = "Workload-specific variables"
#  value       = local.workload_variables
#}

#output "x_0_stresser_ip" {
#  description = "Stresser public IP for access"
#  value       = local.stresser_ip
#}

#output "x_0_db_ip" {
#  description = "Database public IP for access"
#  value       = local.db_ip
#}

#output "x_0_private_key_filename" {
#  description = "Path to private key file."
#  value       = local.private_key_filename
#}

#output "x_3_vm_admin_password" {
#  sensitive   = false
#  description = "Administrator password for VM"
#  value       = nonsensitive(module.benchmark.vm_admin_password)
#}

#output "x_3_vm_admin_username" {
#  description = "Administrator username for VM"
#  value       = local.vm_admin_username
#}

# Ansible inventory file
resource "local_file" "inventory" {
  content = templatefile("${path.module}/../../modules/inventory/inv.ini",
    {
#      hammerdb_ip_address  = local.stresser_ip,
#      database_ip_address  = local.db_ip,
#      random_id            = local.random_id
#      private_key_filename = local.private_key_filename
#      admin_username       = local.vm_admin_username
#      vm_db                = local.vm_db
#      vm_stresser          = local.vm_stresser
#      workload_variables   = local.workload_variables
      scenario             = var.scenario
      custom_profile       = var.custom_profile
    }
  )
  filename        = "../../../packages/inv.ini"
  file_permission = "0644"
}
