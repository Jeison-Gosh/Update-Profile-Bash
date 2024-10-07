#!/bin/bash

#CONSTANTS 

FG_BLACK='\033[0;30m'
FG_WHITE='\033[1;97m'
FG_RED='\033[1;91m'
FG_GREEN='\033[1;92m'
FG_CYAN='\033[1;96m'
FG_BLUE='\033[1;94m'
FG_MAGENTA='\033[1;95m'
FG_YELLOW='\033[1;93m'

bse='\033[2;94m'
cu='\033[3;92m'


APT=apt
PKG=pkg
ETC=$PREFIX/etc
LIMIT_EXIT_COUNTER=3
NAME_CURRENT_FILE='update-Tmx.sh'
NAME_WORK_DIRECTORY='TerminalUpdateBash'

#VARIABLES
exitcount=0

water_mark_author(){
	local sleeptime=${1:-3}  
	sleep $sleeptime
	echo $(clear)
    printf "${FG_RED}[!] Script made by DexTr0\n\n${FG_YELLOW}Script is closing now. Please wait.\n\n"
    printf "${FG_YELLOW}© This software is copyleft and licensed under the GNU Affero General Public License.\nFor more information, visit "
	printf 'https://www.gnu.org/licenses/agpl-3.0.html'
	sleep 1
    printf "\n\n${FG_YELLOW}."
    sleep 1
    printf "${FG_YELLOW}."
    sleep 1
    printf "${FG_YELLOW}.\n\n"
    sleep 1
}

trap ctrl_c 2
ctrl_c() {
	exitcount=$(($exitcount + 1))
	if [[ $exitcount -le $LIMIT_EXIT_COUNTER ]]; then 
		printf "$FG_RED#--Oops! [$exitcount-$LIMIT_EXIT_COUNTER]${FG_CYAN}\n"
	fi 
	if [ $exitcount == $LIMIT_EXIT_COUNTER ]; then 
		sleep 1
		echo $(clear)
		printf "${FG_RED}[!] It's seems that you wan't close the script.\n\n"
		sleep 1
		printf "${FG_YELLOW}#The script has been stopped...\n"
		water_mark_author 2
		exit 0
	fi
}

#Fetch OS

case "$OSTYPE" in
	linux*)  OS="Linux" ;;
	darwin*) OS="MacOS" ;;
	cygwin*) OS="Cygwin" ;;
	msys*)   OS="Windows" ;;
	*)       OS="Desconocido" ;;
esac

ARCH=$(uname -m)

echo "Operating System: $OS"
echo "Architecture: $ARCH"

# Check that OS environment exists

if [[ -z "$OS" ]]; then 
	printf "${FG_RED}[!]${FG_YELLOW} OS var environment is not defined... Trying with var OSTYPE\n" 
fi 

if [[ -z "$OSTYPE" ]]; then 
	printf "${FG_RED}[!]${FG_YELLOW} OSTYPE var environment is not defined... Aborting\n"
	water_mark_author
	exit 1 
fi

if echo $OS | egrep -iq 'nux|ows' ; then
	if command -v apt &>/dev/null; then
    	PACKAGE_MANAGER="apt"
	elif command -v apt-get &>/dev/null; then
    	PACKAGE_MANAGER="apt-get"
  	elif command -v yum &>/dev/null; then
    	PACKAGE_MANAGER="yum"
  	elif command -v pkg &>/dev/null; then
    	PACKAGE_MANAGER="pkg"
  	else
		printf "${FG_RED}[!] Package manager not found."
		water_mark_author
		exit 1
	fi
else
	printf "${FG_YELLOW}¡Package Manager not supported for the SO!... Aborting\n" 
	water_mark_author
	exit 1
fi

printf "${FG_RED}[!]${FG_GREEN}Chosen package manager: $PACKAGE_MANAGER"

# Check update is on home

if [ -e "$NAME_CURRENT_FILE" ]; then
	if [ -e "$HOME/$NAME_WORK_DIRECTORY/$NAME_CURRENT_FILE" ]; then
		cd $HOME
		chmod +x "$HOME/$NAME_WORK_DIRECTORY/$NAME_CURRENT_FILE"
	elif [ -e "$HOME/$NAME_CURRENT_FILE" ]; then
		clear
	else
		mv "$NAME_CURRENT_FILE $HOME"
		chmod +x "$HOME/$NAME_CURRENT_FILE"
		cd "$HOME"
	fi
elif [ -e "$HOME/storage/downloads/$NAME_WORK_DIRECTORY/$NAME_CURRENT_FILE" ]; then
	mv "$HOME/storage/downloads/$NAME_WORK_DIRECTORY/$NAME_CURRENT_FILE" $HOME
	chmod +x "$HOME/$NAME_CURRENT_FILE" 
