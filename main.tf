data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

data "azurerm_subnet" "subnet"{
  name = var.subnet_name
  virtual_network_name = var.subnet_virtual_network_name                      
  resource_group_name = var.subnet_resource_group_name  #should be a variable passed by user
}

resource "azurerm_mssql_server" "mssql_server" {
  name                         = var.mssql_server_name
  resource_group_name          = data.azurerm_resource_group.rg.name
  location                     = data.azurerm_resource_group.rg.location
  version                      = var.mysql_version
  administrator_login          = var.mssql_administrator_login
  administrator_login_password = var.mssql_administrator_login_password
  minimum_tls_version          = var.mysql_min_tls_version
  public_network_access_enabled = var.public_network_access_enabled
  connection_policy            = var.connection_policy
  tags = merge(
                var.tags,
                {"environment_server" = "testserver",
                 "intel accelerated design" = "mssql"
                }
              )
  
  azuread_administrator {
    login_username = var.azuread_login_username
    object_id = var.azuread_object_id
    azuread_authentication_only = var.azuread_authentication_only
  }
  
}

resource "azurerm_mssql_database" "mssql_db" {
  name           = var.mssql_db_name
  server_id      = azurerm_mssql_server.mssql_server.id
  sku_name       = var.mssql_server_sku
  create_mode    = var.create_mode
  license_type   = var.license_type
  max_size_gb    = var.max_size_gb
  storage_account_type = var.storage_account_type
  transparent_data_encryption_enabled = var.transparent_data_encryption_enabled
  tags           = merge(
                          var.tags,
                          {"environment_db" = "testdb",
                           "intel accelerated design" = "mssql"
                          }
                        )
  
}

resource "azurerm_mssql_firewall_rule" "mssql_firewall_rule" {
  name             = "mssql_firewall_rule${count.index}"
  server_id        = azurerm_mssql_server.mssql_server.id
  count            = length(var.firewall_ip_range)
  start_ip_address = var.firewall_ip_range[count.index]["start_ip_address"]
  end_ip_address   = var.firewall_ip_range[count.index]["end_ip_address"]
  
}

resource "azurerm_mssql_virtual_network_rule" "mssql_vnet_rule" {
  name      = "mssql-vnet-rule"
  server_id = azurerm_mssql_server.mssql_server.id  
  subnet_id = data.azurerm_subnet.subnet.id
  ignore_missing_vnet_service_endpoint = true
}

