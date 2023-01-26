<p align="center">
  <img src="./images/logo-classicblue-800px.png" alt="Intel Logo" width="250"/>
</p>

# Intel® Cloud Optimization Modules for Terraform  

© Copyright 2022, Intel Corporation

## HashiCorp Sentinel Policies

This file documents the HashiCorp Sentinel policies that apply to this module

## Policy 1

Description: **The configured "sku_name" should be an Intel Xeon 3rd Generation(code-named Ice Lake), Intel Xeon 2nd Generation (code-named Cascade Lake) or Intel Xeon 1st Generation (code-named Sky Lake) Scalable processors**

Resource type: **azurerm_mssql_database**

Parameter:  **sku_name**

Allowed Types :

- **General Purpose:** GP_Fsv2_8, GP_Fsv2_10, GP_Fsv2_12, GP_Fsv2_14, GP_Fsv2_16, GP_Fsv2_18, GP_Fsv2_20, GP_Fsv2_24, GP_Fsv2_32, GP_Fsv2_36, GP_Fsv2_72

## Links
https://learn.microsoft.com/en-us/azure/virtual-machines/fsv2-series

https://azure.microsoft.com/en-us/pricing/details/azure-sql-database/single/