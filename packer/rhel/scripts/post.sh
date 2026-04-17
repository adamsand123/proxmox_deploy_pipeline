#!/bin/bash
set -eux

sed -i 's/^enabled=1/enabled=0/' /etc/yum/pluginconf.d/subscription-manager.conf

mount /dev/sr0 /media

cat >/etc/yum.repos.d/local.repo <<EOL
[rhel-10-baseos]
name=RHEL 10 BaseOS
baseurl=file:///media/BaseOS
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release

[rhel-10-appstream]
name=RHEL 10 AppStream
baseurl=file:///media/AppStream
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release
EOL

rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release

dnf install -y cloud-init

systemctl enable cloud-init
systemctl enable cloud-init-local
systemctl enable cloud-config
systemctl enable cloud-final
