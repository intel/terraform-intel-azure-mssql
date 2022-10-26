#!/bin/python3
"""This script provide user-friendly experience for user non familiar with Terraform, Ansible or database benchmarking."""
### INTEL LICENSE STARTS BELOW
# INTEL CONFIDENTIAL
# Copyright (C) 2021-2022 Intel Corporation
# This software and the related documents are Intel copyrighted materials, and your use of them is governed by the express license under which they were provided to you ("License"). Unless the License provides otherwise, you may not use, modify, copy, publish, distribute, disclose or transmit this software or the related documents without Intel's prior written permission.
# This software and the related documents are provided as is, with no express or implied warranties, other than those that are expressly stated in the License.
### INTEL LICENSE END
import argparse
import logging
import os
from pathlib import Path
import re
import shutil
import subprocess # nosec We have to use subprocess library
import sys
import time
from abc import ABC, abstractmethod
import yaml
from cerberus import Validator


EXIT_CODE = 1
MIN_PYTHON_VERSION = (3, 7)


WORKLOAD_SCENARIO_VARS = {
    'mssql': {
        'v_users': 12,
        'warehouses': 200,
        'database_name': 'tpcc_200WH',
        'execution_count': 1,
        'rampup_duration': 10,
        'test_duration': 5,
        'restoredb': 'no',
        'hammerdb_version': "4.2",
        "resourcegroup": "",
        "client_id": "",
        "subscription_id": "",
        "tenant_id": "",
        "client_secret": "",
        "scenario": "mssql",
        "location": "westus",
        "base_dir": "",
        "provider": ""
    },
    'mysql': {
        "mysql_version": "8.0.22",
        "hammerdb_version": "4.2",
        "mysql_mount_dir": "/var/lib",
        "warehouses": 800,
        "v_users": 64,
        "huge_pages": "yes",
        "num_of_huge_pages": 100,
        "rampup_duration": 5,
        "test_duration": 30,
        "resourcegroup": "",
        "client_id": "",
        "subscription_id": "",
        "tenant_id": "",
        "client_secret": "",
        "base_dir": "",
        "scenario": "mysql",
        "location": "westus",
        "provider": ""
    },
    'oracle': {
        "hammerdb_version": "4.2",
        "oracle_mount_dir": "/mnt/oracledata",
        "oracle_log_dir": "/mnt/oraclelogs",
        "warehouses": 800,
        "v_users": 64,
        "rampup_duration": 5,
        "test_duration": 30,
        "resourcegroup": "",
        "client_id": "",
        "subscription_id": "",
        "tenant_id": "",
        "client_secret": "",
        "base_dir": "",
        "scenario": "oracle",
        "location": "westus",
        "provider": ""
    }
}


TEMPORARY_FILES = ("__pycache__",
                   "terraform/.terraform",
                   "terraform/workloads/azure-mysql/.terraform.lock.hcl",
                   "terraform/workloads/azure-mysql/terraform.tfstate",
                   "terraform/workloads/azure-mysql/terraform.tfstate.backup",
                   "terraform/workloads/azure-mssql/.terraform.lock.hcl",
                   "terraform/workloads/azure-mssql/terraform.tfstate",
                   "terraform/workloads/azure-mssql/terraform.tfstate.backup",
                   "terraform/workloads/aws-mssql/.terraform.lock.hcl",
                   "terraform/workloads/aws-mssql/terraform.tfstate",
                   "terraform/workloads/aws-mssql/terraform.tfstate.backup",
                   "terraform/workloads/azure-oracle/.terraform.lock.hcl",
                   "terraform/workloads/azure-oracle/terraform.tfstate",
                   "terraform/workloads/azure-oracle/terraform.tfstate.backup",
                   "terraform/terraform.tfvars",
                   "packages/group_vars/profile.yaml")


