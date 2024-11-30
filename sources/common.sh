#!/bin/sh

# Messages
show_message_log(){
	local message=${1:-"Unknown Error"}
	local readline=${2:-false}
	local blankcanvas=${3:-false}
	local sleeptime=${4:-0}

	if [ $blankcanvas = false ]; then
		printf "${ANSI_FG_GREEN}[!] ${message}.${ANSI_RESET}"
	else
		printf "${ANSI_FG_GREEN}${message}.${ANSI_RESET}"
	fi
	sleep $sleeptime
	if [ $readline = true ]; then
		read_enter
	else
		printf "\n\n"
	fi
}

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
