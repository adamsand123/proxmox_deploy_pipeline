resource "proxmox_vm_qemu" "ipa-01" {
  target_node         = var.PM_node
  name                = "ipa-01"
  vmid                = 206
  clone               = var.PM_template

  os_type             = "cloud-init"
  ciuser              = var.CI_user
  cipassword          = var.CI_pass
  nameserver          = "192.168.2.54"
  ipconfig0           = "ip=192.168.2.49/29,gw=192.168.2.54"

  agent               = 0
  start_at_node_boot  = true
  vm_state            = "running"

  bios                = "seabios"
  memory              = 4096
  cpu {
    cores             = 2
    sockets           = 1
    type              = "x86-64-v3"
  }

  network {
    id                = 0
    bridge            = "vmbr0"
    tag               = 206
    firewall          = false
    link_down         = false
    model             = "virtio"
  }

  startup_shutdown {
    order             = -1
    shutdown_timeout  = -1
    startup_delay     = -1
  }

  serial {
    id                = 0
  }

  boot                = "order=scsi0"
  scsihw              = "virtio-scsi-pci"
  disks {
    scsi {
      scsi0 {
        disk {
          storage     = "local-zfs"
          size        = "50G" 
        }
      }
    }
    ide {
      ide1 {
        cloudinit {
          storage     = "local-zfs"
        }
      }
    }
  }
}
