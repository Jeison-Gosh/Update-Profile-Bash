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
ANSI_FG_YELLOW='\033[1;33m'

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

encoding=utf-8
exitcount=0
config_file=bash
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

# Messages
show_message_warn(){
	local message=${1:-"Unknown Error"}
	local readline=${2:-false}
	local blankcanvas=${3:-false}
	local sleeptime=${4:-0}

	if [ $blankcanvas = false ]; then 
		printf "${ANSI_FG_YELLOW}[!] ${message}.${ANSI_RESET}"
	else 
		printf "${ANSI_FG_YELLOW}${message}.${ANSI_RESET}"
	fi 
	sleep $sleeptime
	if [ $readline = true ]; then
		read_enter
	else 
		printf "\n\n"
	fi 
}
show_message_error(){
	local message=${1:-"Unknown Error"}
	local readline=${2:-false}
	local blankcanvas=${3:-false}
	local sleeptime=${4:-0}

	if [ $blankcanvas = false ]; then 
		printf "${ANSI_FG_RED}[!] ${message}.${ANSI_RESET}"
	else 
		printf "${ANSI_FG_RED}${message}.${ANSI_RESET}"
	fi 
	sleep $sleeptime
	if [ $readline = true ]; then
		read_enter
	else 
		printf "\n\n"
	fi 
}

exit_water_mark_author(){
	local sleeptime=${1:-0}
	local codeexit=${2:-0} 
	exitcount=-1
	stty -echo icanon time 0 min 0
	#debug_log sleeptime codeexit
	sleep $sleeptime && clear
    printf "${ANSI_BG_BLACK}${ANSI_FG_RED}[•]--# Script is closing now. Please wait. #--[•]\n\n${ANSI_RESET}${ANSI_FG_WHITE}[!] Script made by DexTr0${ANSI_RESET}\n\n"
	sleep 1
    printf "${ANSI_FG_YELLOW}█████████" && sleep 1
    printf "\n${ANSI_FG_BLUE}█████████" &&sleep 1
    printf "\n${ANSI_FG_RED}█████████"  && sleep 1
    printf "\n\n${ANSI_BG_BLACK}${ANSI_FG_YELLOW}© This software is copyleft and licensed under the GNU Affero General Public License.\nFor more information, visit "
	printf 'https://www.gnu.org/licenses/agpl-3.0.html'
	printf "${ANSI_RESET}\n\n"
	stty echo icanon
	exit $codeexit
}

find_shell_config() {
    SHELL_NAME=$(basename "$SHELL")
    case "$SHELL_NAME" in
        bash)
            if [ -f ~/.bashrc ]; then
                config_file=~/.bashrc
            elif [ -f ~/.bash_profile ]; then
                config_file=~/.bash_profile
            else
                config_file=~/.profile
            fi
            ;;
        zsh)
            config_file=~/.zshrc
            ;;
        *)
            printf "${ANSI_FG_RED}[!] Unsupported shell: $SHELL_NAME"
			exit_water_mark_author 1 1
            ;;
    esac
}

check_encoding() {
    encoding=$(file -bi "$config_file" | awk -F "=" '{print $2}')
    case "$encoding" in
        *utf-8*|*utf-16*|*utf-32*)
            ENCODING_OK=1
            ;;
        *ascii*)
            ENCODING_OK=1
            ;;
        *)
            ENCODING_OK=0
            ;;
    esac
}

find_operative_system() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$NAME
    elif command -v lsb_release >/dev/null 2>&1; then
        OS=$(lsb_release -si)
    else
        OS=$(uname -s)
    fi
	ARCH=$(uname -m)
}

# Find the compatibility of script with the OS.

find_operative_system
find_shell_config
check_encoding

echo "Operating System: $OS"
echo "Architecture: $ARCH"

handle_error() {
	printf "${ANSI_BG_RED}${ANSI_FG_WHITE}#--Oops! Han error has been detected. [$exitcount-$LIMIT_EXIT_COUNTER]${ANSI_RESET}\n"
	exitcount=$(($exitcount + 1))
	if [ $exitcount == $LIMIT_EXIT_COUNTER ]; then 
		sleep 1 && clear
		show_message_error "It's seems that some error has been ocurred" false false 1
		show_message_error "#The script has been stopped..." false true
		exit_water_mark_author 2 1
	fi
}

