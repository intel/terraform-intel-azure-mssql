# Provision Intel Optimized Azure MSSQL server 
module "optimized-mssql-server" {
  source              = "intel/azure-mssql/intel"
  resource_group_name = " "
  db_server_name      = " "
  db_name             = " "
  db_password         = var.db_password
  tags = {
    owner    = "owner@intel.com",
    duration = "3"
  }
}

#terraform init  
#terraform plan -var="mssql_administrator_login_password=..." #Enter a complex password
#terraform apply -var="mssql_administrator_login_password=..." #Enter a complex password
