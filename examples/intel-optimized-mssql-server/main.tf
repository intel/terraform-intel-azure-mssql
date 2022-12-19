# Provision Intel Optimized Azure MSSQL server 
module "optimized-mssql-server" {
  source              = "../../" #add the github url later
  resource_group_name = "shreejan_test_mssql"
  db_server_name      = "optimized-mssql-server-1"
  db_name             = "optimized-mssql-db-1"
  db_password         = var.db_password
  tags = { owner = "shreejan.mistry@intel.com",
    duration          = "4"
    sql_public_access = "allow"
  }

}


#terraform init  
#terraform plan -var="mssql_administrator_login_password=..." #Enter a complex password
#terraform apply -var="mssql_administrator_login_password=..." #Enter a complex password
