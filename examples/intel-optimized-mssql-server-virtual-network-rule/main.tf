# Provision Intel Optimized Azure MSSQL server 
module "optimized-mssql-server" {
  source              = "intel/azure-mssql/intel" 
  resource_group_name = "shreejan_test_mssql"
  db_server_name      = "optimized-mssql-server-4"
  db_name             = "optimized-mssql-db-4"
  db_password         = var.db_password
  tags = { owner = "owner.mistry@intel.com",
    duration          = "4"
    sql_public_access = "allow"
  }

  #Required parameters for creating virtual network rule
  subnet_name                 = "default"
  subnet_virtual_network_name = "mssql_vnet_test"
  subnet_resource_group_name  = "test_mssql"
}


#terraform init  
#terraform plan -var="mssql_administrator_login_password=..." #Enter a complex password
#terraform apply -var="mssql_administrator_login_password=..." #Enter a complex password
