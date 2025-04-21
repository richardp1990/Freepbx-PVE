# FreePBX Proxmox VM Installer

This script automates the creation of a FreePBX virtual machine (VM) on a Proxmox VE host. It downloads the latest FreePBX ISO, sets up the VM with recommended specs, and boots it up—ready for manual or future automated installation.

---

## ✅ Features

- Downloads the latest FreePBX 17 ISO
- Creates a VM on Proxmox using `qm`
- Allocates 4GB RAM, 2 vCPUs, 32GB storage (customizable)
- Attaches ISO and sets boot order
- Starts the VM for manual installation

---

## 🚀 Quick Install (Run from Proxmox Host)

```bash
bash <(curl -s https://raw.githubusercontent.com/richardp1990/Freepbx-PVE/refs/heads/main/freepbx-proxmox-installer.sh)


🔧 Configuration
You can edit the following variables in the script to suit your environment:

bash
Copy
Edit
VMID=110               # Unique Proxmox VM ID
VMNAME="FreePBX"       # VM Name
STORAGE="local-lvm"    # Storage location for VM disk
BRIDGE="vmbr0"         # Network bridge interface
CORES=2                # Number of vCPUs
RAM=4096               # RAM in MB
DISK=32                # Disk size in GB


📦 Output
Once completed, the VM will appear in your Proxmox Web UI and be running, ready for FreePBX installation via the console or web installer.

📌 Notes
Script assumes you have internet access on your Proxmox host.

FreePBX installation inside the VM is not automated in this version.

Intended for lab/testing or internal PBX use.

🛠 Future Improvements (Planned)
Cloud-init support

Post-install auto-configuration

Network/static IP setup

ISO version selector
