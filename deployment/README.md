# Deploying Firebrick to a server

This directory provides ansible playbooks to deploy and update Firebrick on a server of your choice. Continue reading for instructions.

## Install Ansible

```
pip install ansible
```
> You might have to use sudo to get this to run properly

## Assumptions

* You have a remote server
* You can SSH into the remote server as `root` user with your SSH key located at `~/.ssh/id_rsa` or `~/.ssh/id_dsa`
* You have this `deployment` directory as your working directory

## Usage

### Setup an inventory file

Edit the text file called `inventory` in this directory and replace the example IP addresses with your own. Add one IP per line.

### Setup/Update

Assuming the path to the inventory file is `/foo/bar/inventory`

* To setup: `ansible-playbook setup.yml`
* To update: `ansible-playbook update.yml`

### Setup the following DNS records

When adding records, replace:

* 1.2.3.4 with your own IP address
* example.com with your own domain/subdomain

Type | Name        | Value
-----|-------------|---------
A    | example.com | 1.2.3.4

Type | Value      | Priority
-----|------------|---------
MX   | 1.2.3.4    | 10


DONE ~!

-----

## Advanced usage

* Pass the option `--private-key=./path/to/ssh-private-key` if your private key is not at `~/.ssh/id_rsa` or `~/.ssh/id_dsa`
* **For those familiar with Ansible:** If you have a group of servers in your Ansible inventory file, you can pass an Ansible group name for the `target` variable for the `setup` or `deploy` playbooks.