handle_signals() {
	if [[ "$exitcount" =~ ^- ]]; then
    	return 0
	fi
	exitcount=$(($exitcount + 1))
	if [[ $exitcount -le $LIMIT_EXIT_COUNTER ]]; then 
		printf "${ANSI_BG_RED}${ANSI_FG_WHITE}#--Oops! [$exitcount-$LIMIT_EXIT_COUNTER]${ANSI_RESET}\n"
	fi 
	if [[ $exitcount -eq $LIMIT_EXIT_COUNTER ]]; then 
		clear
		show_message_error "It's seems that you wan't close the script"
		show_message_warn "#The script has been stopped..." false true 
		exit_water_mark_author 2
	fi
}

trap handle_error ERR
trap handle_signals SIGINT SIGTERM

# Check that OS environment exists

if [[ -z "$OSTYPE" ]]; then 
	printf "${ANSI_FG_RED}[!] OSTYPE var environment is not defined... Aborting\n"
	exit_water_mark_author 3 1
fi


check_command_exists() {
  command -v "$1" > /dev/null 2>&1 && echo "$1" && return 0
  return 1
}

# Chosee a package manager

if echo $OS | grep -iqE 'nux|linux|debian|ubuntu|fedora|arch|suse|manjaro|alpine|gentoo|centos|rhel|rocky|opensuse|mint|kali|pop' ; then
    for manager in apt-get apt yum pkg dnf zypper pacman yast apk; do
        if check_command_exists $manager; then
            package_manager="$manager"
            break
        fi
    done

    if [ -z "$package_manager" ]; then
        printf "${ANSI_FG_RED}[!] Package manager not found.\n"
        exit_water_mark_author 3 1
    fi
else
    printf "${ANSI_FG_YELLOW}¡Package Manager not supported for the SO!... Aborting.\n"
    exit_water_mark_author 3 1
fi


printf "${ANSI_FG_GREEN}[!]${ANSI_FG_YELLOW} Chosen package manager: $package_manager"

# Check update-terminalx is on home is on home

if [ -e "$NAME_CURRENT_FILE" ]; then
	chmod +x "$NAME_CURRENT_FILE"
	mv "$NAME_CURRENT_FILE $HOME" && cd "$HOME"
elif [ -e "$HOME/storage/downloads/$NAME_WORK_DIRECTORY/$NAME_CURRENT_FILE" ]; then
	mv "$HOME/storage/downloads/$NAME_WORK_DIRECTORY/$NAME_CURRENT_FILE" $HOME
	chmod +x "$HOME/$NAME_CURRENT_FILE" 
else 
	clear && printf "${ANSI_FG_YELLOW}#Please move the *${NAME_CURRENT_FILE}* file to home directory.\n\n"
	exit_water_mark_author 3 1
fi

# Main Menu

menu_main() {

	show_banner_dextro
	printf "\n\n${ANSI_FG_GREEN}{+}--Options:
	
	${ANSI_FG_CYAN}[00]${ANSI_FG_GREEN} Exit
	${ANSI_FG_CYAN}[01]${ANSI_FG_GREEN} Install tools
	${ANSI_FG_CYAN}[02]${ANSI_FG_GREEN} Install sqlmap
	${ANSI_FG_CYAN}[03]${ANSI_FG_GREEN} Install metasploit
	${ANSI_FG_CYAN}[04]${ANSI_FG_GREEN} Install sudo (root)
	${ANSI_FG_CYAN}[05]${ANSI_FG_GREEN} Install kickthemout
	${ANSI_FG_CYAN}[06]${ANSI_FG_GREEN} Install aircrack-ng (root)
	${ANSI_FG_CYAN}[07]${ANSI_FG_GREEN} Changue config keyboard (android)
	${ANSI_FG_CYAN}[08]${ANSI_FG_GREEN} Changue config terminal \n
	"
	printf "${ANSI_FG_GREEN} >>${ANSI_FG_CYAN} "
	read -n 2 option
	case $option in

		00)
			exit_water_mark_author
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
			show_option_error
			;;
	esac
	menu_main
}

# packages to upgrade and install

