# docap-ansible

There is an Ansible playbook called `provision.yml` that can be used to install the Dev Ops Culture and Practice course tools onto a VM.

Two types of machine are supported:
  - Ubuntu based VM
  - Amazon Linux running in an "AWS Workspace"

The playbook is smart enough to run the correct command for the desired machine type.

You need to have Ansible installed.  The easiest way is via the pip (python) package manager:

```sh
# First we need to install ansible:
sudo pip install ansible --upgrade

# Then run this playbook:
ansible-playbook provision.yml
```

The default versions of the tools to install can be found in `roles/docap/defaults/main.yml`.
