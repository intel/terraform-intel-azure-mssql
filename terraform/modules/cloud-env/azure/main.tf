### INTEL LICENSE STARTS BELOW
# INTEL CONFIDENTIAL
# Copyright (C) 2021-2022 Intel Corporation
# This software and the related documents are Intel copyrighted materials, and your use of them is governed by the express license under which they were provided to you ("License"). Unless the License provides otherwise, you may not use, modify, copy, publish, distribute, disclose or transmit this software or the related documents without Intel's prior written permission.
# This software and the related documents are provided as is, with no express or implied warranties, other than those that are expressly stated in the License.
### INTEL LICENSE END
data "azurerm_client_config" "current" {}

locals {

  tags = var.global_tags

  # NETWORK SECURITY GROUP RULES
  ssh_rule = {
    name                    = "Allow_SSH_Access"
    priority                = 100
    destination_port_range  = 22
    source_address_prefixes = toset(var.ssh_allowed_ips)
  }

  rdp_rule = {
    name                    = "Allow_RDP_Access"
    priority                = 101
    destination_port_range  = 3389
    source_address_prefixes = toset(var.rdp_allowed_ips)
  }

  all_rules = var.expose_rdp ? [local.rdp_rule, local.ssh_rule] : [local.ssh_rule]

  nsg_rules = toset(local.all_rules)
  # NETWORK SECURITY GROUP RULES END
}

resource "azurerm_resource_group" "cenv" {
  name     = var.resourcegroup
  location = var.location

  tags = local.tags
}

resource "azurerm_virtual_network" "cenv" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.cenv.location
  resource_group_name = azurerm_resource_group.cenv.name

  tags = local.tags
}

resource "azurerm_subnet" "cenv" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.cenv.name
  virtual_network_name = azurerm_virtual_network.cenv.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "cenv" {
  for_each            = var.vms
  name                = "${each.value}-publicip"
  resource_group_name = azurerm_resource_group.cenv.name
  location            = azurerm_resource_group.cenv.location
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = null
  tags                = local.tags
}

resource "time_sleep" "wait_190_seconds" {
  depends_on       = [azurerm_network_interface.cenv]
  destroy_duration = "190s"
}

resource "azurerm_network_interface" "cenv" {
  for_each            = var.vms
  name                = "${each.value}-nic"
  location            = azurerm_resource_group.cenv.location
  resource_group_name = azurerm_resource_group.cenv.name

  ip_configuration {
    name                          = "configuration"
    subnet_id                     = azurerm_subnet.cenv.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.cenv["${each.value}"].id
    primary                       = true
  }

  tags = local.tags
}

resource "azurerm_network_security_group" "cenv-nsg" {
  name                = "${var.prefix}-nsg"
  resource_group_name = azurerm_resource_group.cenv.name
  location            = azurerm_resource_group.cenv.location

  dynamic "security_rule" {
    for_each = local.nsg_rules
    iterator = rule

    content {
      name                    = rule.value.name
      priority                = rule.value.priority
      destination_port_range  = rule.value.destination_port_range
      source_address_prefixes = rule.value.source_address_prefixes

      direction                  = "Inbound"
      source_port_range          = "*"
      destination_address_prefix = "*"
      access                     = "Allow"
      protocol                   = "Tcp"
    }
  }

  tags = local.tags
}

resource "azurerm_subnet_network_security_group_association" "cenv-nsg-assoc" {
  subnet_id                 = azurerm_subnet.cenv.id
  network_security_group_id = azurerm_network_security_group.cenv-nsg.id
  depends_on                = [azurerm_network_interface.cenv]
}

resource "random_id" "key_name_suffix" {
  count       = var.make_ssh_keys ? 1 : 0
  byte_length = "8"
}

resource "azurerm_key_vault" "key_store" {
  count = var.make_key_vault ? 1 : 0

  name                = "${var.prefix}-kv-${lower(random_id.key_name_suffix[0].hex)}"
  location            = azurerm_resource_group.cenv.location
  resource_group_name = azurerm_resource_group.cenv.name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  sku_name = "standard"
  network_acls {
    bypass         = "AzureServices"
    default_action = "Deny"
    ip_rules       = var.ssh_allowed_ips
  }

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Create",
      "Get",
      "Purge",
      "Delete"
    ]

    secret_permissions = [
      "Set",
      "Get",
      "Delete",
      "Purge"
    ]
  }

  tags = local.tags
}

resource "tls_private_key" "vm_access_key" {
  count = var.make_ssh_keys ? 1 : 0

  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_key_vault_secret" "vm_access_key_store_private" {
  count = var.make_key_vault ? 1 : 0

  name            = "ssh-key-azure-vm"
  key_vault_id    = azurerm_key_vault.key_store[0].id
  expiration_date = timeadd(timestamp(), "720h")
  content_type    = "ssh-key-private"
  value           = tls_private_key.vm_access_key[0].private_key_pem
}

resource "azurerm_key_vault_secret" "vm_access_key_store_public" {
  count = var.make_key_vault ? 1 : 0

  name            = "ssh-key-azure-vm-pub"
  key_vault_id    = azurerm_key_vault.key_store[0].id
  content_type    = "ssh-key-public"
  expiration_date = timeadd(timestamp(), "720h")
  value           = tls_private_key.vm_access_key[0].public_key_openssh
}

resource "local_sensitive_file" "vm_access_private_key" {
  count = var.make_ssh_keys ? 1 : 0

  # creating this so we don't need to download it on local machine
  content         = tls_private_key.vm_access_key[0].private_key_pem
  filename        = "${path.cwd}/infra_keys/ssh-key-${lower(random_id.key_name_suffix[0].hex)}"
  file_permission = "0600"
}