update_terminal() {

	clear
	printf "${ANSI_RESET}${ANSI_FG_YELLOW}[!] Searching package manager for OS: ${OS}\n\n"
	printf "${ANSI_RESET} - Package manager selected: ${ANSI_BG_GREEN}${ANSI_FG_WHITE}${package_manager}${ANSI_RESET}\n\n"
	printf "${ANSI_BG_YELLOW}${ANSI_FG_WHITE}#--Loading packages...${ANSI_RESET}\n" 
	sleep 1 && cd $HOME
	sudo $package_manager update -y && sudo $package_manager upgrade -y || \
	$package_manager update -y && $package_manager upgrade -y || \
	show_message_error_package_manager "update packages"
	printf "${ANSI_FG_YELLOW}[!] Trying install tools.\n\n ${ANSI_RESET}" 
	sudo $package_manager install vim figlet git nmap unzip zip unrar hydra util-linux tor torsocks clang nvm || \
	$package_manager install vim figlet git nmap unzip zip unrar hydra util-linux tor torsocks clang nvm || \
	show_message_error_package_manager "install packages" 1
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash || \
	show_message_error_package_manager "install packages" 1
	update_terminal_as_root
}

# packages to install [root]

update_terminal_as_root() {

	printf "\n\n${ANSI_FG_CYAN}[?] Wanna you install root package? " && ask_yesnot
	read -n 3 anspack
	case $anspack in
		yes)
			clear
			printf "${ANSI_FG_YELLOW}[!] Trying install root packages.\n\n"
			printf "${ANSI_FG_WHITE}"
			sleep 2
			sudo $package_manager install root-repo -y
			sudo $package_manager install macchanger -y
			sudo $package_manager update -y
			sudo $package_manager upgrade -y
			sleep 1
			;;
		no)
			printf "${ANSI_FG_WHITE}\n"
			;;
		*)
			show_error_1_root
			;;
	esac
	
}

# setup Dex-config

config_environment_by_default() {
	prompt_for_name
	modify_prompt
	read_enter	
}

# Menu dell thumb

menu_dellthum(){

	clear
	printf "${ANSI_FG_GREEN}{+}--Options:

	${ANSI_FG_CYAN}[00]${ANSI_FG_YELLOW} Back to main main menu  
	${ANSI_FG_CYAN}[01]${ANSI_FG_YELLOW} Install deltumbnails
	${ANSI_FG_CYAN}[02]${ANSI_FG_YELLOW} What is delthumbnails
	
	"
	printf "${ANSI_FG_GREEN} >>${ANSI_FG_CYAN} "
	read -n 2 answ
	case $answ in
		00)
			printf "Done..."
			;;
		01)
			delete_thumbnails
			;;
		02)
			printf 'Not inmplemented'
			;;
		*)
			show_error_8dt
			;;

	esac
}

#delete thumbnails

delete_thumbnails () {

	clear && cd /storage/emulated/0/DCIM
	#printf "${ANSI_FG_YELLOW}[!] Dellthumbnails has been installed."	
	if [ -d .thumbnails ]; then
		rm -rf .thumbnails/
		printf "${ANSI_FG_CYAN}#Thumbnails directory has been removed."
	else
		printf "${ANSI_FG_RED}[!] The thumbnails appears to have been removed."
	fi
	read_enter
}

#sudo

install_sudo_pkg () {

	clear && cd $HOME
	printf "${ANSI_FG_GREEN}#--Downloading sudo... ${ANSI_FG_WHITE}\n\n"
	
	if [ -e termux-sudo ]; then
		rm -f -R termux-sudo
	fi

	if [ -e $PREFIX/bin/sudo ]; then
		rm -f $PREFIX/bin/sudo
	fi

	if [ -e $PREFIX/bin/applets/sudo ]; then
		rm -f $PREFIX/bin/applets/sudo
	fi
	
	git clone https://gitlab.com/st42/termux-sudo && cd termux-sudo && chmod 777 sudo && mv sudo $PREFIX/bin/applets
	printf "${ANSI_FG_YELLOW}[!] Some files have been found\n"
	printf "${ANSI_FG_YELLOW} This files:${ANSI_FG_WHITE} " && ls
	printf "${ANSI_FG_CYAN}[?] Would you like to delete these files? " && ask_yesnot
	read -n 3 answ
	case $answ in

		yes)
			cd $HOME
			rm -rf termux-sudo
			printf "\n${ANSI_FG_YELLOW}[!] The files have been deleted.\n"
			sleep 2
			;;
		no)
			printf "\n${ANSI_FG_YELLOW}[!] The files have been saved.\n"
			sleep 2
			;;
		*)
			show_error_4
			;;

	esac
}

