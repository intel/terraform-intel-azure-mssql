### INTEL LICENSE STARTS BELOW
# INTEL CONFIDENTIAL
# Copyright (C) 2021-2022 Intel Corporation
# This software and the related documents are Intel copyrighted materials, and your use of them is governed by the express license under which they were provided to you ("License"). Unless the License provides otherwise, you may not use, modify, copy, publish, distribute, disclose or transmit this software or the related documents without Intel's prior written permission.
# This software and the related documents are provided as is, with no express or implied warranties, other than those that are expressly stated in the License.
### INTEL LICENSE END
locals {
  vm_db_enc_password       = module.benchmark.vm_db.vm_info.vm_windows_aws_random_password_enc
  vm_stresser_enc_password = var.dbOnly ? "" : module.benchmark.vm_stresser.vm_info.vm_windows_aws_random_password_enc
}

output "x_2_private_key_secret" {
  description = "Name of the private key in Secret Manager - used for sharing access to VMs"
  value       = var.make_key_vault ? "ssh-key-${local.random_id}" : null
}

output "x_3_vm_windows_aws_random_passwords" {
  description = "Random Windows passwords generated from AWS"
  value = {
    "db"       = rsadecrypt(local.vm_db_enc_password, file(local.private_key_filename)),
    "stresser" = var.dbOnly ? null : rsadecrypt(local.vm_stresser_enc_password, file(local.private_key_filename))
  }
}
