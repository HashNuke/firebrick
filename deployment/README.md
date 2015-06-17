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

## Setup/update Firebrick

Replace `1.2.3.4` in the following with your server's IP address

* To setup: `ansible-playbook setup.yml --extra-vars="target=1.2.3.4"`
* To update: `ansible-playbook update.yml --extra-vars="target=1.2.3.4"`

### Setup DNS records

TODO MX record to handle mail
TODO A/CNAME record for app

DONE ~!

-----

## Advanced usage

* TODO path to custom ssh key
* **For those familiar with Ansible:** If you have a group of servers in your Ansible inventory file, you can pass an Ansible group name for the `target` variable for the `setup` or `deploy` playbooks.
