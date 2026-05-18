# Passwords
echo "root:$ROOT_PASS" | arch-chroot /mnt chpasswd
echo "$NEW_USERNAME:$USER_PASS" | arch-chroot /mnt chpasswd

# Permissions
if [ "$MAKE_SUDO" == "true" ]; then
    echo "Creating admin user with sudo access..."
    arch-chroot /mnt useradd -m -G wheel,storage,power -s /usr/bin/fish "$NEW_USERNAME"
else
    echo "Creating a standard user..."
    arch-chroot /mnt useradd -m -G storage,power -s /usr/bin/fish "$NEW_USERNAME"
fi
