# Provision Intel Optimized Azure MSSQL server 
module "optimized-mssql-server" {
  source                           = "intel/azure-mssql/intel"
  resource_group_name              = "shreejan_test_mssql"
  db_server_name                   = "optimized-mssql-server-3"
  db_name                          = "optimized-mssql-db-3"
  db_password                      = var.db_password
  db_public_network_access_enabled = true
  tags = { owner = "owner@intel.com",
    duration          = "4"
    sql_public_access = "allow"
  }

  firewall_ip_range = [
    { name = "Test-Rule-1", start_ip_address = "192.55.54.53", end_ip_address = "192.55.54.53" },
    { name = "Test-Rule-2", start_ip_address = "250.151.84.219", end_ip_address = "250.151.84.219" },
    { name = "Test-Rule-3", start_ip_address = "79.4.142.148", end_ip_address = "79.4.142.148" }
  ]

}


#terraform init  
#terraform plan -var="mssql_administrator_login_password=..." #Enter a complex password
#terraform apply -var="mssql_administrator_login_password=..." #Enter a complex password