#sqlmap

install_sqlmap (){

	clear
	printf "${ANSI_FG_GREEN}#--Wait to install sqlmap. ${ANSI_FG_WHITE}\n\n"
	sleep 2
	python2 -m pip install --upgrade pip
	python2 -m pip install sqlmap
}

#Aircrack

install_aircrack () {

	clear
	printf "${ANSI_FG_YELLOW}[!]-Instalando aircrack-ng...\n\n"
	sleep 1
	$package_manager install aircrack-ng ethtool macchanger -y || \
	show_message_error_package_manager "aircrack-ng"
}


#seleccion bash

choose_bash_config() {

	clear
	printf "\n\n"
	printf "${ANSI_FG_GREEN}{+}--Options:
		
	${ANSI_FG_CYAN}[00]${ANSI_FG_YELLOW} Back to main menu
	${ANSI_FG_CYAN}[01]${ANSI_FG_YELLOW} Config new bash
	${ANSI_FG_CYAN}[02]${ANSI_FG_YELLOW} DexTro config\n
	"
	#la variable original for Qconfigbash
	printf "${ANSI_FG_GREEN} >>${ANSI_FG_CYAN} "
	read -n 2 answ 
	case $answ in

		00)
			printf "Done..."
			;;
		01)
			config_bash
			;;
		02)
			config_environment_by_default
			;;
		*)
			show_error_8
			;;
		esac
	
}

#Config bash

