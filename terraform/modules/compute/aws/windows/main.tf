### INTEL LICENSE STARTS BELOW
# INTEL CONFIDENTIAL
# Copyright (C) 2021-2022 Intel Corporation
# This software and the related documents are Intel copyrighted materials, and your use of them is governed by the express license under which they were provided to you ("License"). Unless the License provides otherwise, you may not use, modify, copy, publish, distribute, disclose or transmit this software or the related documents without Intel's prior written permission.
# This software and the related documents are provided as is, with no express or implied warranties, other than those that are expressly stated in the License.
### INTEL LICENSE END

/**
 * Module which creates Windows VMs.
 */

locals {
  os_disk_config = {
    # do we want throughput & iops configuration here?

    tags = merge(var.tags, {
      Name = "${var.name}-osdisk"
    })
    volume_type = var.os_storagetype
    volume_size = var.os_disksize
  }

  # Logic to provide admin_username and admin_password functionality
  powershell_template_path = "${path.module}/${var.windows-powershell-template_file}"

  user_config_path = "${path.module}/${var.windows-user-config_file}"
  user_config_params = {
    admin_username = var.admin_username,
    secret_arn     = aws_secretsmanager_secret.vm_windows_password.arn
  }

  # prepares a list of scripts to unroll
  user_data_scripts = concat(var.user_data, [templatefile(local.user_config_path, local.user_config_params)])
  # unrolls scripts
  user_data_merged = templatefile(local.powershell_template_path, { scripts = local.user_data_scripts })
}

resource "aws_instance" "vm" {

  tags = merge(var.tags, {
    Name = var.name
  })

  ebs_optimized = true # will show as disabled on auto-optimized

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  network_interface {
    network_interface_id = lookup(var.module_cloud_env.cloud_network_interfaces, var.nic_name)
    device_index         = 0
  }

  instance_type = var.instancetype

  root_block_device {
    delete_on_termination = true # is default, but explicitly turn this on
    encrypted             = true
    kms_key_id            = var.module_cloud_env.kms_key_arn
    tags                  = local.os_disk_config.tags
    volume_type           = local.os_disk_config.volume_type
    volume_size           = local.os_disk_config.volume_size
  }

  ami = data.aws_ami.os.id

  key_name  = var.module_cloud_env.key_name
  user_data = local.user_data_merged

  iam_instance_profile = aws_iam_instance_profile.secretsmanager_profile.name

  get_password_data = true
}

resource "aws_secretsmanager_secret" "vm_windows_password" {
  name = "${var.name}-password"
  tags = merge(var.tags, {
    Name = "${var.name}-password"
  })
  kms_key_id              = var.module_cloud_env.kms_key_arn
  recovery_window_in_days = 30 # equvalent to 720h expiration time
}

resource "aws_secretsmanager_secret_version" "vm_windows_password" {
  secret_id     = aws_secretsmanager_secret.vm_windows_password.id
  secret_string = base64encode(var.admin_password)
}

resource "aws_iam_role" "password_access" {
  name = "${var.name}-password-access"

  assume_role_policy = templatefile("${path.module}/../templates/assume-role.tmpl", {})

  inline_policy {
    name = "${var.name}-password-access"

    policy = templatefile("${path.module}/../templates/sm-policy.tmpl", {
      secret_arn = aws_secretsmanager_secret.vm_windows_password.arn,
      kms_arn    = var.module_cloud_env.kms_key_arn
    })
  }

  tags = merge(var.tags, {
    Name = var.name
  })
}

resource "aws_iam_instance_profile" "secretsmanager_profile" {
  name = "${var.name}-password-access"
  role = aws_iam_role.password_access.name

  tags = merge(var.tags, {
    Name = var.name
  })
}
