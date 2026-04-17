packer {
  required_plugins {
    proxmox = {
      version = "~> 1"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

# -------------------------
# Variables
# -------------------------

variable "proxmox_url" {
  type = string
}

variable "proxmox_username" {
  type = string
}

variable "proxmox_password" {
  type      = string
  sensitive = true
}

variable "node" {
  type    = string
  default = "pve"
}

variable "vm_id" {
  type    = number
  default = 9000
}

variable "template_name" {
  type    = string
  default = "rhel-template-v1"
}

variable "iso_file" {
  type = string
  # Example: local:iso/rhel-9.3-x86_64-dvd.iso
}

variable "storage_pool" {
  type    = string
  default = "local-lvm"
}

variable "network_bridge" {
  type    = string
  default = "vmbr0"
}

variable "ssh_username" {
  type    = string
  default = "root"
}

variable "ssh_password" {
  type      = string
  sensitive = true
}

# -------------------------
# Source: Proxmox ISO
# -------------------------

source "proxmox-iso" "rhel" {
  proxmox_url              = var.proxmox_url
  username                 = var.proxmox_username
  password                 = var.proxmox_password
  insecure_skip_tls_verify = true

  node                 = var.node
  vm_id                = var.vm_id
  vm_name              = var.template_name
  template_description = "RHEL Template with cloud-init"

  # ISO
  boot_iso {
    type = "ide"
    iso_file         = var.iso_file
    unmount = true
  }

  additional_iso_files {
    type = "ide"
    iso_file = "local:iso/oemdrv.iso"
  }

  # VM hardware
  cores   = 2
  sockets = 1
  memory  = 2048
  cpu_type = "x86_64-v3"

  scsi_controller = "virtio-scsi-pci"

  disks {
    type         = "scsi"
    disk_size    = "32G"
    storage_pool = var.storage_pool
  }

  network_adapters {
    model  = "virtio"
    bridge = var.network_bridge
    vlan_tag = 202
  }

  # Boot automation (Kickstart)
  boot_command = [
  "<down><wait5s><enter>",
  "<wait9m>",
  "<tab><enter>"
  ]
  boot_wait = "5s"

  # SSH
  ssh_username = var.ssh_username
  ssh_password = var.ssh_password
  ssh_timeout  = "20m"

  # Cloud-init support
  cloud_init              = true
  cloud_init_storage_pool = var.storage_pool

  # Convert to template
  # template = true

  # QEMU agent
  qemu_agent = true
}

# -------------------------
# Build Block
# -------------------------

build {
  name    = "rhel-proxmox-template"
  sources = ["source.proxmox-iso.rhel"]

  provisioner "shell" {
    script = "scripts/post.sh"
  }
}
