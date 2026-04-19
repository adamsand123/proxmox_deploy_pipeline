# Terraform

Create terraform user and permission in proxmox

```sh
pveum role add TerraformProv -privs "Datastore.AllocateSpace Datastore.AllocateTemplate Datastore.Audit Pool.Allocate Pool.Audit Sys.Audit Sys.Console Sys.Modify VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.Cloudinit VM.Config.CPU VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Migrate VM.PowerMgmt SDN.Use"
pveum aclmod / -user terraform-prov@pve -role TerraformProv
pveum user token add terraform-prov@pve mytoken
```

Create API token 

Deklarera variabler i: `variables.tf`.

```sh
variable "PM_USER" {
  type = string
  description = "proxmox terraform user account"
} 
variable "PM_PASS" {
  type = string
  description = "proxmox terraform user password"
} 
variable "PM_URL" {
  type = string
  description = "proxmox url with suffix /api2/json"
}
variable "PM_node" {
  type = string
  description = "proxmox node name"
}
variable "CI_user" {
  type = string
  description = "user account to configure on machine"
}
variable "CI_pass" {
  type = string
  description = "user account password to configure on machine"
}
```

Ge variabler värden i: `variables.auto.tfvars`

```sh
PM_USER = "terraform-prov"
PM_PASS = "{PVE_PASSWORD}"
PM_URL = "https://pve.home.arpa:8006/api2/json"
PM_node = "pve"
PM_template = "rhel-template-v1"
CI_user = "{VM_USER}"
CI_pass = "{VM_PASS}"

```

`main.tf` definerar globala inställningar för projektet.

```sh
terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = ">=2.9.6"
    }
  }
}

provider "proxmox" {
  pm_api_url = var.PM_URL
  pm_user    = var.PM_USER
  pm_password    = var.PM_PASS
}

/* Enable Debug Mode
provider "proxmox" {
  pm_debug = true
}
*/

/* Enable Logs 
provider "proxmox" {
  pm_log_enable = true
  pm_log_file   = "terraform-plugin-proxmox.log"
  pm_debug      = true
  pm_log_levels = {
    _default    = "debug"
    _capturelog = ""
  }
}
```

`[VMNAME].tf` definerar unika playbooks per maskin.
