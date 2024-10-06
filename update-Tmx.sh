#!/data/data/com.termux/files/usr/bin/bash

bse='\033[2;94m'
bo='\033[1;97m'
re='\033[1;91m'
gr='\033[1;92m'
be='\033[1;96m'
bs='\033[1;94m'
vi='\033[1;95m'
ye='\033[1;93m'
cu='\033[3;92m'
var=$var
co=0

APT=apt
PKG=pkg
ETC=$PREFIX/etc
NAME_CURRENT_FILE="update-Tmx.sh"

trap ctrl_c 2
 ctrl_c() {
	co=$(($co + 1))
	printf "$re#--Oops! [$co-3]$be\n"
	if [ $co == 3 ]; then
		sleep 1
		echo $(clear)
		printf "$re[!] An error has been found.\n"
		echo
		sleep 1
		printf "$ye#The script has finished...\n"
		echo
		exit 0
	fi
}

#check update is on home

if [ -e "$NAME_CURRENT_FILE" ]; then
	if [ -e "$HOME/Termux-update/$NAME_CURRENT_FILE" ]; then
		cd $HOME
		chmod +x "$HOME/Termux-update/$NAME_CURRENT_FILE"
	elif [ -e "$HOME/$NAME_CURRENT_FILE" ]; then
		clear
	else
		mv "$NAME_CURRENT_FILE $HOME"
		chmod +x "$HOME/$NAME_CURRENT_FILE"
		cd "$HOME"
	fi
elif [ -e "$HOME/storage/downloads/Termux-update/$NAME_CURRENT_FILE" ]; then
	mv "$HOME/storage/downloads/Termux-update/$NAME_CURRENT_FILE" $HOME
	chmod +x "$HOME/$NAME_CURRENT_FILE" 
else 
	echo $(clear)
	printf "$ye#Please move the *$NAME_CURRENT_FILE* file to home directory.\n\n"
	sleep 2
	printf "$re[!] The script has been closed"
	printf "$re."
	sleep 1
	printf "$re."
	sleep 1
	printf "$re.$bo\n\n"
	exit 0
fi
#menu principal
menu() {

	echo $(clear)
	bannerD0
	echo
	echo
	printf "$gr{+}--Options:
	
	$be[00]$ye Exit
	$be[01]$ye Install tools
	$be[02]$ye Install sqlmap
	$be[03]$ye Install metasploit
	$be[04]$ye Install sudo (root)
	$be[05]$ye Install kickthemout
	$be[06]$ye Install aircrack-ng (root)
	$be[07]$ye Changue config keyboard
	$be[08]$ye Changue config termux (home)\n
	"
	printf "$gr >>$be "
	read -n 2 op
	case $op in

		00)
			echo $(clear)
			printf "$ye[!]$be Script made by DexTr0\n\n$ye©DexTrø"
			sleep 1
			printf "$ye."
			sleep 1
			printf "$ye."
			sleep 1
			printf "$ye.\n\n"
			sleep 1
			exit
			;;
		01) 
			update
			;;
		02)
			sqlmap
			;;
		03)
			metasploit
			;;
		04)
			sudoPkg
			;;
		05)
			kickthemout
			;;
		06)
			aircrack
			;;
		07)
			keyboard_mod	
			;;

		08)     
			choosebash
			;;
		09)
			dellthum
			;;

		*)
			show_error
			;;
			
	esac
}

#packages to upgrade and install

update() {

	echo $(clear)
	printf "$re[!]$be Searching the OS type to download tools..."
	printf "$re[!]$gr--Loading packages...\n" 
	sleep 2
	cd $HOME
	printf "$ye"
	pkg update && pkg upgrade -y
	pkg install vim figlet git wget curl php python python2 perl nmap openssh unzip zip unrar hydra util-linux darkhttpd tor torsocks clang -y
	updateRP
}

#packages to install [root]