class ErrorMessage:
    """
    Class containing the text of all returned error messages with various parameters.
    """
    @staticmethod
    def file_error(error_description, file_name):
        """Generate error message for incorrectly done file operation."""
        return f"There was following error: {error_description}, while opening file: '{file_name}'"

    @staticmethod
    def undefined_error():
        """Generate error message for unexpected exception."""
        return "The application has encountered a critical error!"

    @staticmethod
    def symlink_error(file_name):
        """Generate error message if referenced file is a symlink."""
        return f"{file_name} is a symlink. Cannot open it..."

    @staticmethod
    def python_version_error():
        """Generate error message for incorrect Python version."""
        return f"Python *{MIN_PYTHON_VERSION} or later is required."

    @staticmethod
    def missing_required_variables_error(required_variables):
        """Generate error message if one of required variables is missing."""
        return f"You've forgot to provide one of {required_variables} value!"

    @staticmethod
    def wrong_unicode_error(validated_variable):
        """Generate error message if passed variable contains value with wrong Unicode character."""
        return f"'{validated_variable}' parameter contains wrong Unicode characters, exiting!"

    @staticmethod
    def license_not_found_error():
        """Generate error message if license directory is missing or empty."""
        return "License directory don't exist or is empty, exiting..."

    @staticmethod
    def process_error(process_exit_code):
        """Generate error message for incorrectly finished process."""
        return f"Process exit code: {process_exit_code}"

    @staticmethod
    def yaml_error():
        """Generate error message for incorrect YAML file."""
        return "YAML profile is not properly formed."

    @staticmethod
    def unsupported_action_error(cmd):
        """Generate error message if unsupported action is passed to launcher."""
        return f"Running launcher with unsupported action {cmd}, exiting"


class Command(ABC):
    """Base class for classes implementing launcher commands."""

    cmd = ""

    def __init__(self, scenario_type, base_dir=None):
        self.scenario_variables = WORKLOAD_SCENARIO_VARS[scenario_type]
        base_dir = base_dir if base_dir else os.getcwd()
        logging.info("Running launcher with %s action.", self.cmd)

    @abstractmethod
    def prepare(self, paths, extra_variables):
        """Abstract method to implement command prepare phase in child classes"""

    @abstractmethod
    def run(self, paths, custom_profile, verbosity, extra_variables):
        """Abstract method to implement command behavior in child classes"""

class PostConfigCommand(Command):
    """Post configuration launcher action.."""

    cmd = "postconfigure"

    def prepare(self, paths, extra_variables):
        """Abstract method to implement command prepare phase in child classes"""
        logging.debug("Prepare for %s", self.cmd)
        prepare_profile_yaml(paths['base_dir'], f"{ paths['ansible_packages'] }/group_vars", None, extra_variables, False)

    def run(self, paths, custom_profile, verbosity, extra_variables):

        if "intel.optimizedcloudstack" in extra_variables["playbook"]:
            logging.error("You cannot run intel collection via post configuration feature")
            sys.exit(EXIT_CODE)

        run_ansible(paths['base_dir'], paths['ansible_packages'], extra_variables["playbook"], tags=extra_variables.get("tag"), verbosity=verbosity)

class PrepareCommand(Command):
    """Class implementing prepare command in launcher."""

    cmd = "prepare"

    def prepare(self, paths, extra_variables):
        #prepare infrastructure and generate profile
        tf_vars = extract_tf_variables(paths['base_dir'], paths['terraform_provider'])
        create_tfvars_file(tf_vars, paths['terraform_main'], extra_variables)

    def run(self, paths, custom_profile, verbosity, extra_variables):
        terraform_init(paths['base_dir'], paths['terraform_provider'], verbosity)
        terraform_apply(paths['base_dir'], paths['terraform_provider'], paths['tfvars_file'], verbosity, custom_profile)

class DestroyCommand(Command):
    """Class implementing destroy command in launcher."""

    cmd = "destroy"

    def prepare(self, paths, extra_variables):
        if not os.path.isfile(paths['tfvars_file']):
            tf_vars = extract_tf_variables(paths['base_dir'], paths['terraform_provider'])
            create_tfvars_file(tf_vars, paths['terraform_main'], extra_variables)

    def run(self, paths, custom_profile, verbosity, extra_variables):
        #delete vms
        destroy_terraform(paths['base_dir'], paths['terraform_provider'], paths['tfvars_file'], verbosity)
        remove_temporary_files(paths['base_dir'])

