#!/bin/sh

# Inicializar variables
package_manager=""
package_manager_fetch=""
package_manager_update=""
package_manager_install=""

# Detectar gestor de paquetes según el sistema operativo
if [ -x "$(command -v apt-get)" ]; then
    package_manager="apt-get"
    package_manager_fetch="search"
    package_manager_update="update"
    package_manager_install="install"
elif [ -x "$(command -v dpkg)" ]; then
    package_manager="dpkg"
    package_manager_fetch="-l"
    package_manager_update="--configure -a"
    package_manager_install="-i"
elif [ -x "$(command -v yum)" ]; then
    package_manager="yum"
    package_manager_fetch="search"
    package_manager_update="update"
    package_manager_install="install"
elif [ -x "$(command -v dnf)" ]; then
    package_manager="dnf"
    package_manager_fetch="search"
    package_manager_update="update"
    package_manager_install="install"
elif [ -x "$(command -v zypper)" ]; then
    package_manager="zypper"
    package_manager_fetch="search"
    package_manager_update="refresh"
    package_manager_install="install"
elif [ -x "$(command -v pacman)" ]; then
    package_manager="pacman"
    package_manager_fetch="-Ss"
    package_manager_update="-Syu"
    package_manager_install="-S"
elif [ -x "$(command -v apk)" ]; then
    package_manager="apk"
    package_manager_fetch="search"
    package_manager_update="update"
    package_manager_install="add"
elif [ -x "$(command -v emerge)" ]; then
    package_manager="emerge"
    package_manager_fetch="--search"
    package_manager_update="--sync"
    package_manager_install=""
elif [ -x "$(command -v nix-env)" ]; then
    package_manager="nix-env"
    package_manager_fetch="-qaP"
    package_manager_update="--upgrade"
    package_manager_install="-iA"
elif [ -x "$(command -v flatpak)" ]; then
    package_manager="flatpak"
    package_manager_fetch="search"
    package_manager_update="update"
    package_manager_install="install"
elif [ -x "$(command -v snap)" ]; then
    package_manager="snap"
    package_manager_fetch="find"
    package_manager_update="refresh"
    package_manager_install="install"
elif [ -x "$(command -v brew)" ]; then
    package_manager="brew"
    package_manager_fetch="search"
    package_manager_update="update"
    package_manager_install="install"
elif [ -x "$(command -v pkg)" ]; then
    package_manager="pkg"
    package_manager_fetch="search"
    package_manager_update="update"
    package_manager_install="install"
elif [ -x "$(command -v port)" ]; then
    package_manager="port"
    package_manager_fetch="search"
    package_manager_update="selfupdate"
    package_manager_install="install"
else
    echo "No se pudo detectar un gestor de paquetes compatible."
    exit 1
fi

# Mostrar las configuraciones detectadas
echo "Gestor de paquetes detectado: $package_manager"
echo "Comando para buscar paquetes: $package_manager_fetch"
echo "Comando para actualizar paquetes: $package_manager_update"
echo "Comando para instalar paquetes: $package_manager_install"

# Funciones unificadas
buscar_paquete() {
    paquete="$1"
    sudo $package_manager $package_manager_fetch "$paquete"
}

actualizar_paquetes() {
    sudo $package_manager $package_manager_update
}

instalar_paquete() {
    paquete="$1"
    sudo $package_manager $package_manager_install "$paquete"
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

# delete thumbnails
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

#metasploit
install_metasploit () {

	clear
	printf "${ANSI_FG_YELLOW}[!] Installing msf framework\n\n" && sleep 1
	$package_manager install unstable-repo metasploit -y && sleep 3
}