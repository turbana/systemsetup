#!/bin/env bash

set -e

if [[ "$#" -ne "1" ]]; then
    echo "USAGE: $(basename $0) role-name"
    echo "Creates a new ansible role called ROLE-NAME that represents a new "
    echo "docker services instance."
    exit 2
fi

role=$1
role_lower=$(echo $role | tr '-' '_')
cd $(dirname $0)/..

if [[ -d "roles/$role" ]]; then
    echo "ansible role '$role' already exists, skipping."
    exit 0
fi

mkdir -p roles/$role/{meta,tasks,vars}

cat >roles/$role/meta/main.yml <<EOF
dependencies:
  - role: docker-host
EOF

cat >roles/$role/vars/main.yml <<EOF
docker_site: $role

docker_services:
EOF

cat >roles/$role/tasks/main.yml <<EOF
- name: test task
  debug: msg="TODO setup $role tasks"
EOF

cat >playbook_deploy-${role}.yml <<EOF
- name: Deploy $role
  hosts: $role_lower
  become: true
  pre_tasks:
    - include_vars: secrets/${role_lower}.yml
  roles:
    - $role
    - docker-services
EOF

cat >>site.yml <<EOF
- import_playbook: playbook_deploy-${role}.yml
EOF

cat >secrets/${role_lower}.yml <<EOF
# ansible secrets for '$role'
EOF

echo "Added new ansible role '$role'"
