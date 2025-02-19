#!/bin/bash

if (( $EUID != 0 )); then
    echo -e "${CYAN}Run this script using root"
    exit
fi

clear

installsvg(){
    cd /var/www/
    tar -cvf pterodactylbackup.tar.gz pterodactyl
    echo -e "${CYAN}Installing SVG Icon Login..."
    cd /var/www/pterodactyl
    rm -r pterodactylsvg
    git clone https://github.com/Akamaru69/pterodactylsvg.git
    cd pterodactylsvg
    rm /var/www/pterodactyl/public/assets/svgs/pterodactyl.svg
    mv pterodactyl.svg /var/www/pterodactyl/public/assets/svgs/
    chmod 777 /var/www/pterodactyl/public/assets/svgs/pterodactyl.svg
    cd /var/www/pterodactyl

    curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
    apt update
    apt install -y nodejs

    npm i -g yarn
    yarn

    cd /var/www/pterodactyl
    yarn build:production
    sudo php artisan optimize:clear


}

svglogin(){
    while true; do
        read -p "Are you sure you want Change the SVG Login Icon [y/n]? " yn
        case $yn in
            [Yy]* ) installsvg; break;;
            [Nn]* ) exit;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

reparar(){
    bash <(curl https://raw.githubusercontent.com/Akamaru69/pterodactylsvg/main/reparar.sh)
}

restaurarbackup(){
    echo "Restoring Backup..."
    cd /var/www/
    tar -xvf pterodactylbackup.tar.gz
    rm pterodactylthemes.tar.gz

    cd /var/www/pterodactyl
    yarn build:production
    sudo php artisan optimize:clear
}

    CYAN='\033[0;36m'
    echo -e "${CYAN}Copyright 2022 TemuxOS"
    echo -e "${CYAN}This program is free software, you can modify and distribute it without any problems."
    echo -e ""
    echo -e "${CYAN}Discord: https://discord.gg/WkVVtTaBRh/"
    echo -e ""
    echo -e "${CYAN} [1] Change SVG Icon Login"
    echo -e "${CYAN} [2] Restore Backup"
    echo -e "${CYAN} [3] Repair Panel (Use if you have a problem installing the themes)"
    echo -e "${CYAN} [4] Exit"

read -p "Enter a number: " choice
if [ $choice == "1" ]
    then
    svglogin
fi
if [ $choice == "2" ]
    then
    restaurarbackup
fi
if [ $choice == "3" ]
    then
    reparar
fi
if [ $choice == "4" ]
    then
    exit
fi
