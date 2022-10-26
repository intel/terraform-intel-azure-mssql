# Development guide
## Developer skillset
Most of the Intel Optimized Cloud Stack code is written in Ansible, Terraform and Python. Developers should be familiar with working in Linux environment, have the basic knowledge of networking (DNS, troubleshooting simple networking issues) and cloud environments (Azure).

## Custom post configuration scripts (Not yet supported)
In release 2.0.0, custom post configuration is not yet supported. However it will be supported in the next releases. Intel doesn't guarantee support for post configuration scripts and compatibility between official Intel Optimized Cloud Stack and post configuration scripts.

### Usage (Not Supported yet)
To add post configuration scripts, developers can add custom Ansible collections to `packages/collections/ansible_collections` directory. Additional variables can be places in `packages/group_vars/custom.yaml` file. The file uses a dedicated Ansible host group to pass custom user variables. The playbooks can be run using the launcher or manually, using ansible-playbook command when ran from the `packages` directory. More information about developing Ansible collections can be found (here)[https://docs.ansible.com/ansible/latest/dev_guide/developing_collections.html]. Terraform customization is not yet possible as of now.

### Example
As a developer, I have added a collection to `packages/collections/ansible_collections/mycompanyname/bestansiblecollection` directory with playbook placed in `packages/collections/ansible_collections/mycompanyname/bestansiblecollection/playbooks/bestplaybook.yaml`. Then I added some critical variables to `packages/group_vars/custom.yaml`. Afterwards, the infrastructure is created with Intel Optimized Cloud Stack launcher. To execute my post configuration scripts, I should run:

```
cd packages
ansible-playbook -i inv.ini mycompanyname.bestansiblecollection.bestplaybook
```

Files tree:
```
packages/collections/ansible_collections/mycompanyname/bestansiblecollection/playbooks/bestplaybook.yaml
packages/group_vars/custom.yaml
```
## Implementation guidelines
### Launcher
Written in Python in `launcher.py` file. Argparse is used to parse the user arguments. For help or available commands, please use `./launcher.py -h` command.

What the launcher does:
* creates the variables file for Ansible (passed via `group_vars/profile.yaml`),
* creates the variables file for Terraform (passed via `/terraform/terraform.tfvar`),
* displays third party licenses to the end user,
* provides unified, abstract interface independent from the internal implementations,
* runs Ansible/Terraform scripts.

### Ansible script
The Ansible resources and scripts are stored inside the `packages` directory.

General Ansible configuration:
Configuration is kept in `packages/ansible.cfg` file. Some of the scripts take a long time and need custom SSH and TCP session configuration due to timeout problems. Most of the configuration in ansible.cfg file shouldn't be changed without a good reason.

What the Ansible scripts do:
* initialize environment, attach disks and configure kernel parameters,
* install benchmark and workload software,
* optimize workload software,
* execute any other necessary tasks, like generating mitigation reports or exporting an optimized image.

Role directory layout:
Standard Ansible directory layout is used (link)[https://docs.ansible.com/ansible/2.8/user_guide/playbooks_best_practices.html#directory-layout]. Roles are stored inside a collection in roles directory, jinja2 templates in role templates directory. Tasks are stored in `tasks` directory. Each role has `tasks/main.yaml` file where all other `tasks` files are included or imported.

Variables management:
All important variables are stored in roles `defaults/main.yaml` file. Each variable has a description. Default variables are overrided by variables from `packages/group_vars` directory.

Inventory structure:
Currently the Intel Optimized Cloud Stack creates 2 virtual machines and up to 6 host groups. Default connection uses SSH. Created groups:
* all
* custom (Not supported yet)
* profile
* scenario_<profile detail> - used in short form with predefined variables like instance sizes, disks, etc.
* sut
* load_balancer

### Terraform
Stored in `terraform` directory. Each workload has it's own directory inside `terraform/workloads` directory, the name being formed in `csp-workload` pattern. Currently supported are workloads are in `azure-mysql` and `azure-mssql` directories. Common section contains variables common to all of the workloads. Each workload directory contains `outputs.tf`, `provider.tf` and `variables.tf` files. Files from `common` are symlinked to other workload directories. `terraform/modules` directory contains definitions of reusable terraform code used to create the infrastructure needed for benchmarks or workloads.
What Terraform does:
* creates secure, generalized infrastructure on the chosen public cloud,
* generates Ansible inventory file and passes credentials,
* creates resources necessary for a benchmark or workload in the public cloud,
* destroys infrastructure after running the benchmark.
