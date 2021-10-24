
bash ~/KryArch/banner.sh
echo "-----------------------------"
echo " * Installing YAY Aur helper."
echo "-----------------------------"
sudo pacman -Sy git --noconfirm --needed
cd ~
git clone https://aur.archlinux.org/yay-bin.git
cd ~
cd ~/yay-bin
makepkg -si --noconfirm 
bash ~/KryArch/banner.sh
echo "---------------------------------------------"
echo " * Setting up KDE Plasma desktop environment."
echo "---------------------------------------------"
yay -S firefox zsh fish fisher fzf konsave sddm-nordic-theme-git kvantum-theme-nordic-git kvantum-qt5 --noconfirm --needed
cd ~/KryArch 
mkdir -p ~/.config/terminator
mkdir -p ~/.config/fish/functions
mkdir -p ~/.local/share/kxmlgui5
mkdir -p ~/.local/share/icons/Blue-Zafiro-Plus/apps/scalable
cp misc/config ~/.config/terminator/config
cp misc/fish_prompt.fish ~/.config/fish/functions/fish_prompt.fish
cp misc/fish_variables ~/.config/fish/fish_variables
cp misc/arch-ico.svg ~/.local/share/icons/Blue-Zafiro-Plus/apps/scalable/
echo "set fish_greeting" > ~/.config/fish/config.fish
echo 1| konsave -i ~/KryArch/kryarch-kde.knsv
konsave -a kryarch-kde
sudo cp misc/wallpaper.png /usr/share/sddm/themes/Nordic/assets/bg.jpg
sudo rm -rf /usr/share/wallpapers/Next/contents/images/*
sudo cp misc/wallpaper.png /usr/share/wallpapers/Next/contents/images/1920x1080.png
echo "exec fish" > ~/.zshrc
chsh -s /usr/bin/zsh $(whoami)
zsh
fisher install jethrokuan/fzf

