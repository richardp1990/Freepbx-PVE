#!/bin/bash

# --- Settings ---
VMID=110
VMNAME="FreePBX"
ISO_URL="https://downloads.freepbxdistro.org/ISO/SNG7-PBX16-64bit-2302-1.iso"
ISO_NAME="FreePBX-16.iso"
STORAGE="local-zfs"  # Change to your preferred storage
BRIDGE="vmbr0"       # Change to your network bridge
CORES=2
RAM=4096
DISK=32              # GB

# --- Step 1: Download ISO if not present ---
ISO_PATH="/var/lib/vz/template/iso/${ISO_NAME}"
if [ ! -f "$ISO_PATH" ]; then
    echo "Downloading FreePBX ISO..."
    wget -O "$ISO_PATH" "$ISO_URL"
else
    echo "FreePBX ISO already exists."
fi

# --- Step 2: Create VM ---
echo "Creating VM $VMID..."
qm create $VMID --name $VMNAME --memory $RAM --cores $CORES --net0 virtio,bridge=$BRIDGE --ostype l26

# --- Step 3: Add ISO and disk ---
echo "Setting up disk and ISO..."
qm set $VMID --cdrom "local:iso/${ISO_NAME}"
qm set $VMID --scsihw virtio-scsi-pci --scsi0 ${STORAGE}:$DISK
qm set $VMID --boot order=cdrom --bootdisk scsi0
qm set $VMID --serial0 socket --vga serial0

# --- Step 4: Start the VM ---
echo "Starting VM..."
qm start $VMID

echo "FreePBX VM $VMID has been created and started. Use Proxmox Web UI or 'qm monitor $VMID' to install FreePBX manually."
