#!/usr/bin/env bash
set -e

echo "=========================================="
echo "      Deploying LarxOS Base Files         "
echo "=========================================="

# Install the base system and core apps
pacstrap -K /mnt base linux linux-firm base-devel alacritty fish git fastfetch

# Generate the partition map so the system knows how to mount itself on boot
genfstab -U /mnt >> /mnt/etc/fstab

# Apply the hostname
echo "$HOSTNAME" > /mnt/etc/hostname

echo "=========================================="
echo "       Setting Up User Accounts           "
echo "=========================================="

# Permissions
if [ "$MAKE_SUDO" == "true" ]; then
    echo "Configuring '$NEW_USERNAME' as an administrator..."
    arch-chroot /mnt useradd -m -G wheel,storage,power -s /usr/bin/fish "$NEW_USERNAME"
    
    sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /mnt/etc/sudoers
else
    echo "Configuring '$NEW_USERNAME' as a standard user..."
    arch-chroot /mnt useradd -m -G storage,power -s /usr/bin/fish "$NEW_USERNAME"
fi

arch-chroot /mnt chsh -s /usr/bin/fish root

# Passwords
echo "Applying passwords..."
echo "root:$ROOT_PASS" | arch-chroot /mnt chpasswd
echo "$NEW_USERNAME:$USER_PASS" | arch-chroot /mnt chpasswd

echo "=========================================="
echo "     Deploying Custom Configurations      "
echo "=========================================="

# Apply the dotfiles
mkdir -p "/mnt/home/$NEW_USERNAME/.config"
cp -r /usr/share/larxos/config/* "/mnt/home/$NEW_USERNAME/.config/"

# Change the ownership of the dotfiles so the user
arch-chroot /mnt chown -R "$NEW_USERNAME:$NEW_USERNAME" "/home/$NEW_USERNAME/.config"

echo "=========================================="
echo "      LarxOS Installation Complete!       "
echo "=========================================="
echo "You can now safely unmount and reboot into LarxOS."