updateRP() {

	echo $(clear)
	printf "$be[#] Wanna you install root package? "
	ask_yesnot
	echo
	read -n 3 anspack
	case $anspack in
		yes)
			echo $(clear)
			printf "$ye[!] installing root package.\n\n"
			printf "$bo"
			sleep 2
			pkg install root-repo -y
			pkg install macchanger -y
			pkg update && pkg upgrade -y
			sleep 1
			menu
			;;
		no)
			printf "$bo\n"
			pkg update && pkg upgrade -y
			sleep 2
			menu
			;;
		*)
			show_error1rp
			;;
	esac
	
}

#setup Dex-config

configBash() {

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
	echo "PS1='$ye#--DexTrø ≈ $re[$be \W$re ]$ye:$bo\n>> '" >> $ETC/bash.bashrc
	echo "printf '$bs'" >> $ETC/bash.bashrc
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
		printf "$re[!]$gr Alread exists the directory (LabDTest).\n\n"
	else
		mkdir /storage/emulated/0/LabDTest
		printf "$be#--Has been made (LabDTest) directory.\n\n"
	fi

	printf "$ye[!] Press enter to continue.\n\n"
	read -s enter
		
	menu
}

dellthum(){

	echo $(clear)
	printf "$gr{+}--Options:

	$be[00]$ye Back to main menu  
	$be[01]$ye Install deltumbnails
	$be[02]$ye What is delthumbnails?
	
	"
	printf "$gr >>$be "
	read -n 2 delop
	case $delop in
		00)
			menu
			;;
		01)
			instdllth
			;;
		02)
			whtsdt
			;;
		*)
			show_error_8dt
			;;

	esac
	menu
}

#install dellthumbnails

instdllth () {

	echo $(clear)
	#printf "$ye[!] Dellthumbnails has been installed."
	cd /storage/emulated/0/DCIM
	if [ -d .thumbnails ]; then
		rm -rf .thumbnails/
		printf "$be#Thumbnails directory has been removed.\n\n"
		printf "$ye[!] Press enter to continue.\n \n"
		read -s enter
	else
		printf "$re[!] The thumbnails appears to have been removed.\n\n"
		printf "$ye[!] Press enter to continue. "
		read -s enter
		

	fi




}

#sudo

sudoPkg () {

	echo $(clear)
	printf "$gr#--Downloading sudo... $bo\n"
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
	printf "$gr[*]Some files have been found[*]\n"
	printf "$ye This files:$bo "
	ls
	printf "$be[#] Would you like to delete these files? "
	ask_yesnot
	read -n 3 opc
	case $opc in

		yes)
			cd $HOME
			rm -rf termux-sudo
			echo
			printf "\n$re[!]$ye The files have been deleted.\n"
			sleep 2
			;;
		no)
			echo
			printf "\n$gr[!]$ye The files have been saved.\n"
			sleep 2
			;;
		*)
			show_error4
			;;

	esac
	menu
	
}

#sqlmap

sqlmap (){

	echo $(clear)
	printf "$gr#--wait to install sqlmap$bo\n"
	echo
	sleep 2
	python2 -m pip install --upgrade pip
	python2 -m pip install sqlmap
	menu
}

#Aircrack

aircrack () {

	echo $(clear)
	printf "$ye[!]-Instalando aircrack-ng...\n\n"
	sleep 1
	pkg upgrade -y
	pkg install aircrack-ng ethtool macchanger -y
	sleep 2
	menu
}


#seleccion bash

choosebash() {

	echo $(clear)
	printf "\n\n"
	printf "$gr{+}--Options:
		
	$be[00]$ye Back to main menu
	$be[01]$ye Config new bash
	$be[02]$ye DexTro config\n
	"
	#la variable original for Qconfigbash
	printf "$gr >>$be "
	read -n 2 Opconfigbash 
	case $Opconfigbash in

		00)
			menu
			;;
		01)
			config_bash
			;;
		02)
			configBash
			;;
		*)
			show_error8
			;;
		esac
	
}

#menu config bash

menu_bash () {

	echo "-h"


}

#Config bash

