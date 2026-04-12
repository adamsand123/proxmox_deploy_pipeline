#!/bin/bash
set -eux

dnf install -y cloud-init

systemctl enable cloud-init
systemctl enable cloud-init-local
systemctl enable cloud-config
systemctl enable cloud-final
