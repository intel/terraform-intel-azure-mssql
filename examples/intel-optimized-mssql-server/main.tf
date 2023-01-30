# Provision Intel Optimized Azure MSSQL server 
module "optimized-mssql-server" {
  source              = "intel/azure-mssql/intel" 
  resource_group_name = "shreejan_test_mssql"
  db_server_name      = "optimized-mssql-server-1"
  db_name             = "optimized-mssql-db-1"
  db_password         = var.db_password
  tags = { owner = "owner@intel.com",
    duration          = "3"
  }

}


#terraform init  
#terraform plan -var="mssql_administrator_login_password=..." #Enter a complex password
#terraform apply -var="mssql_administrator_login_password=..." #Enter a complex password
