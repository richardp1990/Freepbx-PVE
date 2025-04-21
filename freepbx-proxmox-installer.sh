#!/bin/bash

# --- Config ---
VMID=111
VMNAME="FreePBX"
ISO_URL="https://downloads.freepbxdistro.org/ISO/SNG7-PBX16-64bit-2306-1.iso"
ISO_NAME="FreePBX-17.0.2.iso"
STORAGE="home-c1"
BRIDGE="vmbr0"
CORES=2
RAM=4096
DISK=32

# --- Kickstart Config ---
KS_URL="https://raw.githubusercontent.com/richardp1990/Freepbx-PVE/refs/heads/main/ks.cfg"

# --- Paths ---
ISO_PATH="/var/lib/vz/template/iso/${ISO_NAME}"

# --- Step 1: Download FreePBX ISO ---
if [ ! -f "$ISO_PATH" ]; then
    echo "Downloading FreePBX ISO..."
    wget -O "$ISO_PATH" "$ISO_URL"
else
    echo "ISO already downloaded: $ISO_PATH"
fi

# --- Step 2: Create VM ---
echo "Creating VM $VMID..."
qm create $VMID \
    --name $VMNAME \
    --memory $RAM \
    --cores $CORES \
    --net0 virtio,bridge=$BRIDGE \
    --ostype l26

# --- Step 3: Attach ISO and disk ---
echo "Configuring VM $VMID..."
qm set $VMID --cdrom "local:iso/${ISO_NAME}"
qm set $VMID --scsihw virtio-scsi-pci --scsi0 ${STORAGE}:$DISK
qm set $VMID --boot order=cdrom --bootdisk scsi0
qm set $VMID --serial0 socket --vga serial0

# --- Step 4: Enable auto-install using Kickstart ---
echo "Configuring automatic install with Kickstart..."
qm set $VMID --args "-append 'inst.ks=${KS_URL} console=ttyS0,115200n8 serial'"

# --- Step 5: Start VM ---
echo "Starting VM $VMID..."
qm start $VMID

echo "✅ FreePBX VM $VMID created and installation is now automated using Kickstart."