class PerformCommand(Command):
    """Class implementing perform command in launcher."""

    cmd = "perform"

    def prepare(self, paths, extra_variables):
        prepare_profile_yaml(paths['base_dir'], f"{ paths['ansible_packages'] }/group_vars", extra_variables, self.scenario_variables)
        validate_profile_yaml(f"{ paths['ansible_packages'] }/group_vars/profile.yaml", f"{ paths['ansible_packages'] }/yaml_validation/{ self.scenario_variables['scenario'] }_schema.yaml")

    def run(self, paths, custom_profile, verbosity, extra_variables):
        #run benchmark
        run_ansible(paths['base_dir'], paths['ansible_packages'], f"intel.optimizedcloudstack.workload_{ self.scenario_variables['scenario'] }", tags=extra_variables.get("tag"), verbosity=verbosity)

class ExportCommand(Command):
    """Class implementing export command in launcher."""

    cmd = "export"

    def prepare(self, paths, extra_variables):
        prepare_profile_yaml(paths['base_dir'], f"{ paths['ansible_packages'] }/group_vars", extra_variables, self.scenario_variables)
        validate_profile_yaml(f"{ paths['ansible_packages'] }/group_vars/profile.yaml", f"{ paths['ansible_packages'] }/yaml_validation/{ self.scenario_variables['scenario'] }_schema.yaml")

    def run(self, paths, custom_profile, verbosity, extra_variables):
        run_ansible(paths['base_dir'], paths['ansible_packages'], "intel.optimizedcloudstack.export_image", tags=extra_variables.get("tag"), verbosity=verbosity)

class TestCommand(Command):
    """Class implementing test command in launcher."""

    cmd = "test"

    def prepare(self, paths, extra_variables):
        tf_vars = extract_tf_variables(paths['base_dir'], paths['terraform_provider'])
        create_tfvars_file(tf_vars, paths['terraform_main'], extra_variables)

        prepare_profile_yaml(paths['base_dir'], f"{ paths['ansible_packages'] }/group_vars", extra_variables, self.scenario_variables)
        validate_profile_yaml(f"{ paths['ansible_packages'] }/group_vars/profile.yaml", f"{ paths['ansible_packages'] }/yaml_validation/{ self.scenario_variables['scenario'] }_schema.yaml")

    def run(self, paths, custom_profile, verbosity, extra_variables):
        #run predefined test scenario
        terraform_init(paths['base_dir'], paths['terraform_provider'], verbosity)
        terraform_apply(paths['base_dir'], paths['terraform_provider'], paths['tfvars_file'], verbosity, custom_profile)

        for phase_tag in ['installation', 'experiments']:
            run_ansible(paths['base_dir'], paths['ansible_packages'], f"intel.optimizedcloudstack.workload_{ extra_variables['scenario'] }", phase_tag, verbosity=verbosity)
        destroy_terraform(paths['base_dir'], paths['terraform_provider'], paths['tfvars_file'], verbosity)
        remove_temporary_files(paths['base_dir'])

class MitigationCommand(Command):
    """Class implementing mitigation command in launcher."""

    cmd = "mitigation"

    def prepare(self, paths, extra_variables):
        prepare_profile_yaml(paths['base_dir'], f"{ paths['ansible_packages'] }/group_vars", {}, {"base_dir": paths['base_dir']})
        validate_profile_yaml(f"{ paths['ansible_packages'] }/group_vars/profile.yaml", f"{ paths['ansible_packages'] }/yaml_validation/mitigation_schema.yaml")

    def run(self, paths, custom_profile, verbosity, extra_variables):
        run_ansible(paths['base_dir'], paths['ansible_packages'], "intel.optimizedcloudstack.vm_mitigation", verbosity=verbosity)


def change_path(path):
    """
    Decorator supporting path management. Execute function in specified path then back to saved one.
    """
    def inner_decorator(func):
        def wrapped(*args, **kwargs):
            old_path = os.getcwd()
            os.chdir(path)
            response = func(*args, **kwargs)
            os.chdir(old_path)

            return response

        return wrapped
    return inner_decorator