else 
	echo $(clear)
	printf "${FG_YELLOW}#Please move the *$NAME_CURRENT_FILE* file to home directory.\n\n"
	water_mark_author 2
	exit 0
fi

# Main Menu

menu_main() {

	echo $(clear)
	banner_d0
	printf "\n\n${FG_GREEN}{+}--Options:
	
	${FG_CYAN}[00]${FG_GREEN} Exit
	${FG_CYAN}[01]${FG_GREEN} Install tools
	${FG_CYAN}[02]${FG_GREEN} Install sqlmap
	${FG_CYAN}[03]${FG_GREEN} Install metasploit
	${FG_CYAN}[04]${FG_GREEN} Install sudo (root)
	${FG_CYAN}[05]${FG_GREEN} Install kickthemout
	${FG_CYAN}[06]${FG_GREEN} Install aircrack-ng (root)
	${FG_CYAN}[07]${FG_GREEN} Changue config keyboard
	${FG_CYAN}[08]${FG_GREEN} Changue config termux (home)\n
	"
	printf "${FG_GREEN} >>${FG_CYAN} "
	read -n 2 op
	case $op in

		00)
			water_mark_author
			exit 0
			;;
		01) 
			update
			;;
		02)
			install_sqlmap
			;;
		03)
			install_metasploit
			;;
		04)
			install_sudo_pkg
			;;
		05)
			install_kickthemout
			;;
		06)
			install_aircrack
			;;
		07)
			keyboard_mod	
			;;

		08)     
			choose_bash_config
			;;
		09)
			menu_dellthum
			;;

		*)
			show_error
			;;
			
	esac
}

# packages to upgrade and install

update() {

	echo $(clear)
	printf "$FG_RED[!]${FG_CYAN} Searching the OS type to download tools..."
	printf "$FG_RED[!]${FG_GREEN}--Loading packages...\n" 
	sleep 2
	cd $HOME
	printf "${FG_YELLOW}"
	pkg update && pkg upgrade -y
	pkg install vim figlet git wget curl php python python2 perl nmap openssh unzip zip unrar hydra util-linux darkhttpd tor torsocks clang -y
	updateRP
}

# packages to install [root]

updateRP() {

	echo $(clear)
	printf "${FG_CYAN}[#] Wanna you install root package? "
	ask_yesnot
	echo
	read -n 3 anspack
	case $anspack in
		yes)
			echo $(clear)
			printf "${FG_YELLOW}[!] installing root package.\n\n"
			printf "${FG_WHITE}"
			sleep 2
			pkg install root-repo -y
			pkg install macchanger -y
			pkg update && pkg upgrade -y
			sleep 1
			menu_main
			;;
		no)
			printf "${FG_WHITE}\n"
			pkg update && pkg upgrade -y
			sleep 2
			menu_main
			;;
		*)
			show_error1rp
			;;
	esac
	
}

# setup Dex-config

config_environment_by_default() {

	echo $(clear)
	if [ -e $PREFIX/etc/motd ]; then
		rm $PREFIX/etc/motd
	fi

	echo "#!/data/data/com.termux/files/usr/bin/bash" > $ETC/bash.bashrc
	echo "" >> $ETC/bash.bashrc
	echo "wt='\033[1;87'" >> $ETC/bash.bashrc
	echo "bo='\033[1;97m'" >> $ETC/bash.bashrc
	echo "re='\033[1;91m'" >> $ETC/bash.bashrc
	echo "gr='\033[1;92m'" >> $ETC/bash.bashrc
	echo "be='\033[1;96m'" >> $ETC/bash.bashrc
	echo "bs='\033[1;94m'" >> $ETC/bash.bashrc
	echo "ye='\033[1;93m'" >> $ETC/bash.bashrc
	echo "cu='\033[3;92m'" >> $ETC/bash.bashrc
	echo "echo $(clear)" >> $ETC/bash.bashrc
	echo "PS1='${FG_YELLOW}#--DexTrø ≈ $FG_RED[${FG_CYAN} \W$FG_RED ]${FG_YELLOW}:${FG_WHITE}\n>> '" >> $ETC/bash.bashrc
	echo "printf '${FG_BLUE}'" >> $ETC/bash.bashrc
	echo "figlet '       *Dextr0* '" >> $ETC/bash.bashrc
	echo "echo " >> $ETC/bash.bashrc
	echo "BIN=$PREFIX/bin" >> $ETC/bash.bashrc
	echo "ETC=$PREFIX/etc" >> $ETC/bash.bashrc
	echo "BT=$HOME/storage/shared/bluetooth" >> $ETC/bash.bashrc
	echo "DW=$HOME/storage/shared/Download" >> $ETC/bash.bashrc
	echo "dw=/storage/emulated/0/Download" >> $ETC/bash.bashrc
	echo "music=/storage/emulated/0/Music" >> $ETC/bash.bashrc
	echo "DCIM=$HOME/storage/shared/DCIM" >> $ETC/bash.bashrc
	echo "dcim=/storage/emulated/0/DCIM" >> $ETC/bash.bashrc
	echo "MOP='sudo nmap -sT -O localhost'" >> $ETC/bash.bashrc
	echo "SCAN0='sudo nmap 192.168.0.1/24'" >> $ETC/bash.bashrc
	echo "SCAN1='sudo nmap 192.168.1.1/24'" >> $ETC/bash.bashrc 
	echo "LABD=$HOME/storage/shared/LabDTest" >> $ETC/bash.bashrc
	echo "labd=/storage/emulated/0/LabDTest" >> $ETC/bash.bashrc
	if [ -e /storage/emulated/0/LabDTest ]; then
		printf "$FG_RED[!]${FG_GREEN} Alread exists the directory (LabDTest).\n\n"
	else
		mkdir /storage/emulated/0/LabDTest
		printf "${FG_CYAN}#--Has been made (LabDTest) directory.\n\n"
	fi
	read_enter	
	menu_main
}

