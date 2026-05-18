#!/usr/bin/env bash
set -e

clear
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}=========================================="
echo "         Formatting Target Partition      "
echo -e "==========================================${NC}"
echo ""

# Show the partitions that were just made in cfdisk
echo "Current layout for /dev/$TARGET_DRIVE:"
lsblk "/dev/$TARGET_DRIVE"
echo ""

# Ask which partition is which
while true; do
    read -p "Enter the number for the EFI/Boot partition (e.g., 1 if it is /dev/${TARGET_DRIVE}1): " boot_num
    BOOT_PART="/dev/${TARGET_DRIVE}${boot_num}"
    if [ -b "$BOOT_PART" ]; then break; fi
    echo -e "${RED}Partition $BOOT_PART does not exist. Check lsblk above.${NC}"
done

while true; do
    read -p "Enter the number for the Root (/) partition (e.g., 2 if it is /dev/${TARGET_DRIVE}2): " root_num
    ROOT_PART="/dev/${TARGET_DRIVE}${root_num}"
    if [ -b "$ROOT_PART" ]; then break; fi
    echo -e "${RED}Partition $ROOT_PART does not exist. Check lsblk above.${NC}"
done

echo ""
echo -e "${RED}WARNING: All data on $BOOT_PART and $ROOT_PART will be completely wiped!${NC}"
read -p "Press [Enter] to start formatting... or Ctrl+C to abort."

# Format the partitions
echo "Formatting boot partition ($BOOT_PART) as FAT32..."
mkfs.fat -F 32 "$BOOT_PART"

echo "Formatting root partition ($ROOT_PART) as EXT4..."
mkfs.ext4 -F "$ROOT_PART"

# Mount the partitions to the paths
echo "Mounting target filesystems..."
mount "$ROOT_PART" /mnt
mkdir -p /mnt/boot
mount "$BOOT_PART" /mnt/boot

echo -e "${YELLOW}Partitions safely formatted and mounted!${NC}"
sleep 2
