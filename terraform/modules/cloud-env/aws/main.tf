### INTEL LICENSE STARTS BELOW
# INTEL CONFIDENTIAL
# Copyright (C) 2021-2022 Intel Corporation
# This software and the related documents are Intel copyrighted materials, and your use of them is governed by the express license under which they were provided to you ("License"). Unless the License provides otherwise, you may not use, modify, copy, publish, distribute, disclose or transmit this software or the related documents without Intel's prior written permission.
# This software and the related documents are provided as is, with no express or implied warranties, other than those that are expressly stated in the License.
### INTEL LICENSE END

locals {

  resource_prefix = "${var.prefix}-cenv"

  tags = var.global_tags

  # NETWORK SECURITY GROUP RULES
  ssh_rule = {
    description = "Allow SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = toset(var.ssh_allowed_ips)
  }

  rdp_rule = {
    description = "Allow RDP Access"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = toset(var.rdp_allowed_ips)
  }

  all_rules = var.expose_rdp ? [local.rdp_rule, local.ssh_rule] : [local.ssh_rule]

  nsg_rules = toset(local.all_rules)
  # NETWORK SECURITY GROUP RULES END
}

resource "aws_vpc" "cenv" {
  tags = merge(local.tags, {
    Name = "${local.resource_prefix}-network"
  })
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "cenv" {
  tags = merge(local.tags, {
    Name = "${local.resource_prefix}-public"
  })
  vpc_id     = aws_vpc.cenv.id
  cidr_block = "10.0.2.0/24"
}

resource "aws_network_interface" "cenv" {
  for_each    = var.vms
  description = "${each.value} VM network interface"

  subnet_id = aws_subnet.cenv.id
  tags = merge(local.tags, {
    Name         = "${local.resource_prefix}-${each.value}-nic"
    InternalName = "${each.value}-nic"
  })
}

resource "aws_eip" "cenv" {
  for_each          = zipmap(var.vms, [for interface in aws_network_interface.cenv : interface])
  network_interface = each.value.id
  vpc               = true
  tags = merge(local.tags, {
    Name         = "${local.resource_prefix}-${each.key}-ip"
    InternalName = "${each.key}-publicip"
  })
  depends_on = [aws_internet_gateway.cenv]
}

resource "aws_security_group" "cenv" {
  name        = "${local.resource_prefix}-sg"
  description = "Allow Intel OCS runtime host access"
  vpc_id      = aws_vpc.cenv.id

  dynamic "ingress" {
    for_each = local.nsg_rules
    iterator = rule

    content {
      description = rule.value.description
      from_port   = rule.value.from_port
      to_port     = rule.value.to_port
      protocol    = rule.value.protocol
      cidr_blocks = rule.value.cidr_blocks
      self        = true
    }
  }

  tags = local.tags
}

resource "aws_network_interface_sg_attachment" "cenv" {
  for_each             = zipmap(var.vms, [for interface in aws_network_interface.cenv : interface])
  security_group_id    = aws_security_group.cenv.id
  network_interface_id = each.value.id
}

resource "aws_internet_gateway" "cenv" {
  tags = merge(local.tags, {
    Name = "${local.resource_prefix}-gateway"
  })
  vpc_id = aws_vpc.cenv.id
}

resource "aws_default_route_table" "public" {
  default_route_table_id = aws_vpc.cenv.main_route_table_id

  tags = merge(local.tags, {
    Name = "${local.resource_prefix}-public-route"
  })
}

resource "aws_route" "public_gw_route" {
  route_table_id         = aws_default_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.cenv.id
}

resource "aws_route_table_association" "public_gw_route_assoc" {
  subnet_id      = aws_subnet.cenv.id
  route_table_id = aws_default_route_table.public.id
}

resource "random_id" "key_name_suffix" {
  count       = var.make_ssh_keys ? 1 : 0
  byte_length = "8"
}

resource "tls_private_key" "vm_access_key" {
  count = var.make_ssh_keys ? 1 : 0

  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "vm_access_private_key" {
  count = var.make_ssh_keys ? 1 : 0

  # creating this so we don't need to download it on local machine
  sensitive_content = tls_private_key.vm_access_key[0].private_key_pem
  filename          = "${path.cwd}/infra_keys/ssh-key-${lower(random_id.key_name_suffix[0].hex)}"
  file_permission   = "0600"
}

resource "aws_key_pair" "creds" {
  tags = merge(local.tags, {
    Name = "${local.resource_prefix}-pubkey"
  })
  key_name   = "${local.resource_prefix}-pubkey"
  public_key = tls_private_key.vm_access_key[0].public_key_openssh
}

resource "aws_kms_key" "iocs_key" {
  description = "One-time key used for IOCS deployment id ${random_id.key_name_suffix[0].hex}"
  tags = merge(local.tags, {
    Name = "kms-key-${lower(random_id.key_name_suffix[0].hex)}"
  })
  deletion_window_in_days = 30 # equivalent to 720h expiration time
  # key rotation might be unnecessary, but it is safer to explicitly enable
  enable_key_rotation = true
}

resource "aws_secretsmanager_secret" "vm_access_key_store_private" {
  count = var.make_key_vault ? 1 : 0
  name  = "ssh-key-${lower(random_id.key_name_suffix[0].hex)}"
  tags = merge(local.tags, {
    Name = "ssh-key-${lower(random_id.key_name_suffix[0].hex)}"
  })
  kms_key_id              = aws_kms_key.iocs_key.id
  recovery_window_in_days = 30 # equvalent to 720h expiration time
}

resource "aws_secretsmanager_secret" "vm_access_key_store_public" {
  count = var.make_key_vault ? 1 : 0
  name  = "ssh-key-${lower(random_id.key_name_suffix[0].hex)}-pub"
  tags = merge(local.tags, {
    Name = "ssh-key-${lower(random_id.key_name_suffix[0].hex)}-pub"
  })
  kms_key_id              = aws_kms_key.iocs_key.id
  recovery_window_in_days = 30
}

resource "aws_secretsmanager_secret_version" "vm_access_key_store_private" {
  count         = var.make_key_vault ? 1 : 0
  secret_id     = aws_secretsmanager_secret.vm_access_key_store_private[0].id
  secret_string = base64encode(tls_private_key.vm_access_key[0].private_key_pem)
}

resource "aws_secretsmanager_secret_version" "vm_access_key_store_public" {
  count         = var.make_key_vault ? 1 : 0
  secret_id     = aws_secretsmanager_secret.vm_access_key_store_public[0].id
  secret_string = base64encode(tls_private_key.vm_access_key[0].public_key_pem)
}
