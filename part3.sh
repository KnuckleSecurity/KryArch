sudo pacman -Sy git
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si
yay -S terminator firefox zsh fish konsave
konsave -i kryarch-one.knsv
konsave -a kryarch-one
cp misc/config ~/.config/terminator/config
cp misc/fish_prompt.fish ~/.config/fish/functions/fish_prompt.fish
cp finland_forest_lake-wallpaper-1920x1080.jpg ~/Pictures
cp finland_forest_lake-wallpaper-1920x1080.jpg /usr/share/sddm/themes/Nordic/assets/bg.jpg
cp finland_forest_lake-wallpaper-1920x1080.jpg /usr/share/wallpapers/Next/contents/images/1920x1080.png
cp misc/image2vector.svg ~/Pictures
