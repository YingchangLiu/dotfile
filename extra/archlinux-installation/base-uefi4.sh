#!/bin/bash

echo "This is the last script for base-uefi, mainly for setting up the system and user configuration after installing the base system."

pacman -S paru firefox git intel-ucode  wqy-zenhei  otf-font-awesome  zsh-autosuggestions zsh-completions zsh-syntax-highlighting zsh-theme-powerlevel10k mesa lib32-mesa vulkan-intel lib32-vulkan-intel nvidia nvidia-utils nvidia-settings lib32-nvidia-utils

paru -S ntfsprogs-ntfs3 



#git clone https://yingchangliu/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash install.sh

sudo pacman -S $(cat ~/dotfiles/script/pacman_application.txt)
paru -S $(cat ~/dotfiles/script/aur_application.txt)

