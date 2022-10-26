### INTEL LICENSE STARTS BELOW
# INTEL CONFIDENTIAL
# Copyright (C) 2021-2022 Intel Corporation
# This software and the related documents are Intel copyrighted materials, and your use of them is governed by the express license under which they were provided to you ("License"). Unless the License provides otherwise, you may not use, modify, copy, publish, distribute, disclose or transmit this software or the related documents without Intel's prior written permission.
# This software and the related documents are provided as is, with no express or implied warranties, other than those that are expressly stated in the License.
### INTEL LICENSE END
locals {
  admin_username = "adminuser"
  admin_password = random_password.vm_admin_password.result

  server_storagetype = format("%s_LRS", var.server_storagetype)
  vms_list = var.dbOnly ? [
    "vm-mysql-0",
    ] : [
    "vm-mysql-0",
    "vm-hammerdb-0"
  ]

  tags = var.global_tags
}

resource "random_id" "storage_account" {
  byte_length = "8"
}

resource "random_password" "vm_admin_password" {
  length = "12"
}
