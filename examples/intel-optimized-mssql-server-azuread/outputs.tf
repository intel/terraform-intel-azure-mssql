########################
####     General    ####
########################

output "db_server_sku" {
  description = "Instance SKU in use for the database instance that was created."
  value       = module.optimized-mssql-server.db_server_sku
}

output "db_server_name" {
  description = "Database instance hostname."
  value       = module.optimized-mssql-server.db_server_name
}

output "db_resource_group_name" {
  description = "Resource Group where the database instance resides."
  value       = module.optimized-mssql-server.db_resource_group_name
}

output "db_location" {
  description = "Database instance location."
  value       = module.optimized-mssql-server.db_location
}
output "db_id" {
  description = "Database instance ID."
  value       = module.optimized-mssql-server.db_id
}

output "db_hostname" {
  description = "Database instance fully qualified domain name."
  value       = module.optimized-mssql-server.db_hostname
}

output "db_engine_version_actual" {
  description = "Running engine version of the database (full version number)."
  value       = module.optimized-mssql-server.db_engine_version_actual
}

output "db_create_mode" {
  description = "The creation mode that was configured on the instance. "
  value       = module.optimized-mssql-server.db_create_mode
}

output "db_public_network_access_enabled" {
  description = "Public network access configured"
  value       = module.optimized-mssql-server.db_public_network_access_enabled
}

output "db_connection_policy" {
  description = "The connection policy the server uses"
  value       = module.optimized-mssql-server.db_connection_policy
}

output "db_min_tls_version" {
  description = "The Minimum TLS Version for all SQL Database and SQL Data Warehouse databases associated with the server"
  value       = module.optimized-mssql-server.db_min_tls_version
}

output "db_subnet_id" {
  description = "The ID of the virtual network subnet to create the virtual network rule."
  value       = module.optimized-mssql-server.db_subnet_id
}

########################
#### Authentication ####
########################

output "db_username" {
  description = "Database instance master username."
  value       = module.optimized-mssql-server.db_server_name
  sensitive   = true
}

output "db_password" {
  description = "Database instance master password."
  value       = module.optimized-mssql-server.db_password
  sensitive   = true
}

########################
####    Storage     ####
########################

output "db_capacity" {
  description = "Capacity of the Database"
  value       = module.optimized-mssql-server.db_capacity

}

output "db_storage_account_type" {
  description = "Storage account type used to store backups"
  value       = module.optimized-mssql-server.db_storage_account_type
}
########################
####    Firewall    ####
########################
output "db_firewall_rules" {
  description = "Database Firewall Rules."
  value       = module.optimized-mssql-server.db_firewall_rules
}

########################
####    Database    ####
########################

output "db_name" {
  description = "Name of the database that has been provisioned on the database instance."
  value       =module.optimized-mssql-server.db_name
}

output "db_collation" {
  description = "The Collation configured on the database."
  value       = module.optimized-mssql-server.db_collation
}

output "db_license_type" {
  description = "The LicenseType configured on the database."
  value       = module.optimized-mssql-server.db_license_type
}

########################
####     Backups    ####
########################

output "db_backup_retention_period" {
  description = "Number of Days configured to retain backups for the database instance."
  value       = module.optimized-mssql-server.db_backup_retention_period
}

output "db_geo_backup_enabled" {
  description = "The Geo Backup Policy configured on the database"
  value       = module.optimized-mssql-server.db_geo_backup_enabled
}

########################
####     Restore    ####
########################

output "db_restore_time" {
  description = "Specifies the point in time to restore from creation_source_server_id."
  value       = module.optimized-mssql-server.db_restore_time
}

output "db_create_source_id" {
  description = "For creation modes other than Default, the source server ID to use."
  value       = module.optimized-mssql-server.db_create_source_id
}

