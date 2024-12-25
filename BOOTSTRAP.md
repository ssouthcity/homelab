
# Bootstrapping

## Flash Raspian

Use rpi-imager to install raspbian lite 64-bit onto the Raspberry pi.

Before ejecting the sd card, mount it to a directory and cd into said directory. Find the cmdline.txt file and update it's contents by appending the following snippet:

```
ip=<ip>::<default gateway>:<dns mask>:rpi:eth0:off
```

## Install K3S

Navigate to k3s-ansible, fill in the inventory.yml file and run

```
ansible-playbook playbooks/site.yml
```
