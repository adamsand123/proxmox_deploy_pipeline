#!/bin/bash
set -eux

# Clean machine ID
truncate -s 0 /etc/machine-id

# Clean logs
rm -rf /var/log/*

# Clean cloud-init
cloud-init clean

# Remove SSH host keys
rm -f /etc/ssh/ssh_host_*

# Clear history
history -c
