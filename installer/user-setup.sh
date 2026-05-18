#!/usr/bin/env bash
set -e

clear
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}=========================================="
echo "         LarxOS System Configuration      "
echo -e "==========================================${NC}"
echo ""

# Get the machine name
while true; do
    read -p "Enter a hostname for this computer (e.g., larxos-pc): " HOSTNAME
    if [[ -z "$HOSTNAME" ]]; then
        echo -e "${RED}Hostname cannot be empty.${NC}"
    else
        break
    fi
done

# Set up the new user
while true; do
    read -p "Enter your new username (lowercase only): " NEW_USERNAME
    if [[ ! "$NEW_USERNAME" =~ ^[a-z_][a-z0-9_-]*$ ]]; then
        echo -e "${RED}Invalid username. Use lowercase letters, numbers, or underscores.${NC}"
    else
        break
    fi
done

# Ask if this user should be an admin (sudo)
while true; do
    read -p "Should '$NEW_USERNAME' have sudo (admin) privileges? [y/n]: " sudo_choice
    case $sudo_choice in
        [Yy]*)
            MAKE_SUDO="true"
            break
            ;;
        [Nn]*)
            MAKE_SUDO="false"
            break
            ;;
        *)
            echo -e "${RED}Please answer y or n.${NC}"
            ;;
    esac
done

echo ""
echo -e "${YELLOW}--- Password Configurations ---${NC}"

# Password for the root user
while true; do
    read -s -p "Enter password for the ROOT user: " ROOT_PASS
    echo ""
    read -s -p "Confirm password for the ROOT user: " ROOT_PASS_CONFIRM
    echo ""
    if [ "$ROOT_PASS" != "$ROOT_PASS_CONFIRM" ]; then
        echo -e "${RED}Passwords do not match. Try again.${NC}"
    elif [[ -z "$ROOT_PASS" ]]; then
        echo -e "${RED}Password cannot be empty.${NC}"
    else
        break
    fi
done

# Password for the normal user
while true; do
    read -s -p "Enter password for user '$NEW_USERNAME': " USER_PASS
    echo ""
    read -s -p "Confirm password for user '$NEW_USERNAME': " USER_PASS_CONFIRM
    echo ""
    if [ "$USER_PASS" != "$USER_PASS_CONFIRM" ]; then
        echo -e "${RED}Passwords do not match. Try again.${NC}"
    elif [[ -z "$USER_PASS" ]]; then
        echo -e "${RED}Password cannot be empty.${NC}"
    else
        break
    fi
done

# Show available drives so the user knows what to type
clear
echo -e "${CYAN}=========================================="
echo "         LarxOS Disk Configuration        "
echo -e "==========================================${NC}"
echo ""
echo "Available storage drives:"
echo "------------------------------------------"
lsblk -d -n -o NAME,SIZE,MODEL
echo "------------------------------------------"
echo ""

# Target drive selection
while true; do
    read -p "Enter the target drive name (e.g., sda, nvme0n1): " TARGET_DRIVE
    if [ -b "/dev/$TARGET_DRIVE" ]; then
        break
    else
        echo -e "${RED}Drive '/dev/$TARGET_DRIVE' not found. Please type a valid drive name.${NC}"
    fi
done

# Pass these answers over to the installer script later
export HOSTNAME NEW_USERNAME MAKE_SUDO ROOT_PASS USER_PASS TARGET_DRIVE

echo ""
echo -e "${YELLOW}Configuration saved!${NC}"
echo "Hostname:   $HOSTNAME"
echo "Username:   $NEW_USERNAME"
echo "Sudo Admin: $MAKE_SUDO"
echo "Target:     /dev/$TARGET_DRIVE"
echo ""
read -p "Press [Enter] to launch the disk partitioner..."

# Open up cfdisk so the user can easily format the drive with a UI
cfdisk "/dev/$TARGET_DRIVE"

# Run the installer script now that setup is done
./main-install.sh
