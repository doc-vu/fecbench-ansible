#!/bin/env bash
mkdir -p $PWD/roles_ext
ansible-galaxy install -c -r requirements.yml -p ./roles_ext
