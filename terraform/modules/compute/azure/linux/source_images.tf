### INTEL LICENSE STARTS BELOW
# INTEL CONFIDENTIAL
# Copyright (C) 2021-2022 Intel Corporation
# This software and the related documents are Intel copyrighted materials, and your use of them is governed by the express license under which they were provided to you ("License"). Unless the License provides otherwise, you may not use, modify, copy, publish, distribute, disclose or transmit this software or the related documents without Intel's prior written permission.
# This software and the related documents are provided as is, with no express or implied warranties, other than those that are expressly stated in the License.
### INTEL LICENSE END
locals {
  source_images_list = {
    "CentOS8.1" = {
      publisher = "OpenLogic",
      offer     = "CentOS",
      sku       = "8_1-gen2",
      version   = "8.1.2020111901"
    },
    "Ubuntu20.04" = {
      publisher = "Canonical",
      offer     = "0001-com-ubuntu-server-focal",
      sku       = "20_04-lts-gen2",
      version   = "20.04.202112020"
    },
    "RHEL8.1" = {
      publisher = "RedHat",
      offer     = "rhel-raw",
      sku       = "81-gen2",
      version   = "8.1.2021091202"
    },
    "OracleDB19" = {
      publisher = "oracle",
      offer     = "oracle-database-19-3",
      sku       = "oracle-database-19-0904",
      version   = "latest"
    },
  }
}
