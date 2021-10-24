sudo pacman -Sy git
cd ~
git clone https://aur.archlinux.org/yay-bin.git
cd ~
cd ~/yay-bin
makepkg -si --noconfirm
yay -S terminator firefox zsh fish konsave sddm-nordic-theme-git --noconfirm --needed
konsave -i ~/kryarch-one.knsv
konsave -a kryarch-one
cd ~/KryArch
mkdir -p ~/.config/terminator
mkdir -p ~/.config/fish/functions
mkdir -p ~/.local/share/kxmlgui5
cp misc/config ~/.config/terminator/config
cp misc/fish_prompt.fish ~/.config/fish/functions/fish_prompt.fish
cp misc/finland_forest_lake-wallpaper-1920x1080.jpg ~/Pictures
cp misc/finland_forest_lake-wallpaper-1920x1080.jpg /usr/share/sddm/themes/Nordic/assets/bg.jpg
cp misc/finland_forest_lake-wallpaper-1920x1080.jpg /usr/share/wallpapers/Next/contents/images/1920x1080.png
cp misc/image2vector.svg ~/Pictures/image2vector.svg
