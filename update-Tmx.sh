#!/bin/bash

#CONSTANTS 
ANSI_RESET='\033[0m'
ANSI_FONT_BOLD='\033[1m'
ANSI_FONT_UNDERLINED='\033[4m'
ANSI_FONT_REVERSE='\033[7m'
ANSI_FONT_INVISIBLE='\033[8m'

ANSI_FG_BLACK='\033[0;30m'
ANSI_FG_WHITE='\033[1;97m'
ANSI_FG_RED='\033[1;91m'
ANSI_FG_GREEN='\033[1;92m'
ANSI_FG_CYAN='\033[1;96m'
ANSI_FG_BLUE='\033[1;94m'
ANSI_FG_MAGENTA='\033[1;95m'
ANSI_FG_YELLOW='\033[1;93m'

ANSI_BG_BLACK='\033[40m'
ANSI_BG_RED='\033[41m'
ANSI_BG_GREEN='\033[42m'
ANSI_BG_YELLOW='\033[43m'
ANSI_BG_BLUE='\033[44m'
ANSI_BG_MAGENTA='\033[45m'
ANSI_BG_CYAN='\033[46m'
ANSI_BG_WHITE='\033[47m'
ANSI_BG_BRIGHT_BLACK='\033[100m'
ANSI_BG_BRIGHT_RED='\033[101m'
ANSI_BG_BRIGHT_GREEN='\033[102m'
ANSI_BG_BRIGHT_YELLOW='\033[103m'
ANSI_BG_BRIGHT_BLUE='\033[104m'
ANSI_BG_BRIGHT_MAGENTA='\033[105m'
ANSI_BG_BRIGHT_CYAN='\033[106m'
ANSI_BG_BRIGHT_WHITE='\033[107m'

APT=apt
PKG=pkg
ETC=etc
LIMIT_EXIT_COUNTER=5
NAME_CURRENT_FILE='update-Tmx.sh'
NAME_WORK_DIRECTORY='TerminalUpdateBash'

#VARIABLES

exitcount=0
package_manager=apt

debug_log() {
    for arg in "$@"; do
        eval "value=\$${arg}"
        if [ -z "$value" ]; then
            printf "${ANSI_BG_BLACK}${ANSI_FG_WHITE} %s = (variable UNDEFINED) $arg ${ANSI_RESET}\n\n"
        else
            printf "${ANSI_BG_BLACK}${ANSI_FG_WHITE} %s = %s ${ANSI_RESET}\n" "$arg" "$value"
        fi
    done
}

water_mark_author(){
	local sleeptime=${1:-3}
	local codeexit=${2:-0} 
	debug_log sleeptime codeexit
	sleep $sleeptime
	echo $(clear)
    printf "${ANSI_FG_RED}[!] Script made by DexTr0\n\n${ANSI_FG_YELLOW}Script is closing now. Please wait.\n\n"
    printf "${ANSI_FG_YELLOW}© This software is copyleft and licensed under the GNU Affero General Public License.\nFor more information, visit "
	printf 'https://www.gnu.org/licenses/agpl-3.0.html'
	sleep 1
    printf "\n\n${ANSI_FG_YELLOW}."
    sleep 1
    printf "${ANSI_FG_YELLOW}."
    sleep 1
    printf "${ANSI_FG_YELLOW}.\n\n"
    sleep 1
	exit $codeexit
}

handle_error() {
	printf "${ANSI_BG_RED}${ANSI_FG_WHITE}#--Oops! Han error has been detected. [$exitcount-$LIMIT_EXIT_COUNTER]${ANSI_RESET}${ANSI_FG_CYAN}\n"
	exitcount=$(($exitcount + 1))
	if [ $exitcount == $LIMIT_EXIT_COUNTER ]; then 
		sleep 1
		echo $(clear)
		printf "${ANSI_FG_RED}[!] It's seems that some error has been ocurred..\n\n"
		sleep 1
		printf "${ANSI_FG_RED}#The script has been stopped...\n"
		water_mark_author 2 1
	fi
	read -n 1
}

