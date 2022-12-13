data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

resource "azurerm_mssql_server" "mssql_server" {
  name                          = var.db_server_name
  resource_group_name           = data.azurerm_resource_group.rg.name
  location                      = data.azurerm_resource_group.rg.location
  version                       = var.db_server_version
  administrator_login           = var.db_username
  administrator_login_password  = var.db_password
  minimum_tls_version           = var.db_min_tls_version
  public_network_access_enabled = var.db_public_network_access_enabled
  connection_policy             = var.db_connection_policy
  tags = merge(
    var.tags,
    {
      "Intel Cloud Optimization Module" = "Azure MSSQL"
    }
  )

  dynamic "azuread_administrator" {
    for_each = length(var.azuread_input_variables) == 0 ? toset([]) : var.azuread_input_variables
    content {
      login_username              = azuread_administrator.value["azuread_login_username"]
      object_id                   = azuread_administrator.value["azuread_object_id"]
      azuread_authentication_only = azuread_administrator.value["azuread_authentication_only"]
    }

  }

}

resource "azurerm_mssql_database" "mssql_db" {
  name                                = var.db_name
  server_id                           = azurerm_mssql_server.mssql_server.id
  sku_name                            = var.db_server_sku
  create_mode                         = var.db_create_mode
  collation                           = var.db_collation
  geo_backup_enabled                  = var.db_geo_backup_enabled
  license_type                        = var.db_license_type
  max_size_gb                         = var.db_max_size_gb
  creation_source_database_id         = var.db_create_source_id
  restore_point_in_time               = var.db_create_mode == "PointInTimeRestore" ? var.db_restore_time : null
  storage_account_type                = var.db_storage_account_type
  transparent_data_encryption_enabled = var.db_transparent_data_encryption_enabled
  tags = merge(
    var.tags,
    {
      "Intel Cloud Optimization Module" = "Azure MSSQL"
    }
  )
  short_term_retention_policy {
    retention_days = var.db_backup_retention_period
  }

  timeouts {
    create = var.db_timeouts.create
    delete = var.db_timeouts.delete
    update = var.db_timeouts.update
  }
}

resource "azurerm_mssql_firewall_rule" "mssql_firewall_rule" {
  count     = length(var.firewall_ip_range) == 0 ? 0 : length(var.firewall_ip_range)
  name      = "mssql_firewall_rule_${count.index}"
  server_id = azurerm_mssql_server.mssql_server.id

  start_ip_address = var.firewall_ip_range[count.index]["start_ip_address"]
  end_ip_address   = var.firewall_ip_range[count.index]["end_ip_address"]

}

data "azurerm_subnet" "subnet" {
  count                = var.subnet_name == null ? 0 : 1
  name                 = var.subnet_name
  virtual_network_name = var.subnet_virtual_network_name
  resource_group_name  = var.subnet_resource_group_name
}

resource "azurerm_mssql_virtual_network_rule" "mssql_vnet_rule" {
  count                                = var.subnet_name == null ? 0 : 1
  name                                 = "mssql-vnet-rule"
  server_id                            = azurerm_mssql_server.mssql_server.id
  subnet_id                            = data.azurerm_subnet.subnet[count.index].id
  ignore_missing_vnet_service_endpoint = true
}

