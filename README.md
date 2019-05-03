# docker Image for ansible-vmware-netapp lib
Docker Image with Python lib for VMware and netapp



you can test the basic function from ansible for Vmware / netapp

### Prerequisites
you need a ansible config file white the minimum parameter

ansible.cfg
```
[inventory]
enable_plugins = vmware_vm_inventory,host_list, script, yaml, ini, auto

```
### command call
```
docker run -it --rm \
    --name ansible \
    -v $PWD:/work \
    -v $HOME/.docker-ansible/etc:/etc/ansible \
    thesolution/ansible \
    ansible-playbook \
    playbook.yaml

```
example for netapp playbook.yaml
this make a 10 GB Volume on the netapp cluster
```
---
- hosts: localhost
  name: Volume Action
  vars:
    hostname: IP adress
    username: admin
    password: highsecurepassword
    vserver: svm-unix
    aggr: sb_sandbox_1_01_FC_1
    vol_name: ansibleVol
  tasks:
  - name: Volume Create
    na_ontap_volume:
      state: present
      name: "{{ vol_name }}"
      vserver: "{{ vserver }}"
      aggregate_name: "{{ aggr }}"
      size: 10
      size_unit: gb
      policy: default
      junction_path: "/{{ vol_name }}"
      hostname: "{{ hostname }}"
      username: "{{ username }}"
      password: "{{ password }}"
      https: true
      validate_certs: false
```
or
VMware exampel: VMware dynamic inventory
```
docker run -it --rm \
    --name ansible \
    -v $PWD:/work \
    -v $HOME/.docker-ansible/etc:/etc/ansible \
    thesolution/ansible \
    ansible-inventory --list -i \
    vmware.yaml

```

a example for vmware.yaml
```
plugin: vmware_vm_inventory
strict: False
hostname: vcenter
username: administrator@vsphere.local
password: highsecurepassword
validate_certs: False
with_tags: True
```