def print_exec_time(func):
    """
    Decorator for measuring function execution time
    """
    def wrapped(*args, **kwargs):
        start_time = time.time()
        response = func(*args, **kwargs)
        logging.info("Finished after %d seconds.", round(time.time() - start_time, 2))
        return response

    return wrapped


def symlink_check(func):
    """
    Decorator for checking if file is a symlink.
    """
    def wrapped(*args, **kwargs):
        file = args[0]
        if os.path.islink(file):
            logging.error(ErrorMessage.symlink_error(os.path.basename(file)))
            sys.exit(EXIT_CODE)
        # Check for any IO related error (e.g. not existing file, full disk) before opening file
        try:
            return func(*args, **kwargs)
        except IOError as err:
            logging.error(ErrorMessage.file_error(err.strerror, os.path.basename(file)))
            sys.exit(EXIT_CODE)
    return wrapped


def variable_to_terraform(name, value):
    """
    Convert python variable to terraform in-string variables. For example: string is converted to string_var = "STRING_VALUE" etc. Supported types: string, list, tuples, numeric, bool, null.
    """
    logging.debug("Convert %s = %s to terraform variable string.", name, value)
    results = ""

    if isinstance(value, list):
        logging.debug("Parse %s as list", name)
        results = [f'{item}' if item.isnumeric() else f'"{item}"' for item in value]
        results = f"{name} = [ {', '.join(results)} ]"
    elif isinstance(value, dict):
        logging.debug("Parse %s as dict", name)
        results = [variable_to_terraform(key, value) for key, value in value.items()]
        results = f"{name} = {{ {', '.join(results)} }}"
    elif value is None:
        logging.warning("%s is none!", name)
    elif isinstance(value, int) or value.isnumeric() or value in ("true", "false", "null"):
        logging.debug("Parse %s without quotes", name)
        results = f'{name} = {value}'
    else:
        logging.debug("Parse %s as string", name)
        results = f'{name} = "{value}"'

    return results


# We don't need to have more public methods in these class too-few-public-methods
# pylint: disable=R0903
class TupleAction(argparse.Action):
    """
        Extend argaparse for tuple support
    """
    def __call__(self, parser, namespace, values, option_string=None):
        if not getattr(namespace, self.dest):
            setattr(namespace, self.dest, {})

        for value in values:
            key, value = value.split('=')
            getattr(namespace, self.dest)[key] = value


def validate_environment():
    """Check if current Python interpreter is supported by launcher."""
    if sys.version_info < MIN_PYTHON_VERSION:
        logging.error(ErrorMessage.python_version_error())
        sys.exit(EXIT_CODE)


def extract_tf_variables(base_dir, terraform_provider_directory):
    """
    Return list of possible variable for terraform based on auto-generated file benchmark_settings.txt.
    """
    os.chdir(f"{os.path.abspath(base_dir)}/terraform")

    settings_file = f"{terraform_provider_directory}/benchmark_settings.txt"
    logging.info("Use settings file %s", settings_file)

    try:
        with open(settings_file) as file:
            tf_vars = [re.split(r'\.| ', line)[1] for line in file.readlines() if "input." in line] # lines like: input.xxx (yyy)
    except IOError as error:
        logging.error(ErrorMessage.file_error(error.strerror, os.path.basename(file)))
        sys.exit(EXIT_CODE)

    logging.debug("Dump extracted terraform variables")
    logging.debug(tf_vars)

    os.chdir(f"{os.path.abspath(base_dir)}")

    return tf_vars

def get_compiled_utf8_regex():

    """
    Returns compiled regex for UTF8 validaton to throw out
    non-printable, malformed and overlong codepoints.
    """

    utf8_regex = """
      (
       [\x09\x0A\x0D\x20-\x7E]            # ASCII
     | [\xC2-\xDF][\x80-\xBF]             # non-overlong 2-byte
     |  \xE0[\xA0-\xBF][\x80-\xBF]        # excluding overlongs
     | [\xE1-\xEC\xEE\xEF][\x80-\xBF]{2}  # straight 3-byte
     |  \xED[\x80-\x9F][\x80-\xBF]        # excluding surrogates
     |  \xF0[\x90-\xBF][\x80-\xBF]{2}     # planes 1-3
     | [\xF1-\xF3][\x80-\xBF]{3}          # planes 4-15
     |  \xF4[\x80-\x8F][\x80-\xBF]{2}     # plane 16
       )*
    """

    return re.compile(utf8_regex, re.X)