handle_signals() {
	exitcount=$(($exitcount + 1))
	if [[ $exitcount -le $LIMIT_EXIT_COUNTER ]]; then 
		printf "${ANSI_BG_RED}${ANSI_FG_WHITE}#--Oops! [$exitcount-$LIMIT_EXIT_COUNTER]${ANSI_RESET}${ANSI_FG_CYAN}\n"
	fi 
	if [[ $exitcount -eq $LIMIT_EXIT_COUNTER ]]; then 
		sleep 1
		echo $(clear)
		printf "${ANSI_FG_RED}[!] It's seems that you wan't close the script.\n\n"
		sleep 1
		printf "${ANSI_FG_YELLOW}#The script has been stopped...\n"
		water_mark_author 2
	fi
}

trap handle_error ERR
trap handle_signals SIGINT

#Fetch OS

OS=$(uname -s)
ARCH=$(uname -m)

echo "Operating System: $OS"
echo "Architecture: $ARCH"

# Check that OS environment exists

if [[ -z "$OSTYPE" ]]; then 
	printf "${ANSI_FG_RED}[!]${ANSI_FG_YELLOW} OSTYPE var environment is not defined... Aborting\n"
	water_mark_author 3 1
fi

check_command_exists() {
  command -v "$1" > /dev/null 2>&1 && echo "$1" && return 0
  return 1
}

if echo $OS | egrep -iq 'nux' ; then
	if check_command_exists apt; then
    	PACKAGE_MANAGER="apt"
	elif check_command_exists apt-get; then
    	PACKAGE_MANAGER="apt-get"
  	elif check_command_exists yum; then
    	PACKAGE_MANAGER="yum"
  	elif check_command_exists pkg; then
    	PACKAGE_MANAGER="pkg"
	elif check_command_exists dnf; then
	    PACKAGE_MANAGER="dnf"
    elif check_command_exists zypper; then
        PACKAGE_MANAGER="zypper"
	elif check_command_exists pacman; then
        PACKAGE_MANAGER="pacman"
    elif check_command_exists yast; then
		PACKAGE_MANAGER="yast"
	elif check_command_exists apk; then
	    PACKAGE_MANAGER="apk"
	else
		printf "${ANSI_FG_RED}[!] Package manager not found."
		water_mark_author 3 1
	fi
else
	printf "${ANSI_FG_YELLOW}¡Package Manager not supported for the SO!... Aborting\n" 
	water_mark_author 3 1
fi

printf "${ANSI_FG_RED}[!]${ANSI_FG_GREEN}Chosen package manager: $PACKAGE_MANAGER"

# Check update-terminalx is on home is on home

if [ -e "$NAME_CURRENT_FILE" ]; then
	chmod +x "$NAME_CURRENT_FILE"
	mv "$NAME_CURRENT_FILE $HOME" && cd "$HOME"
elif [ -e "$HOME/storage/downloads/$NAME_WORK_DIRECTORY/$NAME_CURRENT_FILE" ]; then
	mv "$HOME/storage/downloads/$NAME_WORK_DIRECTORY/$NAME_CURRENT_FILE" $HOME
	chmod +x "$HOME/$NAME_CURRENT_FILE" 
else 
	echo $(clear)
	printf "${ANSI_FG_YELLOW}#Please move the *${NAME_CURRENT_FILE}* file to home directory.\n\n"
	water_mark_author 2
fi

# Main Menu

menu_main() {

	banner_d0
	printf "\n\n${ANSI_FG_GREEN}{+}--Options:
	
	${ANSI_FG_CYAN}[00]${ANSI_FG_GREEN} Exit
	${ANSI_FG_CYAN}[01]${ANSI_FG_GREEN} Install tools
	${ANSI_FG_CYAN}[02]${ANSI_FG_GREEN} Install sqlmap
	${ANSI_FG_CYAN}[03]${ANSI_FG_GREEN} Install metasploit
	${ANSI_FG_CYAN}[04]${ANSI_FG_GREEN} Install sudo (root)
	${ANSI_FG_CYAN}[05]${ANSI_FG_GREEN} Install kickthemout
	${ANSI_FG_CYAN}[06]${ANSI_FG_GREEN} Install aircrack-ng (root)
	${ANSI_FG_CYAN}[07]${ANSI_FG_GREEN} Changue config keyboard
	${ANSI_FG_CYAN}[08]${ANSI_FG_GREEN} Changue config termux (home)\n
	"
	printf "${ANSI_FG_GREEN} >>${ANSI_FG_CYAN} "
	read -n 2 option
	case $option in

		00)
			water_mark_author 5 5
			;;
		01) 
			update_terminal
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

