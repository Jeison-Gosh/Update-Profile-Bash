#!/bin/sh

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

ETC=etc
LIMIT_EXIT_COUNTER=5
NAME_CURRENT_FILE='update-tmx.sh'
NAME_WORK_DIRECTORY='TerminalUpdateProfile'

#VARIABLES
encoding=utf-8
exitcount=0
config_file=bash
package_manager=apt

exit_water_mark_author(){
	local sleeptime=${1:-0}
	local codeexit=${2:-0}
	exitcount=-1
	stty -echo icanon time 0 min 0
	sleep $sleeptime && clear
    printf "${ANSI_BG_BLACK}${ANSI_FG_RED}[•]--# Script is closing now. Please wait. #--[•]\n\n${ANSI_RESET}${ANSI_FG_WHITE}[!] Script made by DexTr0${ANSI_RESET}\n\n"
	sleep 1
    printf "${ANSI_FG_YELLOW}█████████" && sleep 1
    printf "\n${ANSI_FG_BLUE}█████████" && sleep 1
    printf "\n${ANSI_FG_RED}█████████"  && sleep 1
    printf "\n\n${ANSI_BG_BLACK}${ANSI_FG_YELLOW}© This software is copyleft and licensed under the GNU Affero General Public License.\n"
	printf 'For more information, visit https://www.gnu.org/licenses/agpl-3.0.html'
	printf "${ANSI_RESET}\n\n"
	stty echo icanon
	exit $codeexit
}

# Load anothers scripts.
load_script() {
    script_path="${1:-./sources/common.sh}"
    if [ -f "$script_path" ]; then
        . "$script_path"
        echo "file $script_path loaded."
    else
        echo "file $script_path not found."
    fi
}

# Handle Functions 
handle_error() {
	printf "${ANSI_BG_RED}${ANSI_FG_WHITE}#--Oops! An error has been detected. [$exitcount-$LIMIT_EXIT_COUNTER]${ANSI_RESET}\n"
	exitcount=$(($exitcount + 1))
	if [ $exitcount == $LIMIT_EXIT_COUNTER ]; then
		sleep 1 && clear
		show_message_error "It's seems that some error has been ocurred" false false 1
		show_message_error "#The script has been stopped" false true
		exit_water_mark_author 2 1
	fi
}

handle_signals() {
    if echo "$exitcount" | grep -q '^-'; then
        return 0
    fi
	exitcount=$(($exitcount + 1))
	if [ $exitcount -le $LIMIT_EXIT_COUNTER ]; then
		printf "${ANSI_BG_RED}${ANSI_FG_WHITE}#--Oops! [$exitcount-$LIMIT_EXIT_COUNTER]${ANSI_RESET}\n"
	fi
	if [ $exitcount -eq $LIMIT_EXIT_COUNTER ]; then
		clear
		show_message_warn "It's seems that you wan't close the script"
		show_message_warn "#The script has been stopped" false true
		exit_water_mark_author 2
	fi
}

load_script "sources/fetch-pm.sh"
trap handle_signals INT TERM
trap handle_error ERR

find_shell_config() {
    SHELL_NAME=$(basename "$SHELL")
    case "$SHELL_NAME" in
        bash)
            if [ -f $HOME/.bashrc ]; then
                config_file=$HOME/.bashrc
            elif [ -f $HOME/.bash_profile ]; then
                config_file=$HOME/.bash_profile
            else
                config_file=$HOME/.profile
            fi
            ;;
        zsh)
            config_file=$HOME/.zshrc
            ;;
        *)
            show_message_error "Unsupported shell: $SHELL_NAME"
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
        load_script /etc/os-release
        OS=$ID
    elif command -v lsb_release >/dev/null 2>&1; then
        OS=$(lsb_release -si)
    else
        OS=$(uname -s)
    fi
	ARCH=$(uname -m)

	if [ -z "$OSTYPE" ]; then
    	show_message_error "OSTYPE var environment is not defined... Aborting"
    	exit_water_mark_author 3 1
    fi
}

# Find the compatibility of script with the OS.

find_operative_system
find_shell_config
check_encoding
echo "Operating System: $OS"
echo "Architecture: $ARCH"

load_script "./sources/fetch-pm.sh"
load_script "./sources/main-menu.sh"