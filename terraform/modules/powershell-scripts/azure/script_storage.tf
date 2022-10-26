### INTEL LICENSE STARTS BELOW
# INTEL CONFIDENTIAL
# Copyright (C) 2021-2022 Intel Corporation
# This software and the related documents are Intel copyrighted materials, and your use of them is governed by the express license under which they were provided to you ("License"). Unless the License provides otherwise, you may not use, modify, copy, publish, distribute, disclose or transmit this software or the related documents without Intel's prior written permission.
# This software and the related documents are provided as is, with no express or implied warranties, other than those that are expressly stated in the License.
### INTEL LICENSE END
resource "random_id" "storage_account" {
  byte_length = "8"
}

resource "azurerm_storage_account" "script_storage_acc" {

  name                            = "${var.prefix}${substr(lower(random_id.storage_account.hex), 0, 8)}"
  resource_group_name             = var.cloud_env_params.resource_group_name
  location                        = var.cloud_env_params.resources_location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false

  queue_properties {
    logging {
      delete                = true
      read                  = true
      write                 = true
      version               = "1.0"
      retention_policy_days = 1
    }
    hour_metrics {
      enabled               = true
      include_apis          = true
      version               = "1.0"
      retention_policy_days = 1
    }
    minute_metrics {
      enabled               = true
      include_apis          = true
      version               = "1.0"
      retention_policy_days = 1
    }
  }

  tags = var.tags
}

resource "azurerm_storage_container" "script_storage_cont" {

  name                  = "content"
  storage_account_name  = azurerm_storage_account.script_storage_acc.name
  container_access_type = "private"
}
