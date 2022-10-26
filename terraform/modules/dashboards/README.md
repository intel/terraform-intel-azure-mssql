# Dashboard modules

This README is about dashboards module for various CSPs, directed towards anyone developing the Intel OCS project.

## Dashboard README list

- [Azure dashboards] (azure/module_inputs.md)

## Adding dashboards to a new project

Add proper module section into project .tf definitions. An example definition is:

```
module "dashboards" {
  source = "./modules/dashboards/azure"

  location = var.location
  resourcegroup = var.resourcegroup

  db_only = var.dbOnly
  vm_db = module.mysql-benchmark.mysql-azure.vm_db
  vm_stresser = module.mysql-benchmark.mysql-azure.vm_stresser
}
```