def validate_value_for_utf8(compiled_regex, value):

    """
    Returns true if string does not contain improper UTF8 characters or is empty.
    """

    match = compiled_regex.fullmatch(value)

    logging.debug("Match object is: %s", str(match))

    return (match is not None and match.lastindex is not None) or value == ""

def parse_args():
    """Parse commandline arguments with argparse"""
    logging.info("Parse commandline arguments.")

    parser = argparse.ArgumentParser()
    parser.add_argument("--extra_vars", nargs="*", action=TupleAction, help="Key-value pair")
    parser.add_argument("-v", "--verbosity", type=int, choices=[0, 1], default=1, help="Verbosity level")
    parser.add_argument("-a", "--auth_method", type=str, choices = ["cli", "sp", "azure_cli", "service_principal"], default="sp", help="Method of authentication with CSP. Currently supported only on Azure provider.")
    parser.add_argument("--log_level", "-ll", type=str, choices=["INFO", "DEBUG"], default="INFO", help="Python launcher logging level")
    parser.add_argument("--base_dir", "-bd", type=str, default=None, help="Specify base directory where launcher should use")
    parser.add_argument("--accept_all_licenses", action="store_true", help="Accept all licenses. By using this option, you hereby agree that you read and accepted all licenses used in these project.")
    parser.add_argument("--provider", "-p", help="Specify cloud provider where create infrastructure", choices=["azure", "aws"], default="azure", type=str)
    parser.add_argument("--config_only", action="store_true", help="Generate only configs, without running commands.")
    parser.add_argument("--benchmark", "-b", help="Specify benchmark type for selected type of workload", choices=["hammerdb"], default="hammerdb", type=str)
    parser.add_argument("type", help="Type of workload - mssql, mysql or oracle", choices=["mssql", "mysql", "oracle"], type=str)
    parser.add_argument("custom_profile", nargs="?", default="", help="Scenario type - set only if performing 'test'")
    parser.add_argument("cmd", help="Command to perform - prepare, destroy, perform, test, export, mitigation, postconfigure", choices=["prepare", "destroy", "perform", "test", "export", "mitigation", "postconfigure"], type=str)

    args = parser.parse_args()
    logging.getLogger().setLevel(args.log_level)

    return parser, args


def extract_extra_variables(args):
    """Parse extra arguments to python variables."""
    extracted_variables = {}

    utf8_regex = get_compiled_utf8_regex()

    if args.extra_vars is None:
        logging.warning("No extra_vars passed.")
        return extracted_variables

    for key, value in args.extra_vars.items():

        try:
            if not validate_value_for_utf8(utf8_regex, value):
                raise ValueError(ErrorMessage.wrong_unicode_error(key))
        except ValueError as err:
            logging.error(err)
            sys.exit(EXIT_CODE)

        if value.isnumeric():
            logging.debug("Parse %s as number", key)
            extracted_variables[key] = int(value)
        elif key in ['global_tags', 'vm_tags']:
            logging.debug("Parse %s as dict", key)
            keys = value.split(':')[::2]
            values = value.split(':')[1::2]

            if not len(keys) == len(values):
                logging.warning("Found wrongly formatted %s, using empty %s", key, key)
                continue

            extracted_variables[key] = dict(zip(keys, values))
        elif key in ['ssh_allowed_ips', 'rdp_allowed_ips']:
            logging.debug("Parse %s as list", key)
            # var for var in [...] if var should remove empty strings
            extracted_variables[key] = [var for var in value.split(':') if var]
        elif ',' in value:
            logging.debug("Parse %s as list", key)
            extracted_variables[key] = list(map(int, list(filter(lambda x: x, value.split(',')))))
        else:
            logging.debug("Parse %s as string", key)
            extracted_variables[key] = value if ',' not in value else value.split(',')

    return extracted_variables

