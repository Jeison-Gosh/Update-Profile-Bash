#!/bin/sh

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
	printf "${ANSI_FG_GREEN} >> ${ANSI_FG_CYAN}"
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
	printf "${ANSI_FG_GREEN} >> ${ANSI_FG_CYAN}"
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
	printf "${ANSI_FG_GREEN} >> ${ANSI_FG_CYAN}"
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
    BACKUP_FILE="${config_file}.$(date +%s).bak"
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