# Menu dell thumb

menu_dellthum(){

	echo $(clear)
	printf "${FG_GREEN}{+}--Options:

	${FG_CYAN}[00]${FG_YELLOW} Back to main menu_main  
	${FG_CYAN}[01]${FG_YELLOW} Install deltumbnails
	${FG_CYAN}[02]${FG_YELLOW} What is delthumbnails?
	
	"
	printf "${FG_GREEN} >>${FG_CYAN} "
	read -n 2 delop
	case $delop in
		00)
			menu_main
			;;
		01)
			delete_thumbnails
			;;
		02)
			whtsdt
			;;
		*)
			show_error_8dt
			;;

	esac
	menu_main
}

#delete thumbnails

delete_thumbnails () {

	echo $(clear)
	#printf "${FG_YELLOW}[!] Dellthumbnails has been installed."
	cd /storage/emulated/0/DCIM
	if [ -d .thumbnails ]; then
		rm -rf .thumbnails/
		printf "${FG_CYAN}#Thumbnails directory has been removed.\n\n"
		read_enter
	else
		printf "$FG_RED[!] The thumbnails appears to have been removed.\n\n"
		read_enter
	fi
}

#sudo

install_sudo_pkg () {

	echo $(clear)
	printf "${FG_GREEN}#--Downloading sudo... ${FG_WHITE}\n"
	echo
	cd $HOME
	if [ -e termux-sudo ]; then
		rm -f -R termux-sudo
	fi

	if [ -e $PREFIX/bin/sudo ]; then
		rm -f $PREFIX/bin/sudo
	fi

	if [ -e $PREFIX/bin/applets/sudo ]; then
		rm -f $PREFIX/bin/applets/sudo
	fi
	
	git clone https://gitlab.com/st42/termux-sudo
	cd termux-sudo
	chmod 777 sudo
	mv sudo $PREFIX/bin/applets
	printf "${FG_GREEN}[*]Some files have been found[*]\n"
	printf "${FG_YELLOW} This files:${FG_WHITE} "
	ls
	printf "${FG_CYAN}[#] Would you like to delete these files? "
	ask_yesnot
	read -n 3 opc
	case $opc in

		yes)
			cd $HOME
			rm -rf termux-sudo
			echo
			printf "\n$FG_RED[!]${FG_YELLOW} The files have been deleted.\n"
			sleep 2
			;;
		no)
			echo
			printf "\n${FG_GREEN}[!]${FG_YELLOW} The files have been saved.\n"
			sleep 2
			;;
		*)
			show_error4
			;;

	esac
	menu_main
	
}

#sqlmap

install_sqlmap (){

	echo $(clear)
	printf "${FG_GREEN}#--wait to install sqlmap${FG_WHITE}\n"
	echo
	sleep 2
	python2 -m pip install --upgrade pip
	python2 -m pip install sqlmap
	menu_main
}

#Aircrack

install_aircrack () {

	echo $(clear)
	printf "${FG_YELLOW}[!]-Instalando aircrack-ng...\n\n"
	sleep 1
	pkg upgrade -y
	pkg install aircrack-ng ethtool macchanger -y
	sleep 2
	menu_main
}


#seleccion bash

choose_bash_config() {

	echo $(clear)
	printf "\n\n"
	printf "${FG_GREEN}{+}--Options:
		
	${FG_CYAN}[00]${FG_YELLOW} Back to main menu_main
	${FG_CYAN}[01]${FG_YELLOW} Config new bash
	${FG_CYAN}[02]${FG_YELLOW} DexTro config\n
	"
	#la variable original for Qconfigbash
	printf "${FG_GREEN} >>${FG_CYAN} "
	read -n 2 Opconfigbash 
	case $Opconfigbash in

		00)
			menu_main
			;;
		01)
			config_bash
			;;
		02)
			config_environment_by_default
			;;
		*)
			show_error8
			;;
		esac
	
}