def create_tfvars_file(tf_vars, path, variables):
    """Create terraform.tfvars in terraform directory base on all variables dictionary and terraform variables list."""
    logging.info("Create terraform.tfvars file.")
    terraform_variables = [variable_to_terraform(key, value) + '\n' for key, value in variables.items() if key in tf_vars]
    logging.debug("Dump terraform.tfvars")
    logging.debug(terraform_variables)
    old_umask = os.umask(0o137)

    try:
        with open(f"{path}/terraform.tfvars", "w") as file:
            file.writelines(terraform_variables)
    except IOError as error:
        logging.error(ErrorMessage.file_error(error.strerror, os.path.basename(file)))

        sys.exit(EXIT_CODE)

    os.umask(old_umask)

@print_exec_time
def terraform_init(base_dir, workload_dir, verbosity):
    """Call terraform init command in terraform directory."""
    os.chdir(f"{base_dir}/terraform")
    logging.info('Command to perform: terraform init')

    with subprocess.Popen(('terraform', f'-chdir={workload_dir}', 'init'), text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE) as tf_init_p:

        while tf_init_p.poll() is None:
            if verbosity == 1:
                logging.info(tf_init_p.stdout.readline())

        if verbosity == 1:
            logging.info(tf_init_p.stdout.read())
            logging.info(tf_init_p.stderr.read())

        logging.info('Terraform has been initialized!')

        if tf_init_p.poll() != 0:
            logging.error(tf_init_p.stderr.read())
            logging.error(ErrorMessage.process_error(tf_init_p.poll()))
            sys.exit(EXIT_CODE)

    os.chdir(f"{base_dir}")

@print_exec_time
def terraform_apply(base_dir, workload_dir, tfvars_file, verbosity, custom_profile):
    """Call terraform apply command in terraform directory."""
    if custom_profile != "":
        custom_scenario_tfvars_file = f"-var-file={base_dir}/terraform/vars_{custom_profile}.tfvars"
    else:
        custom_scenario_tfvars_file = ""
    os.chdir(f"{base_dir}/terraform")

    logging.info("Command to perform: terraform apply -auto-approve")
    logging.info('Started provisioning infrastructure!')

    start_ts = time.time()

    with subprocess.Popen(('terraform', f'-chdir={workload_dir}', 'apply', '-auto-approve', f'-var-file={tfvars_file}', custom_scenario_tfvars_file), text=True, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE) as tf_apply_p:
        while tf_apply_p.poll() is None:
            log = tf_apply_p.stdout.readline()

            if verbosity == 1:
                logging.info(log)
            else:
                if "Still creating" in log and time.time() - start_ts > 15:
                    start_ts = time.time()
                    resource = log.split(':')[0]
                    resource = '.'.join(resource.split('.')[4:])
                    logging.info("Still creating %s...", resource)
                elif "Creating" in log:
                    resource = log.split(':')[0]
                    resource = '.'.join(resource.split('.')[4:])
                    logging.info("Started creation of %s", resource)
        if verbosity == 1:
            logging.info(tf_apply_p.stdout.read())
        if tf_apply_p.poll() != 0:
            logging.error(tf_apply_p.stderr.read())
            logging.error(ErrorMessage.process_error(tf_apply_p.poll()))
            sys.exit(EXIT_CODE)

    os.chdir(f"{os.path.abspath(base_dir)}")

