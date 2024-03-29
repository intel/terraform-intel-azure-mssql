########################
####     General    ####
########################

output "db_server_sku" {
  description = "Instance SKU in use for the database instance that was created."
  value       = azurerm_mssql_database.mssql_db.sku_name
}

output "db_server_name" {
  description = "Database instance hostname."
  value       = azurerm_mssql_server.mssql_server.name
}

output "db_resource_group_name" {
  description = "Resource Group where the database instance resides."
  value       = azurerm_mssql_server.mssql_server.resource_group_name
}

output "db_location" {
  description = "Database instance location."
  value       = azurerm_mssql_server.mssql_server.location
}

output "db_id" {
  description = "Database instance ID."
  value       = azurerm_mssql_server.mssql_server.id
}

output "db_hostname" {
  description = "Database instance fully qualified domain name."
  value       = azurerm_mssql_server.mssql_server.fully_qualified_domain_name
}

output "db_engine_version_actual" {
  description = "Running engine version of the database (full version number)."
  value       = azurerm_mssql_server.mssql_server.version
}

output "db_create_mode" {
  description = "The creation mode that was configured on the instance. "
  value       = azurerm_mssql_database.mssql_db.create_mode
}

output "db_public_network_access_enabled" {
  description = "Public network access configured"
  value       = azurerm_mssql_server.mssql_server.public_network_access_enabled
}

output "db_connection_policy" {
  description = "The connection policy the server uses"
  value       = azurerm_mssql_server.mssql_server.connection_policy
}

output "db_min_tls_version" {
  description = "The Minimum TLS Version for all SQL Database and SQL Data Warehouse databases associated with the server"
  value       = azurerm_mssql_server.mssql_server.minimum_tls_version
}

output "db_subnet_id" {
  description = "The ID of the virtual network subnet to create the virtual network rule."
  value       = try(azurerm_mssql_virtual_network_rule.mssql_vnet_rule[0].subnet_id, "")
}

########################
#### Authentication ####
########################

output "db_username" {
  description = "Database instance master username."
  value       = azurerm_mssql_server.mssql_server.administrator_login
  sensitive   = true
}

output "db_password" {
  description = "Database instance master password."
  value       = azurerm_mssql_server.mssql_server.administrator_login_password
  sensitive   = true
}

########################
####    Storage     ####
########################

output "db_capacity" {
  description = "Capacity of the Database"
  value       = azurerm_mssql_database.mssql_db.max_size_gb

}

output "db_storage_account_type" {
  description = "Storage account type used to store backups"
  value       = azurerm_mssql_database.mssql_db.storage_account_type
}
########################
####    Firewall    ####
########################
output "db_firewall_rules" {
  description = "Database Firewall Rules."
  value       = azurerm_mssql_firewall_rule.mssql_firewall_rule
}

########################
####    Database    ####
########################

output "db_name" {
  description = "Name of the database that has been provisioned on the database instance."
  value       = azurerm_mssql_database.mssql_db.name
}

output "db_collation" {
  description = "The Collation configured on the database."
  value       = azurerm_mssql_database.mssql_db.collation
}

output "db_license_type" {
  description = "The LicenseType configured on the database."
  value       = azurerm_mssql_database.mssql_db.license_type
}

########################
####     Backups    ####
########################

output "db_backup_retention_period" {
  description = "Number of Days configured to retain backups for the database instance."
  value       = azurerm_mssql_database.mssql_db.short_term_retention_policy
}

output "db_geo_backup_enabled" {
  description = "The Geo Backup Policy configured on the database"
  value       = azurerm_mssql_database.mssql_db.geo_backup_enabled
}

########################
####     Restore    ####
########################

output "db_restore_time" {
  description = "Specifies the point in time to restore from creation_source_server_id."
  value       = azurerm_mssql_database.mssql_db.restore_point_in_time
}

output "db_create_source_id" {
  description = "For creation modes other than Default, the source server ID to use."
  value       = azurerm_mssql_database.mssql_db.creation_source_database_id
}