update_terminal() {

	echo $(clear)
	printf "${ANSI_FG_RED}[!]${ANSI_FG_CYAN} Searching package manager for OS: ${OS}\n"
	printf "${ANSI_BG_YELLOW}${ANSI_FG_WHITE}--Loading packages...${ANSI_RESET}\n" 
	sleep 1
	cd $HOME
	printf "${ANSI_FG_YELLOW}"
	$package_manager update -y
	$package_manager upgrade -y
	$package_manager install vim figlet git wget curl php python python2 perl nmap openssh unzip zip unrar hydra util-linux darkhttpd tor torsocks clang -y
	update_terminal_as_root
}

# packages to install [root]

update_terminal_as_root() {

	printf "\n\n${ANSI_FG_CYAN}[#] Wanna you install root package? " && ask_yesnot
	read -n 3 anspack
	case $anspack in
		yes)
			echo $(clear)
			printf "${ANSI_FG_YELLOW}[!] installing root package.\n\n"
			printf "${ANSI_FG_WHITE}"
			sleep 2
			$package_manager install root-repo -y
			$package_manager install macchanger -y
			$package_manager update -y
			$package_manager upgrade -y
			sleep 1
			menu_main
			;;
		no)
			printf "${ANSI_FG_WHITE}\n"
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
	echo "PS1='${ANSI_FG_YELLOW}#--DexTrø ≈ $ANSI_FG_RED[${ANSI_FG_CYAN} \W$ANSI_FG_RED ]${ANSI_FG_YELLOW}:${ANSI_FG_WHITE}\n>> '" >> $ETC/bash.bashrc
	echo "printf '${ANSI_FG_BLUE}'" >> $ETC/bash.bashrc
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
		printf "$ANSI_FG_RED[!]${ANSI_FG_GREEN} Alread exists the directory (LabDTest).\n\n"
	else
		mkdir /storage/emulated/0/LabDTest
		printf "${ANSI_FG_CYAN}#--Has been made (LabDTest) directory.\n\n"
	fi
	read_enter	
	menu_main
}

# Menu dell thumb

menu_dellthum(){

	echo $(clear)
	printf "${ANSI_FG_GREEN}{+}--Options:

	${ANSI_FG_CYAN}[00]${ANSI_FG_YELLOW} Back to main main menu  
	${ANSI_FG_CYAN}[01]${ANSI_FG_YELLOW} Install deltumbnails
	${ANSI_FG_CYAN}[02]${ANSI_FG_YELLOW} What is delthumbnails?
	
	"
	printf "${ANSI_FG_GREEN} >>${ANSI_FG_CYAN} "
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
	#printf "${ANSI_FG_YELLOW}[!] Dellthumbnails has been installed."
	cd /storage/emulated/0/DCIM
	if [ -d .thumbnails ]; then
		rm -rf .thumbnails/
		printf "${ANSI_FG_CYAN}#Thumbnails directory has been removed.\n\n"
		read_enter
	else
		printf "$ANSI_FG_RED[!] The thumbnails appears to have been removed.\n\n"
		read_enter
	fi
}

#sudo

install_sudo_pkg () {

	echo $(clear)
	printf "${ANSI_FG_GREEN}#--Downloading sudo... ${ANSI_FG_WHITE}\n"
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
	printf "${ANSI_FG_GREEN}[*]Some files have been found[*]\n"
	printf "${ANSI_FG_YELLOW} This files:${ANSI_FG_WHITE} "
	ls
	printf "${ANSI_FG_CYAN}[#] Would you like to delete these files? " && ask_yesnot
	read -n 3 opc
	case $opc in

		yes)
			cd $HOME
			rm -rf termux-sudo
			echo
			printf "\n$ANSI_FG_RED[!]${ANSI_FG_YELLOW} The files have been deleted.\n"
			sleep 2
			;;
		no)
			echo
			printf "\n${ANSI_FG_GREEN}[!]${ANSI_FG_YELLOW} The files have been saved.\n"
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
	printf "${ANSI_FG_GREEN}#--wait to install sqlmap${ANSI_FG_WHITE}\n"
	echo
	sleep 2
	python2 -m pip install --upgrade pip
	python2 -m pip install sqlmap
	menu_main
}