@print_exec_time
def destroy_terraform(base_dir, workload_dir, tfvars_file, verbosity):
    """Call terraform destroy command in terraform directory."""
    os.chdir(f"{base_dir}/terraform")

    logging.info("Command to perform: terraform destroy -auto-approve")
    logging.info('Started destroying infrastructure!')

    start_ts = time.time()
    with subprocess.Popen(('terraform', f'-chdir={workload_dir}', 'destroy', '-auto-approve', f'-var-file={tfvars_file}'), text=True, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE) as tf_destroy_p:

        while tf_destroy_p.poll() is None:
            log = tf_destroy_p.stdout.readline()

            if verbosity == 1:
                logging.info(log)
            else:
                if "Still destroying" in log and time.time() - start_ts > 15:
                    start_ts = time.time()
                    resource = log.split(':')[0]
                    resource = '.'.join(resource.split('.')[4:])
                    logging.info("Still destroying %s...", resource)
                elif "Destroying" in log:
                    resource = log.split(':')[0]
                    resource = '.'.join(resource.split('.')[4:])
                    logging.info("Started destroying %s", resource)

        if verbosity == 1:
            logging.info(tf_destroy_p.stdout.read())

        if tf_destroy_p.poll() != 0:
            logging.error(tf_destroy_p.stderr.read())
            logging.error(ErrorMessage.process_error(tf_destroy_p.poll()))
            sys.exit(EXIT_CODE)

    os.chdir(os.path.abspath(base_dir))


def remove_temporary_files(base_dir):
    """Remove all temporary files containing confidential or integral data."""
    for file_path in TEMPORARY_FILES:
        full_file_path = os.path.join(base_dir, file_path)
        try:
            if os.path.isdir(full_file_path):
                shutil.rmtree(full_file_path)
            elif os.path.isfile(full_file_path):
                os.remove(full_file_path)
        except OSError as err:
            logging.error(err)

    logging.info("All temporary files were removed!")


def prepare_profile_yaml(base_dir, ansible_package_directory, variables, scenario_variables, scenario_validation=True):
    """Generate ansible variables to profile.yaml file, based on all variables dict and scenario_variables list names."""
    os.chdir(ansible_package_directory)

    var_dict = scenario_variables.copy()

    if scenario_validation:
        for name, value in variables.items():
            if name in scenario_variables.keys():
                var_dict[name] = value

    old_umask = os.umask(0o137)

    with open('profile.yaml', 'w') as file:
        logging.debug("Dump profile.yaml settings")
        logging.debug(var_dict)
        yaml.dump(var_dict, file, default_flow_style=False)

    os.umask(old_umask)

    logging.info("profile.yaml prepared!")
    os.chdir(f"{base_dir}")


def validate_profile_yaml(profile_path="profile.yaml", schema_path="profile_schema_mssql.yaml"):
    """Validate profile.yaml file using schema file profile_schema.yaml."""

    with open(schema_path, 'r') as file:
        yaml_schema = yaml.safe_load(file)

    with open(profile_path, 'r') as file:
        yaml_profile = yaml.safe_load(file)

    validation = Validator(yaml_schema)
    validation_result = validation.validate(yaml_profile)

    if not validation_result:
        logging.error(ErrorMessage.yaml_error())
        sys.exit(EXIT_CODE)


def accept_licenses(license_dir):
    """Print custom third party licenses from license_dir directory and ask user to accept. Return true if user accept, otherwise false """
    try:
        licenses_files = os.listdir(license_dir)
        logging.debug("Detected licenses: %s", ", ".join(licenses_files))

        if not licenses_files:
            raise ValueError("No licenses detected in licenses directory")
    except (ValueError, FileNotFoundError):
        logging.error(ErrorMessage.license_not_found_error())
        sys.exit(EXIT_CODE)

    for filename in licenses_files:
        with open(os.path.join(license_dir, filename), 'r') as file:
            logging.info("License for %s", Path(filename).stem)
            print(file.read())
            accept = input("Do you agree with license terms? (Y/YES to accept; Any other to disagree and exit) ")

            if accept.upper() not in ["YES", "Y"]:
                return False

    logging.info("All licenses accepted by user")

    return True


def contains_ansible_keywords(log):
    """Check if log contains all ansible keywords"""
    keywords = ["ok:", "changed:", "skipped:", "fatal:", "PLAY", "include_vars", "Gathering Facts"]

    return all(key in log for key in keywords)

