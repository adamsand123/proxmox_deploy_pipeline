# Run packer

init

```sh
cd packer/rhel && packer init .
```

Kör

```sh
cd packer/rhel && packer build -var-file=variables.pkrvars.hcl .
```

## Content packer variables.pkrvars.hcl

```ini
# packer/rhel/variables.pkrvars.hcl
proxmox_url      = "https://proxmox:8006/api2/json"
proxmox_username = "<PACKERUSER>@pve"
proxmox_password = "<PACKERPASS"

storage_pool = "local-zfs"
iso_file = "local:iso/rhel-10.1-x86_64-dvd.iso"

ssh_password = "<KS_ROOT_PASSWORD>"
```
