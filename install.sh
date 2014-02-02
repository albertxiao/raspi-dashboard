#/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Installing build dependencies"
read -p "Press [Enter] key to continue..."
pacman -S --noconfirm sudo patch diffutils

echo "Copying files in place"
read -p "Press [Enter] key to continue..."
cp -r data/* /
cd /

echo "Patching system files"
read -p "Press [Enter] key to continue..."
patch -p1 -i $DIR/patch/boot-etc.patch
cd $DIR

echo "Creating display user"
read -p "Press [Enter] key to continue..."
if ! id -u display >/dev/null 2>&1; then
    useradd -g users -s /bin/bash -d /home/display display
fi
chown -R display:users /opt/home/display/

echo "Setting up auto login service"
read -p "Press [Enter] key to continue..."
systemctl daemon-reload
systemctl enable rc-local
systemctl disable getty@tty1
systemctl enable autologin@tty1

echo "Setting up network"
read -p "Press [Enter] key to continue..."
pacman -S --noconfirm netctl
# For some stupid reason name resolving does not work if we do not do this
systemctl enable dhcpcd
netctl enable wlan0

echo "Installing software"
read -p "Press [Enter] key to continue..."
pacman -S --noconfirm openbox midori ttf-freefont xorg-server xorg-xinit xorg-utils xorg-server-utils xf86-video-fbdev unclutter xdotool

echo "Installing crontab"
read -p "Press [Enter] key to continue..."
sudo -u display crontab /opt/home/display/crontab

echo "Moveing log directry to tmpfs partition"
read -p "Press [Enter] key to continue..."
rm -rf /var/log
ln -s /run/log /var/log

echo "All finished, rebooting"
read -p "Press [Enter] key to continue..."
reboot