@print_exec_time
def run_ansible(base_dir, ansible_package_directory, target, tags="", verbosity=0):
    """Run Ansible command in ansible directory."""
    os.chdir(ansible_package_directory)
    tags = f"-t {tags} " if tags else ""
    ansible_cmd = f"ansible-playbook -i inv.ini {tags}{target}"
    logging.info("Command to perform: %s", ansible_cmd)

    start_ts = time.time()
    prev_log = ""

    with subprocess.Popen(ansible_cmd.split(' '), text=True, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE) as ansible_p:
        while ansible_p.poll() is None:
            log = ansible_p.stdout.readline()

            if verbosity == 1:
                if log not in ('\n', '', ' '):
                    logging.info(log)
            else:
                if prev_log == log:
                    pass
                elif "RETRYING: Wait for schema building" in log and time.time() - start_ts > 60:
                    start_ts = time.time()
                    logging.info("Still building schema")
                elif not contains_ansible_keywords(log):
                    if '[' in log and ']' in log:
                        log_ = log[log.index('[') + 1:log.index(']')]
                        logging.info(log_)
                        prev_log = log

        if verbosity == 1:
            logging.info(ansible_p.stdout.read())
        if ansible_p.poll() != 0:
            logging.error(ansible_p.stderr.read())
            logging.error(ErrorMessage.process_error(ansible_p.poll()))
            sys.exit(EXIT_CODE)

    os.chdir(f"{base_dir}")

def prepare_paths_dict(args, base_dir=None):
    """Prepare dictionary with paths to different parts of project"""
    paths = {}
    # move .terraform path to terraform/.terraform when using chdir simultaneously
    paths['base_dir'] = base_dir if base_dir else os.getcwd()

    os.environ["TF_DATA_DIR"] = f"{base_dir}/terraform/.terraform"
    os.environ["TF_IN_AUTOMATION"] = "true"
    os.environ["TF_INPUT"] = "false"
    paths['ansible_packages'] = f"{base_dir}/packages"
    paths['terraform_main'] = f"{base_dir}/terraform"
    # Please do not override terraform_provider- it is used to override source parameter via copying
    paths['terraform_provider'] = f"{paths['terraform_main']}/workloads/{args.provider}-{args.type}"
    paths['terraform_common'] = f"{paths['terraform_main']}/workloads/common"
    paths['tfvars_file'] = f"{base_dir}/terraform/terraform.tfvars"

    return paths

def main():
    """Main function"""
    logging.basicConfig(format='%(asctime)s %(levelname)s - %(message)s', level=logging.INFO)

    validate_environment()

    _, args = parse_args()

    if not (args.accept_all_licenses or accept_licenses("licenses")):
        logging.info("Not all licenses were accepted, exiting")
        return

    extra_variables = {'scenario' : args.type}

    if args.extra_vars:
        extra_variables.update(extract_extra_variables(args))
    else:
        logging.warning("No extra_vars passed.")

    extra_variables['base_dir'] = args.base_dir if args.base_dir else os.getcwd()

    if args.cmd == "test":
        extra_variables['provider'] = args.custom_profile.split('_')[0]
    else:
        extra_variables['provider'] = args.provider

    commands = {
        "prepare": PrepareCommand,
        "destroy" : DestroyCommand,
        'perform' : PerformCommand,
        'export' : ExportCommand,
        'test' : TestCommand,
        'mitigation' : MitigationCommand,
        'postconfigure': PostConfigCommand
    }

    executioner = None

    try:
        executioner = commands[args.cmd](args.type, base_dir=args.base_dir)
    except KeyError:
        logging.error(ErrorMessage.unsupported_action_error(args.cmd))
        return

    base_dir = args.base_dir if args.base_dir else os.getcwd()
    paths = prepare_paths_dict(args, base_dir)

    executioner.prepare(paths, extra_variables)
    if not args.config_only:
        executioner.run(paths, args.custom_profile, args.verbosity, extra_variables)

# Decorate built in open function to forbid symlink usage
# pylint: disable=W0622
open = symlink_check(open)

if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        logging.info("The application has been manually closed by user (CTRL-C).")
        sys.exit(EXIT_CODE)
    except (SystemExit, Exception) as exception: # pylint: disable=broad-except
        logging.error(ErrorMessage.undefined_error())
        logging.debug(exception, exc_info=True)
        sys.exit(EXIT_CODE)
