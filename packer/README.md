# Run packer

[packer docs](packer/README.md)

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

# Terraform

[terraform docs](terraform/README.md)

Create terraform user and permission in proxmox

```sh
pveum role add TerraformProv -privs "Datastore.AllocateSpace Datastore.AllocateTemplate Datastore.Audit Pool.Allocate Pool.Audit Sys.Audit Sys.Console Sys.Modify VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.Cloudinit VM.Config.CPU VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Migrate VM.PowerMgmt SDN.Use"
pveum aclmod / -user terraform-prov@pve -role TerraformProv
pveum user token add terraform-prov@pve mytoken
```

Create API token 
