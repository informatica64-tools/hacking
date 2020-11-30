#!/bin/bash

#Colours
greenColor="\e[0;32m\033[1m"
endColor="\033[0m\e[0m"
redColor="\e[0;31m\033[1m"
blueColor="\e[0;34m\033[1m"
yellowColor="\e[0;33m\033[1m"
purpleColor="\e[0;35m\033[1m"
turquoiseColor="\e[0;36m\033[1m"
grayColor="\e[0;37m\033[1m"


#trap ctrl_c INT

#function_ctrl(){
#	echo -ne "\n${redColor}[!] Existing...\n${endColor}"


echo -ne "\n${blueColor}1) Arch Linux; 2) Debian/Ubuntu\n\n${endColor}"

read var1

# Creating config and subdirectories
mkdir -p ~/.config/{bspwm,sxhkd,bin,compton}

function dependencies(){

	sleep 2
	mkdir -p ~/Desktop/$(whoami)/Images

	if [ "$(echo $var1)" == "1" ]; then
		echo -ne "\n${yellowColor}Installing pacman dependencies\n\n${endColor}"
		sudo pacman -S libxcb xcb-util xcb-util-wm xcb-util-keysyms

	elif [ "$(echo $var1)" == "2" ]; then
		echo -ne "\n${yellowColor}Installing Debian/Ubuntu dependencies\n\n${endColor}"
		sudo apt-get install libxcb-xinerama0-dev libxcb-icccm4-dev libxcb-randr0-dev libxcb-util0-dev libxcb-ewmh-dev libxcb-keysyms1-dev libxcb-shape0-dev acpi -y

	else
		echo -ne "\n${redColor}You should select 1 or 2\n\n${endColor}"; exit 1

	fi
}; dependencies

function bspwmysxhkd(){
	echo -ne "\n${yellowColor}Installing bspwm and sxhkd...\n\n${endColor}"
	sudo apt-get install bspwm sxhkd -y

	echo -ne "\n${yellowColor}clonning repositories and do make and cmake...\n\n${endColor}"
	sleep 5

	git clone https://github.com/baskerville/bspwm.git
	git clone https://github.com/baskerville/sxhkd.git
	cd bspwm
	make
	sudo make install
	cd ../sxhkd
	make
	sudo make install
	cd ..

	mkdir ~/.config/bspwm/scripts
	wget "https://raw.githubusercontent.com/informatica64-tools/tools/master/bspwmrc"
	mv bspwmrc ~/.config/bspwm/
	chmod u+x ~/.config/bspwm/bspwmrc
	wget "https://raw.githubusercontent.com/informatica64-tools/tools/master/sxhkdrc"
	mv sxhkdrc ~/.config/sxhkd
	wget "https://raw.githubusercontent.com/informatica64-tools/tools/master/bspwm_resize"
	mv bspwm_resize ~/.config/bspwm/scripts/
	chmod +x ~/.config/bspwm/scripts/bspwm_resize

	touch ~/.xinitrc
	echo "sxhkd &\nexec bspwm" > ~/.xinitrc

}; bspwmysxhkd

function aditional_scripts(){

	echo -ne "\n${yellowColor}Downloading aditional scripts\n\n${endColor}"
	sleep 3

	wget "https://raw.githubusercontent.com/informatica64-tools/tools/master/hackthebox.sh"
	mv hackthebox.sh ~/.config/bin/
	wget "https://raw.githubusercontent.com/informatica64-tools/tools/master/ethernet_status.sh"
	mv ethernet_status.sh ~/.config/bin/
	wget "https://raw.githubusercontent.com/informatica64-tools/tools/master/battery.sh"
	mv battery.sh ~/.config/bin/
	wget "https://raw.githubusercontent.com/informatica64-tools/tools/master/nickname.sh"
	mv nickname.sh ~/.config/bin/
	chmod +x ~/.config/bin/*

}; aditional_scripts

function fehycompton(){
	echo -ne "\n${yellowColor}Installing compton, feh and zsh\n\n${endColor}"

	sudo apt-get install -y feh compton html2text zsh rofi nautilus

	echo -ne "\n${yellowColor}installing and configuring compton and feh\n\n${endColor}"

	wget "https://raw.githubusercontent.com/informatica64-tools/tools/master/compton.conf"
	mv compton.conf ~/.config/compton/
	wget "https://raw.githubusercontent.com/informatica64-tools/tools/master/Wallpaper.png"
	mv Wallpaper.png ~/Desktop/$(whoami)/Images

}

function polybarr(){
	echo -ne "\n${yellowColor}Downloading and installing polybar dependencies...\n\n${endColor}"

	sudo apt install build-essential git cmake cmake-data pkg-config python3-sphinx libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python3-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev -y
	sudo apt install libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev i3-wm libjsoncpp-dev libmpdclient-dev libcurl4-openssl-dev libnl-genl-3-dev -y

	echo "\n\n${greenColor}--------------------------------------------------------\n\n${endColor}"
	wget "https://github.com/polybar/polybar/releases/download/3.4.3/polybar-3.4.3.tar"
	tar xf polybar-3.4.3.tar
	sudo rm -r polybar-3.4.3.tar
	cd polybar
	mkdir build
	cd build
	cmake ..
	make -j$(nproc)
	# Optional. This will install the polybar executable in /usr/local/bin
	sudo make install
	cd ../../
	mv polybar ~/.config/

	wget "https://raw.githubusercontent.com/informatica64-tools/tools/master/launch.sh"
	mv launch.sh ~/.config/polybar/
	chmod +x ~/.config/polybar/launch.sh

	echo -ne "\n${yellowColor}Polybar theme\n\n${endColor}"

	git clone https://github.com/adi1090x/polybar-themes
	cd polybar-themes/polybar-11
	mkdir -p ~/.local/share/fonts && cp -r fonts/* ~/.local/share/fonts
	fc-cache -v && sudo rm /etc/fonts/conf.d/70-no-bitmaps.conf
	cp -r * ~/.config/polybar && ~/.config/polybar/launch.sh
	sudo rm -r ~/.config/polybar && cd ..

	rm -r polybar
	wget "https://github.com/informatica64-tools/tools/raw/master/Comprimido.tar"
	tar xf Comprimido.tar
	mv polybar ~/.config/
	wget "https://raw.githubusercontent.com/informatica64-tools/tools/master/config.ini"
	mv config.ini ~/.config/polybar

}; polybarr

function dunsst(){
	echo -ne "\n${blueColor}Installing dunst\n\n${endColor}"

	sudo apt-get install dunst -y
	echo "killall mate-notification-daemon; dunst &" >> ~/.config/bspwm/bspwmrc

}; dunsst

function hacknerdfonts(){
	wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip"
	mkdir Hack
	mv Hack.zip Hack/
	cd Hack && unzip *
	cd .. && sudo mv Hack /usr/share/fonts/

}; hacknerdfonts

sudo rm bspwm sxhkd polybar polybar-themes
