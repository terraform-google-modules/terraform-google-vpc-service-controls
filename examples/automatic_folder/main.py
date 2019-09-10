# -*- coding: utf-8 -*-

import os
import subprocess
import urllib.request
import os
from shutil import copytree, copyfile, ignore_patterns, rmtree

# Version of Terraform that we're using
TERRAFORM_VERSION = '0.12.8'

# Download URL for Terraform
TERRAFORM_DOWNLOAD_URL = (
    'https://releases.hashicorp.com/terraform/%s/terraform_%s_linux_amd64.zip'
    % (TERRAFORM_VERSION, TERRAFORM_VERSION))

# Paths where Terraform should be installed
TERRAFORM_DIR = os.path.join('/tmp', 'terraform_%s' % TERRAFORM_VERSION)
TERRAFORM_PATH = os.path.join(TERRAFORM_DIR, 'terraform')

PROJECT_DIR = os.path.join('/tmp', 'project')

def check_call(args, cwd=None, printOut=False):
    """Wrapper for subprocess that checks if a process runs correctly,
    and if not, prints stdout and stderr.
    """
    proc = subprocess.Popen(args,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        cwd=cwd)
    stdout, stderr = proc.communicate()
    if proc.returncode != 0:
        print(stdout)
        print(stderr)
        raise subprocess.CalledProcessError(
            returncode=proc.returncode,
            cmd=args)
    if printOut:
        print(stdout)
        print(stderr)


def install_terraform():
    """Install Terraform."""
    if os.path.exists(TERRAFORM_PATH):
        return

    urllib.request.urlretrieve(TERRAFORM_DOWNLOAD_URL, '/tmp/terraform.zip')

    check_call(['unzip', '-o', '/tmp/terraform.zip', '-d', TERRAFORM_DIR], '/tmp')

    check_call([TERRAFORM_PATH, '--version'])


def handler(event, context):
    print(event)

    if os.path.exists(PROJECT_DIR):
        rmtree(PROJECT_DIR)

    copytree('.', PROJECT_DIR, ignore=ignore_patterns('.terraform', 'provider.tf', 'credentials.json'))
    copyfile('provider.tf.dist', os.path.join(PROJECT_DIR, 'provider.tf'))

    install_terraform()

    check_call([TERRAFORM_PATH, 'init'],
                  cwd=PROJECT_DIR,
                  printOut=True)
    check_call([TERRAFORM_PATH, 'plan', '-no-color', '-var-file=local.tfvars', '-lock-timeout=300s', '-out', 'tfplan'],
                  cwd=PROJECT_DIR,
                  printOut=True)
    check_call([TERRAFORM_PATH, 'apply', '-no-color', '-auto-approve', '-lock-timeout=300s', 'tfplan'],
                  cwd=PROJECT_DIR,
                  printOut=True)
    check_call([TERRAFORM_PATH, 'output', '-json'],
                  cwd=PROJECT_DIR,
                  printOut=True)
