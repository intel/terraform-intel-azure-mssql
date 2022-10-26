<h1 align="center">Intel Optimized Cloud Stack</h1>
This repository contains tools used to automatically create necessary infrastructure on Cloud Service Providers and run benchmark on provisioned infrastructure. Intel OCS stands for Intel Optimized Cloud Stack. Our customers struggle with Virtual Machine performance for their workloads in the Cloud, especially when performing lift and shift migration. Intel Optimized Cloud Stack prepares a recipe for creating a secure and performant VM image; tailored for the specific applications. The optimizations start with Operating System and go up to the workload itself. Additionally, Intel Optimized Cloud Stack implements our security standards on the VM. Intel Optimized Cloud Stack can be easily adopted by the Global Solution Integrators in their workload build pipelines. Our goal is to create interest in Intel Silicon in the public clouds.

# Table of contents

- [Table of contents](#table-of-contents)
- [Prerequisite](#prerequisite)
  - [Set Up Cloud Infrastructure](#set-up-cloud-infrastructure)
  - [System configuration](#system-configuration)
  - [Install dependencies](#install-dependencies)
  - [Third-party licenses](#third-party-licenses)
  - [Prepare a list of outbound networks used in your business](#prepare-a-list-of-outbound-networks-used-in-your-business)
- [General workflow](#general-workflow)
  - [Supported workflows](#supported-workflows)
  - [Parameters reference](#parameters-reference)
- [Usage](#usage)
  - [Launcher (Recommended)](#launcher-recommended)
  - [Launcher with custom profile (Quick Start)](#launcher-with-custom-profile-quick-start)
  - [Manual (Advanced)](#manual-advanced)
  - [Export Virtual Machine Image limitations](#export-virtual-machine-image-limitations)
    - [Azure Image](#azure-image)
  - [Mitigation Report](#mitigation-report)
  - [Custom Post Configuration](#custom-post-configuration)
- [Known issues](#known-issues)
  - [Error: purging Secret](#error-purging-secret)
- [Appendices](#appendices)
  - [Service Principal](#service-principal)
    - [Creating Principal as an user with App Registration permissions](#creating-principal-as-an-user-with-app-registration-permissions)
  - [Azure CLI](#azure-cli)
    - [Authenticating using Azure CLI](#authenticating-using-azure-cli)
  - [General security notes](#general-security-notes)
    - [VM security](#vm-security)
    - [Firewalls](#firewalls)
  - [Documentation index](#documentation-index)
    - [Variables reference](#variables-reference)
      - [Workloads on Azure](#workloads-on-azure)
    - [Directory structure](#directory-structure)

# Prerequisite

## Set Up Cloud Infrastructure

The user should understand the basics of cloud computing and have at least the minimal knowledge of the selected cloud provider. Also, it is necessary to either contact the administrators to get a Service Principal created or create one.
See [Azure CLI documentation](https://docs.microsoft.com/en-us/cli/azure/ad/sp?view=azure-cli-latest#az_ad_sp_create_for_rbac) to read about Service Principal creation process from Azure CLI.
More detailed instruction is available in [Authenticate to Azure using the linked appendix](#principal).
If you wish to use Azure CLI it is also described in [Authenticating using Azure CLI](#cli).


| CSP   |        Authorization method         |
| ----- | :----------------------------------:|
| Azure | [Service Principal](#principal)     |
| Azure |       [Azure CLI](#cli)             |
| AWS   |    Credentials from AWS CLI         |
| AWS   |  Access key and secret key directly |

Follow hyperlink from Authorization method to learn more about particular method.

## System configuration

You need access to external network. Configure proxy if needed. Linux-based operating system is required. Launching on other operating system families is not supported

## Install dependencies

| Name      | Version         |
| --------- | --------------- |
| Ansible   | 5.7.0 or newer  |
| Terraform | 1.1.9 or newer  |
| Python    | 3.8 or newer    |
| AZ CLI    | 2.28.0 or newer |
| Linux     | Generic         |
| Pip       | Generic         |
| Git       | Generic         |

Intel Optimized Cloud Stack requires some packages. You need to install Terraform, python, pip, git and ansible dependencies in versions mentioned in the table above. Scripts have been tested on Linux bases operation system. Terraform installation procedure is described [on Hashicorp Terraform's website](https://learn.hashicorp.com/tutorials/terraform/install-cli). Python git and pip can be installed via a package manager, depending on the used Linux distribution. For example, on Ubuntu you can run `apt install python3 python3-pip git`. You can learn more about the installation process on relevant software websites. After a successful installation, you can install the necessary Python packages specified in requirements.txt with the command below
```
pip3 install -r requirements.txt
```  
Remember that users are responsible for installing and updating any third-party components on their systems. Intel recommends that systems use the latest available software versions for all User-installed third party components, and follow all third party secure configuration guidance.  
Exporting image to the cloud require az cli, installation procedure is described [in the linked Azure documentation](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli).

## Third-party program licenses  
<a name=third-party-licenses></a>
This software uses various third-party components which have their own separate use limitations and licensing. These are printed when using the application and have to be understood and accepted. List of these third-party products can be found in third-party-products.txt file.

## Prepare a list of outbound networks used in your business

The user-cloud communication is constrained by a firewall. To be able to access the infrastructure and prepare the benchmark, it is
necessary to gather a list of outbound network addresses used by your business and pass it through the `ssh_allowed_ips` parameter.
# General workflow
<a name="workflow"></a>
Intel Optimized Cloud Stack benchmark flow has 4 main stages:

- Prepare - create infrastructure on cloud service provider
- Perform (installation) - install dependencies necessary to experiments
- Perform (experiments) - run benchmark session
- Destroy - destroy infrastructure after successful benchmark

Few additional steps:
- Export -  export VM database image to the cloud (optional step), can be run instead of destroy to export optimized image
- Mitigation - get report for Meltdown, Spectre and potentially different vulnerabilities, can be run as optional step after first perform
- Test - run end to end workflow with a customized profile; see ['Launcher with custom profile (Quick Start)'](launcher-with-custom-profile-quick-start) section.
- Postconfigure - allows to run user's custom collection Ansible scripts; see ['Custom post-configuration'](#custom-post-configuration) section.

![Intel Optimized Cloud Stack Workflow](images/generalworkflow.png?raw=true)

## Supported workflows

| CSP   | Optimized Benchmark |
| ----- | :-----------------: |
| Azure |        MySQL        |
| Azure |        MSSQL        |
| Azure |        Oracle       |
| AWS   |        MSSQL        |

## Parameters reference
<a name="parameter_reference"></a>
The parameters can be divided into 3 groups: launcher based, ansible based and terraform based. All of the benchmark parameters are either Ansible-based or Terraform-based. You can learn more about launcher specific parameters with `-h` flag: `python3 launcher.py -h`. Most of the launcher parameters are used to change the behaviour during the execution, like log verbosity or logging style. Some Ansible parameters are taken by launcher and processed into packages/group_vars/profile.yaml file during the perform stage. Launcher allows to override only some of the parameters. They are marked in variables reference as "Can be overriden from launcher in perform stage". All Ansible parameters are described in [Variables Reference](#ansiblevariables). Terraform parameters are set by launcher in prepare stage in `terraform/tfvars.tf`. All of the Terraform parameters can be overriden via launcher and they are described in [Variables Reference](#terraformvariables).

# Usage

The Intel Optimized Cloud Stack tooling can be used through the launcher or launched manually using the Ansible/Terraform commands. Launcher is a script written in Python to create an user-friendly, abstract interface between the user and the scripts.

Clone repository via git.

## Launcher (Recommended)

As mentioned in the section [General Workflow](#workflow), the benchmarking flow has 4 stages. The below commands are only a example which doesn't include all of the parameters. The user can customize a benchmark by overriding parameters that are explained in the [Parameters Reference](#parameter_reference)

1. Create infrastructure

```
python3 -u launcher.py --provider %PROVIDER% --accept_all_licenses --auth_method=%AUTH_METHOD% %SCENARIO% prepare -v=1 -ll=%LOG_LEVEL% --extra_vars \
resourcegroup=%RESOURCEGROUP% \
server_instancetype=%SERVER_INSTANCETYPE% \
server_disks_data_disks=%SERVER_DISKS_DATA_DISKS% \
server_disks_data_size=%SERVER_DISKS_DATA_SIZE% \
server_disks_wal_size=%SERVER_DISKS_WAL_SIZE% \
server_os_disksize=%SERVER_OS_DISKSIZE% \
ssh_allowed_ips=%SSH_ALLOWED_IPS% \
```  
In addition to that, append proper authentication variables:

* On Azure, append the below lines. 
```
client_id=%CLIENT_ID% \
subscription_id=%SUBSCRIPTION_ID% \
tenant_id=%TENANT_ID% \
client_secret=%CLIENT_SECRET%
```

* On AWS, include the below lines.
```
access_key=%ACCESS_KEY% \
secret_key=%SECRET_KEY%
```

2. Perform software installation
> :warning: **v_users parameter with installation tag must be lower than or equal to the number of warehouses**: In other case, schema building will fail.
```
python3 -u launcher.py --provider %PROVIDER% %SCENARIO% perform -v=1 -ll=%LOG_LEVEL% --accept_all_licenses --extra_vars tag=installation \
v_users=%V_USERS% \
warehouses=%WAREHOUSES% \
test_duration=%TEST_DURATION%
```

3. Perform benchmark
> :warning: **v_users parameter with experiments tag must be greater than zero**
```
python3 -u launcher.py --provider %PROVIDER% %SCENARIO% perform --accept_all_licenses -v=1 -ll=%LOG_LEVEL% --extra_vars tag=experiments \
v_users=%V_USERS% \
warehouses=%WAREHOUSES% \
test_duration=%TEST_DURATION% \
client_id=%CLIENT_ID% \
subscription_id=%SUBSCRIPTION_ID% \
tenant_id=%TENANT_ID% \
client_secret=%CLIENT_SECRET% \
resourcegroup=%RESOURCEGROUP%
```

4. Export image (Optional)
```
python3 -u launcher.py %SCENARIO% export --accept_all_licenses -v=1 -ll=%LOG_LEVEL% --extra_vars \
client_id=%CLIENT_ID% \
subscription_id=%SUBSCRIPTION_ID% \
tenant_id=%TENANT_ID% \
client_secret=%CLIENT_SECRET% \
resourcegroup=%RESOURCEGROUP%
```
Image will be exported to resource group with `_IMAGES` suffix and the original resource group will be destroyed.

5. Collect results
Results are stored in `packages/benchmark-results` directory. You can use `hammerdb.log` or `hammerdb-results.xml file`. In `hammerdb.log`, results are nearly at the end of the file, example: `RESULT : System achieved 517217 NOPM from 1567462 MySQL TPM`.

6. Utilization metrics
Virtual machines and disks performance utilization metrics are collected automaticaly with results (see point 5) and saved in `benchmark-results/metrics` as csv file. Example metrics include: Percentage CPU, Disk Read Bytes, Disk Write Bytes, Disk Read Operations/Sec, Disk Write Operations/Sec, Data Disk Queue Depth, OS Disk Queue Depth

User must run perform (experiments) stage passing azure credentials parameters to collect metrics i.e.: client_id=%CLIENT_ID%
subscription_id=%SUBSCRIPTION_ID%
tenant_id=%TENANT_ID%
client_secret=%CLIENT_SECRET% \

7. Destroy infrastructure (Only if image isn't exported - see point 4)

```
python3 -u launcher.py %SCENARIO% destroy --accept_all_licenses --provider %PROVIDER% --auth_method=%AUTH_METHOD% -v=1 -ll=%LOG_LEVEL% --extra_vars \
auth_method=%AUTH_METHOD% \
client_id=%CLIENT_ID% \
subscription_id=%SUBSCRIPTION_ID% \
tenant_id=%TENANT_ID% \
client_secret=%CLIENT_SECRET% \
resourcegroup=%RESOURCEGROUP% \
server_instancetype=%SERVER_INSTANCETYPE% \
server_disks_data_disks=%SERVER_DISKS_DATA_DISKS% \
server_disks_data_size=%SERVER_DISKS_DATA_SIZE% \
server_os_disksize=%SERVER_OS_DISKSIZE% \
ssh_allowed_ips=%SSH_ALLOWED_IPS%
```  

Use
```
access_key=%ACCESS_KEY%
secret_key=%SECRET_KEY%
```  
instead of client_id, subscription_id, tenant_id and client_secret if running AWS provider benchmarks.  

Destroy infrastructure will remove your all resources in particular Resource Group in the Cloud but your benchmark results (see point 5) will be kept.

Optionally, after step 2, a CPU vulnerability mitigation report can be generated. Please refer to the [mitigation report generation](#mitigation-report) section if that is necessary.
## Launcher with custom profile (Quick Start)

Launcher provides possibility to run whole workflow ([General Workflow](#workflow)) by using a short single command. The only one parameter required for this command is a name of the selected profile.

Custom profiles consist of two files:

- packages/group_vars/%CUSTOM_PROFILE_NAME%.yaml - file containing ansible-specific variables, for full list of available parameters please refer to [(Ansible) Variables Reference](#ansiblevariables)

- terraform/vars\_%CUSTOM_PROFILE_NAME%.tfvars - file containing terraform-specific variables, for full list of available parameters please refer to [(Terraform) Variables Reference](#terraformvariables)

It is important to note that %CUSTOM_PROFILE_NAME% must contain CSP provider as a prefix. For example if user want theirs custom profile to be used on Azure Cloud, user must name it `azure_%PROFILE_NAME%`, where %PROFILE_NAME% is unrestricted.

List of predefined custom profiles:

- azure_mysql_SmallDB

  This profile prepares Standard E4ds_v4 workload instance with attached 1x P40 disk on Azure CSP.

  HammerDB 4.2 is executed with 60 virtual users and 80 warehouses, test is set to last 20 minutes with 10 minute rampup.

- azure_mysql_MediumDB

  This profile prepares Standard E16ds_v4 workload instance with attached 1x P40 disk on Azure CSP.

  HammerDB 4.2 is executed with 120 virtual users and 160 warehouses, test is set to last 20 minutes with 10 minute rampup.

- azure_mysql_LargeDB

  This profile prepares Standard E64ds_v4 workload instance with attached 1x P80 disk on Azure CSP.

  HammerDB 4.2 is executed with 600 virtual users and 800 warehouses, test is set to last 20 minutes with 10 minute rampup.

- azure_mssql_SmallDB

  This profile prepares Standard E4ds_v4 workload instance with attached 1x P80 data disk and 1x P30 log disk on Azure CSP.

  HammerDB 4.2 is executed with 60 virtual users and 80 warehouses, test is set to last 20 minutes with 10 minute rampup.

- azure_mssql_MediumDB

  This profile prepares Standard E16ds_v4 workload instance with attached 2x P80 data disk and 1x P30 log disk on Azure CSP.

  HammerDB 4.2 is executed with 120 virtual users and 160 warehouses, test is set to last 20 minutes with 10 minute rampup.

- azure_mssql_LargeDB

  This profile prepares Standard E64ds_v4 workload instance with attached 4x P80 data disk and 1x P30 log disk on Azure CSP.

  HammerDB 4.2 is executed with 600 virtual users and 800 warehouses, test is set to last 20 minutes with 10 minute rampup.

- aws_mssql_SmallDB  
  
  This profile prepares m6i.2xlarge workload instance with attached 16TiB GP3 data disk with 16kIOPS and 1000MiB/s throughput and 3000 IOPS and 125MiB/s throughput for log disk on AWS CSP.

  HammerDB 4.2 is executed with 60 virtual users and 80 warehouses, test is set to last 20 minutes with 10 minute rampup.

- aws_mssql_MediumDB  
  
  This profile prepares m6i.4xlarge workload instance with attached 2x16TiB GP3 data disk with 16kIOPS and 1000MiB/s throughput and 3000 IOPS and 125MiB/s throughput for log disk on AWS CSP.

  HammerDB 4.2 is executed with 120 virtual users and 320 warehouses, test is set to last 20 minutes with 10 minute rampup.

- azure_oracle_SmallDB
  
  This profile prepares Standard E8ds_v4 workload instance with attached 1x P80 data disk and 1x P80 log disk on Azure CSP.

  HammerDB 4.2 is executed with 32 virtual users and 128 warehouses, test is set to last 10 minutes with 5 minute rampup.

- azure_oracle_MediumDB
  
  This profile prepares Standard E16ds_v4 workload instance with attached 1x P80 data disk and 1x P80 log disk on Azure CSP.

  HammerDB 4.2 is executed with 72 virtual users and 256 warehouses, test is set to last 10 minutes with 5 minute rampup.

User can run workflow with custom profile using following command:

```
python3 -u launcher.py %SCENARIO% %CUSTOM_PROFILE_NAME% test --provider %PROVIDER% --accept_all_licenses
```

User can add extra variables or change custom profile variables by just using parameter --extra_vars, so for example user can specify theirs credentials like this:

```
python3 -u launcher.py %SCENARIO% %CUSTOM_PROFILE_NAME% test --provider %PROVIDER% --accept_all_licenses --extra_vars client_id=%CLIENT_ID% \
```

* On Azure, append the below lines. 
```
client_id=%CLIENT_ID% \
subscription_id=%SUBSCRIPTION_ID% \
tenant_id=%TENANT_ID% \
client_secret=%CLIENT_SECRET%
```

* On AWS, include the below lines.
```
access_key=%ACCESS_KEY% \
secret_key=%SECRET_KEY%
```

## Manual (Advanced)

1. Read all licenses from licenses directory. By using Intel Optimized Cloud Stack you hereby agree with all of the third party license and Intel Optimized Cloud Stack license.
2. Required terraform variables `terraform/terraform.tfvars` (Check Terraform variables reference for details, [Variables Reference](#terraformvariables))
3. Required ansible variables `packages/group_vars/profile.yaml` (Check Ansible variables reference for details, [Variables Reference](#ansiblevariables))
4. Create infrastructure

```
cd terraform
terraform -chdir=workloads/<provider>-<scenario> init
terraform -chdir=workloads/<provider>-<scenario> apply -auto-approve -var-file=../../terraform.tfvars
cd ../
```

5. Install software benchmark

```
cd packages
ansible-playbook -i inv.ini -t installation intel.optimizedcloudstack.workload_<scenario>
cd ../
```

6. Perform benchmark

```
cd packages
ansible-playbook -i inv.ini -t experiments intel.optimizedcloudstack.workload_<scenario>
cd ../
```
7. Export image (Optional)
Consult ["Export Virtual Machine Image limitations"](#export-limitation) section before using this part of the flow.
```
cd packages
ansible-playbook -i inv.ini intel.optimizedcloudstack.export_image
cd ../
```
Image will be exported to resource group with `_IMAGES` suffix and the original resource group will be destroyed. 

8. Collect results

Results are stored in `packages/benchmark-results/hammerdb.log` directory. You can open it with any text editor. Results almost at end of file, example: `RESULT : System achieved 517217 NOPM from 1567462 MySQL TPM`.

9. Utilization metrics
Virtual machines and disks performance utilization metrics are collected automaticaly with results (see point 5) and saved in `benchmark-results/metrics` as csv file. Example metrics include: Percentage CPU, Disk Read Bytes, Disk Write Bytes, Disk Read Operations/Sec, Disk Write Operations/Sec, Data Disk Queue Depth, OS Disk Queue Depth

User must run perform (experiments) stage passing azure credentials parameters to collect metrics i.e.: client_id=%CLIENT_ID%
subscription_id=%SUBSCRIPTION_ID%
tenant_id=%TENANT_ID%
client_secret=%CLIENT_SECRET% \

10. Destroy infrastructure (Only if image isn't exported)

```
cd terraform
terraform -chdir=workloads/<YOUR WORKLOAD TYPE> destroy -auto-approve -var-file=terraform.tfvars
cd ../
```
## Export Virtual Machine Image limitations
<a name="export-limitation"></a>
Intel Optimized Cloud Stack export feature creates an image from an optimized database virtual machine. User can use the exported image to deploy own virtual machines or use it in a scale set. Exported images have some limitations, which depend on the specific Cloud Service Provider.

### Azure Image
* Image is available in resource group where Virtual Machine was created with `_IMAGES` suffix
* The user is responsible for deploying and using the images.
* Deploying using the custom image is currently not supported by the project.
* Since the image includes only the optimized OS disk, the user needs to attach the data disks on their own.
* After export, infrastructure can't be reused or accessed
* Some optimizations make memory related changes in kernel parameters, which can cause that created image may work properly only on selected VM instance sizes
* MSSQL image exporting is not supported.
* Oracle image exporting is not supported.

### AWS Image
* MSSQL image exporting is not supported.
## Mitigation Report
<a name="mitigation-report"></a>

Vulnerability mitigation report can be generated under "benchmark-results/mitigation-results" directory using the command below
```
python3 -u launcher.py <scenario> mitigation --accept_all_licenses -v=1 -ll=%LOG_LEVEL%
```
The "scenario" variable can be set to any correct scenario value.

## Custom Post Configuration
<a name="launcher-postconfiguration"></a>
Intel Optimized Cloud Stack supports custom configuration for created infrastructure. To add post configuration scripts, developers can add custom Ansible collections to `packages/collections/ansible_collections` directory. Additional variables can be places in `packages/group_vars/custom.yaml` file. The file uses a dedicated Ansible host group to pass custom user variables. The playbooks can be run using the launcher or manually, using ansible-playbook command when ran from the `packages` directory. More information about developing Ansible collections can be found (here)[https://docs.ansible.com/ansible/latest/dev_guide/developing_collections.html].
For example:
* A collection has been added to the `packages/collections/ansible_collections/mycompanyname/bestansiblecollection` directory with playbook placed in `packages/collections/ansible_collections/mycompanyname/bestansiblecollection/playbooks/bestplaybook.yaml`.  
* Variables have been added to `packages/group_vars/custom.yaml`. 
* Afterwards, the infrastructure is created with Intel Optimized Cloud Stack launcher.  
To execute the implemented post configuration scrips it is necessary to run:

```
cd packages
ansible-playbook -i inv.ini mycompanyname.bestansiblecollection.bestplaybook
```

Files tree:
```
packages/collections/ansible_collections/mycompanyname/bestansiblecollection/playbooks/bestplaybook.yaml
packages/group_vars/custom.yaml
```

Using collections from launcher
```
python3 launcher.py <scenario> postconfigure --accept_all_licenses --extra_vars variable_one=Hello
```
> :warning: **Terraform customization is not yet possible as of now.**
# Known issues

## Error: purging Secret

```
Error: purging Secret "ssh-key-azure-vm-pub" (Key Vault "https://kv-gi-e57667c377216a67.vault.azure.net/"): keyvault.BaseClient#PurgeDeletedSecret: Failure responding to request: StatusCode=400 -- Original Error: autorest/azure: Service returned an error. Status=400 Code="NotSupported" Message="Operation \"purge\" is not enabled for this vault."

Error: purging Secret "ssh-key-azure-vm" (Key Vault "https://kv-gi-e57667c377216a67.vault.azure.net/"): keyvault.BaseClient#PurgeDeletedSecret: Failure responding to request: StatusCode=400 -- Original Error: autorest/azure: Service returned an error. Status=400 Code="NotSupported" Message="Operation \"purge\" is not enabled for this vault."
```

This terraform bug happened in the past, but it should be fixed now. Mitigation was to run `terraform destroy` again.
If you see `Error: Unable to determine the Resource ID for the Key Vault at URL [...]"` then the resources should already be deleted. Please check Azure portal resource groups to see if it deleted.

# Appendices

## AWS IAM policies

If running on a separate developer subscription (as should always be the case when testing), you can get away with using AdministratorAccess policy. If local Administrator doesn't allow such a broad policy, see [AWS_IAM_permissions.md](docs/AWS_IAM_permissions.md) document to understand what kind of policies the Intel Optimized Cloud Stack workflow requires on AWS.

## Using AWS credentials

If awscli is used to log in the standard way, Terraform should automatically fetch the credentials from default profile when running AWS workloads. If not, use the "access_key" and "secret_key" Terraform extra_vars instead.

## Service Principal

<a name="principal"></a>

### Creating Principal as an user with App Registration permissions

To proceed with further steps, it is necessary to [install the Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli). After installing it and confirming that `az` command works and the version matches the version table, you can go further.
Service principal with a Secret is recommended and can be created using the commands below - please follow the steps marked out in az login to successfully log in:

```
az login
az ad sp create-for-rbac -n <principal_account_name> --sdk-auth
```

If for some reason the Azure Shell is trying to open a browser but cannot, please run the alternative below:

```
az login --use-device-code
az ad sp create-for-rbac -n <principal_account_name> --sdk-auth
```

Output from Service Principal creation should look like below - note down the four mentioned below:

```
{
  "clientId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "clientSecret": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
  "subscriptionId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "tenantId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  [shortened]
}
```

Open the main.tf file with a text editor and locate the "provider" section. Replace the placeholders with data obtained in the previous step. Do not modify "client_secret" value.

```
provider "azurerm" {
  [...]
  subscription_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  client_id       = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  client_secret   = var.client_secret
  tenant_id       = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}
```

Replace PASTE_SECRET_HERE part below with clientSecret:

```
export TF_VAR_client_secret=PASTE_SECRET_HERE
```

Remember to export the secret each time you open a shell, or else the deployment process will not succeed.

## Azure CLI

<a name="cli"></a>

### Authenticating using Azure CLI

To proceed with further steps, it is necessary to [install the Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli). After installing it and confirming that `az` command works and the version matches the version table, you can go further.
Using Azure CLI is really simple and straight forward way to authenticate, but keep in mind that it has to be performed before any further usage (i.e. running launcher).
First, run the command below:

```
az login
```

At this point, browser window should pop open and ask you to login on Azure site. Follow the steps provided there.
After you see successful login output, you can either close this tab or wait 10 seconds for it to close automatically.

If for some reason the Azure Shell is trying to open a browser but cannot, use the alternative below and follow the marked out steps:

```
az login --use-device-code
```

When you come back to shell after succesful login, you should see output containing something like this:

```
[
  {
    [...]
    "id": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
    [...]
    "name": "xxxxxxxxxxxxxxxxxx",
    "state": "Enabled",
    "tenantId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
    "user": {
      "name": "name@company.mail",
      "type": "user_type"
    }
  }
]
```

This indicates that login was successful and you are set to go.
If your account happens to have more than one subscription, you can specify which one you would like to use providing this argument to launcher.
If you wish to learn more on possible options using Azure CLI, like using different tenant, follow this [reference](https://docs.microsoft.com/en-us/cli/azure/authenticate-azure-cli).

After succesful authentication, append `-a=cli` parameter to each launcher command and do not specify service principal parameters `client_id=%CLIENT_ID% subscription_id tenant_id client_secret` like in the example below.
```
python3 -u launcher.py -a=cli %SCENARIO% %CUSTOM_PROFILE_NAME% test --provider %PROVIDER% --accept_all_licenses --extra_vars some_vars=some_value
```

## General security notes

### VM security

Generated SSH keys are using RSA 4096 bytes.  
Password authentication is disabled, so user can only connect using ssh keys.  
Virtual machines with Windows OS are using OpenSSH (version 0.0.1.0) to handle SSH connections. SSH keys are injected into `C:\ProgramData\ssh\administrators_authorized_keys`. SSHD configuration is located in `C:\ProgramData\ssh\sshd_config`.

### Firewalls
By default, all outgoing traffic from VMs is allowed. Incoming traffic is allowed only for addresses specified in either rdp_allowed_ips and ssh_allowed_ips parameters. For Windows machines with default settings, RDP traffic is not configured to accept any traffic, but this can be changed. Contact the project team if there is any necessity for remote RDP access for further instructions.

## Documentation index

### Variables reference

<a name="ansiblevariables"></a>
[(Ansible) Variables Reference](packages/README.md)

#### Workloads on Azure
<a name="terraformvariables"></a>
[(Terraform) MySQL Variables Reference](terraform/workloads/azure-mysql/benchmark_settings.md)
[(Terraform) MSSQL Variables Reference](terraform/workloads/azure-mssql/benchmark_settings.md)
[(Terraform) Oracle Variables Reference](terraform/workloads/azure-oracle/benchmark_settings.md)

### Directory structure

- images - contains the images used in documentation
- packages - contains benchmarks which are run on deployed infrastructure
- terraform - contains configurations for infrastructure creation scripts
- licenses - contains third party licenses
