### INTEL LICENSE STARTS BELOW
# INTEL CONFIDENTIAL
# Copyright (C) 2021-2022 Intel Corporation
# This software and the related documents are Intel copyrighted materials, and your use of them is governed by the express license under which they were provided to you ("License"). Unless the License provides otherwise, you may not use, modify, copy, publish, distribute, disclose or transmit this software or the related documents without Intel's prior written permission.
# This software and the related documents are provided as is, with no express or implied warranties, other than those that are expressly stated in the License.
### INTEL LICENSE END
locals {
  source_images_list = { # keeps AWS image names
    "WindowsServer2019" = "Windows_Server-2019-English-Full-Base-2022.03.09"
    "SQLServer2019"     = "Windows_Server-2019-English-Full-SQL_2019_Enterprise-2022.03.09"
  }
}

data "aws_ami" "os" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = [local.source_images_list[var.os_name]]
  }
}
