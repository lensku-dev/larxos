#!/usr/bin/env bash
set -e

echo "=========================================="
echo "      Deploying LarxOS Base Files         "
echo "=========================================="

# Install the base system plus the core apps and the bootloader
pacstrap -K /mnt base linux linux-firm base-devel alacritty fish git fastfetch grub efibootmgr

# Generate the partition map
genfstab -U /mnt >> /mnt/etc/fstab

# Hostname
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
echo "        Installing GRUB Bootloader        "
echo "=========================================="

echo "Deploying GRUB binary files to the EFI partition..."
arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id="LarxOS"

echo "Generating the main GRUB configuration file..."
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg

echo "=========================================="
echo "     Deploying Custom Configurations      "
echo "=========================================="

# Move the dotfiles to the right directory
mkdir -p "/mnt/home/$NEW_USERNAME/.config"
cp -r /usr/share/larxos/config/* "/mnt/home/$NEW_USERNAME/.config/"

# Change ownership of the dotfiles
arch-chroot /mnt chown -R "$NEW_USERNAME:$NEW_USERNAME" "/home/$NEW_USERNAME/.config"

echo "=========================================="
echo "      LarxOS Installation Complete!       "
echo "=========================================="
echo "You can now safely unmount and reboot into LarxOS."
