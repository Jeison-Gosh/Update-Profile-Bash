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
 
# Checks
check_command_exists() {
  command -v "$1" > /dev/null 2>&1 && echo "$1" && return 0
  return 1
}

# Reads

read_enter(){
	printf "${ANSI_RESET}\n\n${ANSI_FG_YELLOW}[!] Press enter to continue.\n\n${ANSI_RESET}"
	read -s enter
}