config_bash () {
    clear
    printf "${ANSI_FG_YELLOW}[?] Would you like to configure your console with oh-my-posh? " && ask_yesnot
    read -n 3 answ
    case $answ in
        yes)
            printf "${ANSI_RESET}\n\n${ANSI_FG_YELLOW}[!] Downloading oh-my-posh from curl repository\n\n"
            curl -s https://ohmyposh.dev/install.sh | bash
        	if ! curl -s https://ohmyposh.dev/install.sh | bash; then
                show_message_error "Error: Unable to connect to the internet or download oh-my-posh. Exiting configuration" true 
                return
            fi

            if [ $? -eq 0 ]; then
                printf "${ANSI_FG_GREEN}[!] oh-my-posh was installed successfully." && mkdir -p ~/.poshthemes &&
				cp /usr/local/bin/themes/*.omp.json ~/.poshthemes/ && 
				echo 'eval "$(oh-my-posh init bash --config ~/.poshthemes/jandedobbeleer.omp.json)"' >> ~/.bashrc && source ~/.bashrc
                printf "${ANSI_FG_GREEN}[!] oh-my-posh configured successfully."
				read_enter
            else
                printf "${ANSI_FG_RED}[!] Error: oh-my-posh installation failed."
				read_enter 
            fi
        ;;
        no)
            clear
            printf "${ANSI_RESET}${ANSI_FG_RED}[!] The config of bash hasn't been configured."
			read_enter
        ;;
        *)
            show_error_8cb
        ;;
    esac
}


#metasploit 

install_metasploit () {

	clear
	printf "${ANSI_FG_YELLOW}[!] Installing msf framework\n\n" && sleep 1
	$package_manager install unstable-repo metasploit -y && sleep 3
}

#keyboard changue

keyboard_mod(){

	clear
	mkdir -p $HOME/.termux/ 
	echo "extra-keys = [['ESC','/','-','HOME','UP','END','PGUP'],['TAB','CTRL','ALT','LEFT','DOWN','RIGHT','PGDN']]" > $HOME/.termux/termux.properties && echo "$rst" && printf "${ANSI_FG_YELLOW}[!] Some keys has been added please reset terminal." ||
	read_enter

}

#Wifi admin/MAC spoof

install_kickthemout() {

	clear
	printf "${ANSI_FG_YELLOW}[!] Installing kickthemount...\n\n " && cd $HOME
	sleep 1 
	git clone https://github.com/k4m4/kickthemout.git
	if [ -e $HOME/kickthemout ]; then
		printf "${ANSI_FG_RED}[!] Error the directory kickthemout already exists."
		read_enter
	else
		cd $HOME/kickthemout
		python -m pip install -r requirements.txt
	fi
}

# Error in option case

show_option_error() { 
	clear
	printf "${ANSI_BG_BLACK}${ANSI_FG_RED}[•]--# You have chosen an invalid option #--[•]" 
	read_enter
}

#show error case option 1 [root-pkg]

show_error_1_root() {
	show_option_error
	update_terminal_as_root
}

#show error case option 4

show_error_4() {
	show_option_error
	install_sudo_pkg
}

#show error case option 8

show_error_8() {
	show_option_error
	choose_bash_config       
}

#show error case option 8 [config_bash]

show_error_8cb() {
	show_option_error
	config_bash
}

#show error case option 8 [delete thumbnails]

show_error_8dt() {
	show_option_error
	menu_dellthum
}	


#show DexTr0 banner

show_banner_dextro() {
	clear
	printf "${ANSI_BG_BLACK}${ANSI_FG_CYAN}
	________          _____________ _____  ${ANSI_BG_BLACK}${ANSI_FG_GREEN}
	___  __ \______   ___ _  _/___ \  __ \ ${ANSI_BG_BLACK}${ANSI_FG_GREEN}
	__  / / /  __\_\-/_/ // /- /_/ / / / / ${ANSI_BG_BLACK}${ANSI_FG_GREEN}
	_  /_/ //  __/_> <__// /- _,_ / /_/ /  ${ANSI_BG_BLACK}${ANSI_FG_CYAN}
	/_____/ \___//_/-\_\/_/_//_/|_|\___/   ${ANSI_BG_BLACK}
	                                       ${ANSI_RESET}"
}


show_message_error_package_manager(){
	local message=${1:-"update the packages"}
	local sleeptime=${2:-2}
	printf "${ANSI_FG_RED}[!] Failed to $1 with the package manager: ${package_manager}.${ANSI_RESET}\n\n"
	sleep $sleeptime
}


#Question opt [yes/no]

ask_yesnot() {
	printf "${ANSI_FG_CYAN}[${ANSI_FG_YELLOW}yes${ANSI_FG_CYAN}/${ANSI_FG_YELLOW}no${ANSI_FG_CYAN}]${ANSI_FG_WHITE}\n >> "
}

read_enter(){
	printf "${ANSI_RESET}\n\n${ANSI_FG_YELLOW}[!] Press enter to continue.\n\n${ANSI_RESET}"
	read -s enter
}

prompt_for_name() {
    while true; do
        read -p "Please, enter a name: " username
        if [ -z "$username" ]; then
            printf "${ANSI_FG_RED}[!] Name cann't be void.${ANSI_RESET}"
            continue
        fi

        if [ $ENCODING_OK -eq 1 ]; then
            # Check if the name is compatible with the file's encoding
            echo "$username" | iconv -f UTF-8 -t "$encoding" >/dev/null 2>&1
            if [ $? -eq 0 ]; then
                break
            else
                printf "${ANSI_FG_RED}[!] Name unsupported to current encoding: $encoding.${ANSI_RESET}"
            fi
        else
            # Accept ASCII characters only
            if LC_ALL=C printf '%s' "$username" | grep -q '[^ -~]'; then
                printf "${ANSI_FG_RED}[!] Name doesn't contains characters ASCII.${ANSI_RESET}"
            else
                break
            fi
        fi
    done
}

modify_prompt() {
    BACKUP_FILE="${config_file}.bak.$(date +%s)"
    cp "$config_file" "$BACKUP_FILE"
    printf "${ANSI_RESET}${ANSI_FG_YELLOW}[!] The backup of config file has been saved. $BACKUP_FILE"

    # Remove existing PS1 definitions to avoid duplicates
    sed -i '/^export PS1=/d' "$config_file"
    sed -i '/^PS1=/d' "$config_file"

    # Append the new PS1 definition to the configuration file
    printf "export PS1='[\u@\h \W \t $username]\$ '" >> "$config_file"
    printf "${ANSI_FG_GREEN}[!]${ANSI_FG_YELLOW} Prompt has been update on $config_file"
}

menu_main