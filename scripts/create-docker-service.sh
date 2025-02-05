#!/bin/env bash

set -e

SERVICES_ROOT=roles/docker-services

if [[ "$#" -ne "1" ]]; then
    echo "USAGE: $(basename $0) service-name"
    echo "Creates a new docker service named SERVICE-NAME."
    exit 2
fi

service=$1
template=$SERVICES_ROOT/templates/${service}.yml.j2

if [[ -f $template ]]; then
    echo "docker service '$service' already exists, skipping."
    exit 0
fi

cat >$template <<EOF
services:
  {{ container_name }}:
    image: CHANGEME:latest
    container_name: {{ container_name }}
    security_opt:
      - no-new-privileges:true
    restart: unless-stopped
    networks:
      - {{ container_net_name }}
    ports:
      - "127.0.0.1:{{ docker_service.port }}:{{ docker_service.port }}"
    environment:
      DOCKER_HOST: tcp://{{ container_sp_name }}:{{ socket_proxy_port }}
    volumes:
      - "{{ container_volume_root }}/config:/app/config"
    labels:
      - homepage.group=CHANGEME
      - homepage.name=CHANGEME
      - homepage.description=CHANGEME
      - homepage.href={{ docker_service.proxy.base | default("") }}
EOF
