#!/usr/bin/bash

genisoimage -R -o oemdrv.iso -V OEMDRV packer/rhel/files/ks.cfg

scp oemdrv.iso root@192.168.2.1:/var/lib/vz/template/iso/oemdrv.iso

cd packer/rhel && packer build -var-file=variables.pkrvars.hcl .