#Config bash

config_bash () {

	echo $(clear)
	printf "${FG_CYAN}[!]${FG_YELLOW} Would you like config you console? "
	ask_yesnot
	printf "\n${FG_CYAN}"
	read -n 3 Qsh
	printf "\n"
	case $Qsh in
		yes)
			printf "${FG_WHITE}"
			read -p "[$]-What is your name? >> " name
			printf "\n\n${FG_MAGENTA}[!]-Which color you wanna put on your name? \n\n"
			printf "${FG_WHITE}#This [1]\n"
			printf "${FG_CYAN}#This [2]\n"
			printf "${FG_YELLOW}#This [3]\n"
			printf "${FG_GREEN}#This [4]\n"
			printf "${FG_BLUE}#This [5]\n"
			printf "$FG_RED#This [6]\n"
			printf "\n${FG_WHITE}[$]-input an digit >> "
			read -n 3 Cname
			echo ""
			cd $PREFIX/etc
			if [ -e bash.bashrc ]; then
				rm bash.bahrc
			fi
		;;
	no)
			echo $(clear)
			printf "$FG_RED[!]${FG_GREEN} The config of bash haven't been configure"
			read_enter
			choose_bash_config
		;;
	*)
			show_error_8cb
		;;
	esac
}

#metasploit 

install_metasploit () {

	echo $(clear)
	sleep 1
	printf "${FG_YELLOW}[!] Installing msf framework\n\n"
	sleep 1
	pkg install unstable-repo
	pkg install metasploit -y
	sleep 3
	menu_main
}

#keyboard changue

keyboard_mod(){

	echo $(clear)
	printf "$FG_RED[!]${FG_GREEN} Some keys has been added please reset termux.\n\n"
	read_enter
	mkdir -p $HOME/.termux/&&echo "extra-keys = [['ESC','/','-','HOME','UP','END','PGUP'],['TAB','CTRL','ALT','LEFT','DOWN','RIGHT','PGDN']]" > $HOME/.termux/termux.properties&&echo "$rst"
	menu_main

}

#Wifi admin/MAC spoof

install_kickthemout() {

	clear
	printf "${FG_YELLOW}[!] Installing kickthemount...\n\n "
	sleep 3
	cd $HOME
	git clone https://github.com/k4m4/kickthemout.git
	if [ -e $HOME/kickthemout ]; then
		clear
		printf "$FG_RED[!] Error the directory kickthemout already exist."
		read_enter
	else
		cd $HOME/kickthemout
		python -m pip install -r requirements.txt
	fi
	menu_main

	

}

# Error case

show_error() { 
	echo $(clear)
	printf "$FG_RED[•]--# You have chosen an invalid option #--[•]\n\n" 
	read_enter
	menu_main
}

#show error case option 1 [root-pkg]

show_error1rp() {
	show_error
	updateRP
}

#show error case option 4

show_error4() {
	show_error
	install_sudo_pkg
}

#show error case option 8

show_error8() {
	show_error
	choose_bash_config       
}

#show error case option 8 [config_bash]

show_error_8cb() {
	show_error
	config_bash


}

#show error case option 8 [delete thumbnails]

show_error_8dt() {
	show_error
	menu_dellthum

}	

#DexTr0 banner

banner_d0() {

	echo $(clear)
	printf "${FG_CYAN}
	________            ________      _______ 
	___  __ \________  ____  __/________  __ \ ${FG_GREEN}
	__  / / /  _ \_  |/_/_  /  __  ___/  / / / ${FG_GREEN}
	_  /_/ //  __/_>  < _  /   _  /   / /_/ / ${FG_CYAN}
	/_____/ \___//_/|_| /_/    /_/    \____/"

}
#Question opt [yes/no]

ask_yesnot() {

	printf "${FG_CYAN}["
	printf "${FG_YELLOW}"
	printf "yes${FG_CYAN}/"
	printf "${FG_YELLOW}"
	printf "no${FG_CYAN}]"
	printf "${FG_WHITE}\n >> "

	printf "${FG_CYAN}[${FG_YELLOW}yes${FG_CYAN}/${FG_YELLOW}no${FG_CYAN}]${FG_WHITE} \n >>"
	yesnot="${FG_CYAN}[${FG_YELLOW}yes${FG_CYAN}/${FG_YELLOW}no${FG_CYAN}]${FG_WHITE} \n >>"
	echo "${yesnot}"

}

read_enter(){
	printf "${FG_YELLOW}[!] Press enter to continue.\n \n"
	read -s enter
}

menu_main
