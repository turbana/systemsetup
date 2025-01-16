#!/bin/env bash

password_file=$(dirname $0)/../.ian.passwd

if [[ "$#" -eq "0" ]]; then
    echo "USAGE: $(basename $0) host command container-1 [container-n ...]"
    exit 2
fi

host=$1
shift
command=$1
shift

while [[ "$#" -gt "0" ]]; do
    container=$1
    shift
    cat $password_file | ssh $host "sudo -p '' -S $command $container"
done