#Aircrack

install_aircrack () {

	echo $(clear)
	printf "${ANSI_FG_YELLOW}[!]-Instalando aircrack-ng...\n\n"
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
	printf "${ANSI_FG_GREEN}{+}--Options:
		
	${ANSI_FG_CYAN}[00]${ANSI_FG_YELLOW} Back to main menu_main
	${ANSI_FG_CYAN}[01]${ANSI_FG_YELLOW} Config new bash
	${ANSI_FG_CYAN}[02]${ANSI_FG_YELLOW} DexTro config\n
	"
	#la variable original for Qconfigbash
	printf "${ANSI_FG_GREEN} >>${ANSI_FG_CYAN} "
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
	printf "${ANSI_FG_CYAN}[!]${ANSI_FG_YELLOW} Would you like config you console? " && ask_yesnot
	printf "\n${ANSI_FG_CYAN}"
	read -n 3 Qsh
	printf "\n"
	case $Qsh in
		yes)
			printf "${ANSI_FG_WHITE}"
			read -p "[$]-What is your name? >> " name
			printf "\n\n${ANSI_FG_MAGENTA}[!]-Which color you wanna put on your name? \n\n"
			printf "${ANSI_FG_WHITE}#This [1]\n"
			printf "${ANSI_FG_CYAN}#This [2]\n"
			printf "${ANSI_FG_YELLOW}#This [3]\n"
			printf "${ANSI_FG_GREEN}#This [4]\n"
			printf "${ANSI_FG_BLUE}#This [5]\n"
			printf "$ANSI_FG_RED#This [6]\n"
			printf "\n${ANSI_FG_WHITE}[$]-input an digit >> "
			read -n 3 Cname
			echo ""
			cd $PREFIX/etc
			if [ -e bash.bashrc ]; then
				rm bash.bahrc
			fi
		;;
	no)
			echo $(clear)
			printf "$ANSI_FG_RED[!]${ANSI_FG_GREEN} The config of bash haven't been configure"
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
	printf "${ANSI_FG_YELLOW}[!] Installing msf framework\n\n"
	sleep 1
	pkg install unstable-repo
	pkg install metasploit -y
	sleep 3
	menu_main
}

#keyboard changue

keyboard_mod(){

	echo $(clear)
	printf "$ANSI_FG_RED[!]${ANSI_FG_GREEN} Some keys has been added please reset terminal.\n\n"
	read_enter
	mkdir -p $HOME/.termux/&&echo "extra-keys = [['ESC','/','-','HOME','UP','END','PGUP'],['TAB','CTRL','ALT','LEFT','DOWN','RIGHT','PGDN']]" > $HOME/.termux/termux.properties&&echo "$rst"
	menu_main

}

#Wifi admin/MAC spoof

install_kickthemout() {

	clear
	printf "${ANSI_FG_YELLOW}[!] Installing kickthemount...\n\n "
	sleep 1
	cd $HOME
	git clone https://github.com/k4m4/kickthemout.git
	if [ -e $HOME/kickthemout ]; then
		clear
		printf "$ANSI_FG_RED[!] Error the directory kickthemout already exist."
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
	printf "$ANSI_FG_RED[•]--# You have chosen an invalid option #--[•]\n\n" 
	read_enter
	menu_main
}

#show error case option 1 [root-pkg]

show_error1rp() {
	show_error
	update_terminal_as_root
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
	printf "${ANSI_FG_CYAN}
	________            ________      _______ 
	___  __ \________  ____  __/________  __ \ ${ANSI_FG_GREEN}
	__  / / /  _ \_  |/_/_  /  __  ___/  / / / ${ANSI_FG_GREEN}
	_  /_/ //  __/_>  < _  /   _  /   / /_/ / ${ANSI_FG_CYAN}
	/_____/ \___//_/|_| /_/    /_/    \____/"

}
#Question opt [yes/no]

ask_yesnot() {
	printf "${ANSI_FG_CYAN}[${ANSI_FG_YELLOW}yes${ANSI_FG_CYAN}/${ANSI_FG_YELLOW}no${ANSI_FG_CYAN}]${ANSI_FG_WHITE} \n >>"
}

read_enter(){
	printf "${ANSI_FG_YELLOW}[!] Press enter to continue.\n\n"
	read -s enter
}



menu_main