config_bash () {

	echo $(clear)
	printf "$be[!]$ye Would you like config you console? "
	ask_yesnot
	printf "\n$be"
	read -n 3 Qsh
	printf "\n"
	case $Qsh in
		yes)
			printf "$bo"
			read -p "[$]-What is your name? >> " name
			printf "\n\n$vi[!]-Which color you wanna put on your name? \n\n"
			printf "$bo#This [1]\n"
			printf "$be#This [2]\n"
			printf "$ye#This [3]\n"
			printf "$gr#This [4]\n"
			printf "$bs#This [5]\n"
			printf "$re#This [6]\n"
			printf "\n$bo[$]-input an digit >> "
			read -n 3 Cname
			echo ""
			cd $PREFIX/etc
			if [ -e bash.bashrc ]; then
				rm bash.bahrc
			fi
		;;
	no)
			echo $(clear)
			printf "$re[!]$gr The config of bash haven't been configure"
			printf "\n\n$ye[!] Press enter to continue.\n\n"
			read -s enter
			choosebash
		;;
	*)
			show_error_8cb
		;;
	esac
}

#metasploit 

metasploit () {

	echo $(clear)
	sleep 1
	printf "$ye[!] Installing msf framework\n\n"
	sleep 1
	pkg install unstable-repo
	pkg install metasploit -y
	sleep 3
	menu
}

#variables

variable() {

	echo $(clear)
	
	menu

}

#keyboard changue

keyboard_mod(){

	echo $(clear)
	printf "$re[!]$gr Some keys has been added please reset termux.\n\n"
	printf "$ye[!] Press enter to continue. "
	read -s enter
	mkdir -p $HOME/.termux/&&echo "extra-keys = [['ESC','/','-','HOME','UP','END','PGUP'],['TAB','CTRL','ALT','LEFT','DOWN','RIGHT','PGDN']]" > $HOME/.termux/termux.properties&&echo "$rst"
	menu

}

#Wifi admin/MAC spoof

kickthemout() {

	clear
	printf "$ye[!] Installing kickthemount...\n\n "
	sleep 3
	cd $HOME
	git clone https://github.com/k4m4/kickthemout.git
	if [ -e $HOME/kickthemout ]; then
		clear
		printf "$re[!] Error the directory kickthemout already exist."
		printf "\n\n$ye[!] Press enter to continue."
		read -s enter
	else
		cd $HOME/kickthemout
		python -m pip install -r requirements.txt
	fi
	menu

	

}

# Error case

show_error() { 
	echo $(clear)
	printf "$re[•]--# You have chosen an invalid option #--[•]\n\n" 
	printf "$ye[!] Press enter to continue. "
	read -s enter
	menu
}

#show error case option 1 [root-pkg]

show_error1rp() {
	show_error
	updateRP
}

#show error case option 4

show_error4() {
	show_error
	sudoPkg
}

#show error case option 8

show_error8() {
	show_error
	choosebash       
}

#show error case option 8 [config_bash]

show_error_8cb() {
	show_error
	config_bash


}

#show error case option 8 [dellthumbnails]

show_error_8dt() {
	show_error
	dellthum

}	

#DexTr0 banner

bannerD0() {

	echo $(clear)
	printf "$be"
	
	printf '
	________            ________      _______ 
	___  __ \________  ____  __/________  __ \'
	printf "$gr"

	printf '
	__  / / /  _ \_  |/_/_  /  __  ___/  / / /'
	printf "$gr"
	printf '
	_  /_/ //  __/_>  < _  /   _  /   / /_/ /'

	printf "$bs"
	printf '
	/_____/ \___//_/|_| /_/    /_/    \____/'  



}

check_word() {
    if grep -qi "$1" archivo.txt; then|
        return 0  # true
    else
        return 1  # false
    fi
}

#Question opt [yes/no]

ask_yesnot() {

	printf "$be["
	printf "$ye"
	printf "yes$be/"
	printf "$ye"
	printf "no$be]"
	printf "$bo\n >> "

}
menu
