sudo pacman -Sy git
cd ~
git clone https://aur.archlinux.org/yay-bin.git
cd ~
cd ~/yay-bin
makepkg -si --noconfirm
yay -S terminator firefox zsh fish konsave --noconfirm
konsave -i kryarch-one.knsv
konsave -a kryarch-one
cd ~/KryArch
cp misc/config ~/.config/terminator/config
cp misc/fish_prompt.fish ~/.config/fish/functions/fish_prompt.fish
cp finland_forest_lake-wallpaper-1920x1080.jpg ~/Pictures
cp finland_forest_lake-wallpaper-1920x1080.jpg /usr/share/sddm/themes/Nordic/assets/bg.jpg
cp finland_forest_lake-wallpaper-1920x1080.jpg /usr/share/wallpapers/Next/contents/images/1920x1080.png
cp misc/image2vector.svg ~/Pictures
