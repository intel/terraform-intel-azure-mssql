### INTEL LICENSE STARTS BELOW
# INTEL CONFIDENTIAL
# Copyright (C) 2021-2022 Intel Corporation
# This software and the related documents are Intel copyrighted materials, and your use of them is governed by the express license under which they were provided to you ("License"). Unless the License provides otherwise, you may not use, modify, copy, publish, distribute, disclose or transmit this software or the related documents without Intel's prior written permission.
# This software and the related documents are provided as is, with no express or implied warranties, other than those that are expressly stated in the License.
### INTEL LICENSE END
locals {
  admin_username         = "testadmin" # testadmin is currently hardcoded in some ansible places
  admin_password         = random_password.mssql_password.result
  database_password      = var.database_password == null ? "${random_password.mssql_password.result}" : var.database_password
  database_startup_flags = join(",", var.database_startup_flags)

  vms_list = var.dbOnly ? [
    "vm-mssql-0",
    ] : [
    "vm-mssql-0",
    "vm-hammerdb-0"
  ]

  # this is new on AWS
  deployment_id = module.cloud-env.random_id
  prefix        = "${var.resourcegroup}-${local.deployment_id}"

  tags = merge(var.global_tags, {
    OcsDeployment = local.deployment_id
  })
}

# this one is not necessary here
#resource "random_id" "storage_account" {
#  byte_length = "8"
#}

resource "random_password" "mssql_password" {
  length           = 12
  min_lower        = 1
  min_upper        = 1
  min_numeric      = 1
  min_special      = 1
  override_special = "_:"
}
## Windows

# Generated MS SQL password
resource "local_file" "mssql_password_local_file" {
  sensitive_content = local.database_password
  filename          = "../../../packages/mssql-password"
  file_permission   = "0600"
}
