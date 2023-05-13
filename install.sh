#!/bin/sh

# roles
ansible-galaxy install \
    gantsign.visual-studio-code \
    ivansible.lin_nxserver \
    geerlingguy.docker

ansible-playbook \
      -i hosts.yml \
      ./playbooks/env.yml \
      ./playbooks/virtual.yml \
      ./playbooks/editors.yml \
      ./playbooks/containers.yml \
      ./playbooks/developer.yml \
      ./playbooks/dev-nodejs.yml \
      ./playbooks/comms.yml \
      ./playbooks/browsers.yml

# # one off
# ansible-playbook \
#   -i hosts.yml \
#     ./playbooks/dev-nodejs.yml \
