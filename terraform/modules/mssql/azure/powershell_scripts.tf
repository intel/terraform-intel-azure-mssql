### INTEL LICENSE STARTS BELOW
# INTEL CONFIDENTIAL
# Copyright (C) 2021-2022 Intel Corporation
# This software and the related documents are Intel copyrighted materials, and your use of them is governed by the express license under which they were provided to you ("License"). Unless the License provides otherwise, you may not use, modify, copy, publish, distribute, disclose or transmit this software or the related documents without Intel's prior written permission.
# This software and the related documents are provided as is, with no express or implied warranties, other than those that are expressly stated in the License.
### INTEL LICENSE END
locals {

  shell_prefix    = "powershell -ExecutionPolicy Unrestricted"
  common_filename = basename(var.windows-config_file)

  sql_scripts_list = {
    "configure_mssql_vm" = {
      command_to_execute  = "${local.shell_prefix} -File ${module.vm-mssql[0].vm.name}-${local.common_filename}"
      filepath            = "${path.module}/${var.windows-config_file}"
      template_parameters = { key = "${module.cloud-env.vm_access_key_store_public}" }
      vm                  = module.vm-mssql[0].vm
    }
  }

  hammerdb_scripts_list = var.dbOnly ? {} : {
    "configure_hammerdb_vm" = {
      command_to_execute = "${local.shell_prefix} -File ${module.vm-hammerdb[0].vm.name}-${local.common_filename}"

      filepath            = "${path.module}/${var.windows-config_file}"
      template_parameters = { key = "${module.cloud-env.vm_access_key_store_public}" }
      vm                  = module.vm-hammerdb[0].vm
    }
  }

  scripts_list = merge(local.sql_scripts_list, local.hammerdb_scripts_list)
}

module "powershell-scripts" {

  # all dependencies must be set inline here - run all the scripts after the rest of provisioning is done

  depends_on = [module.vm-hammerdb, azurerm_mssql_virtual_machine.sqlextended-vm]
  source     = "../../powershell-scripts/azure"

  cloud_env_params   = module.cloud-env
  script_definitions = local.scripts_list

  tags = local.tags
}
