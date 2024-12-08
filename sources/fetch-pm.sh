#!/bin/sh

# Chosee a package manager
case "$OS" in
    ubuntu|debian)
        if check_command_exists "apt-get"; then
            package_manager="apt-get"
            package_manager_fetch="search"
            package_manager_update="update"
            package_manager_install="install"
        elif check_command_exists "dpkg"; then
            package_manager="dpkg"
            package_manager_fetch="-l"
            package_manager_update="--configure -a"
            package_manager_install="-i"
        fi
        ;;
    fedora|centos|rhel)
        if check_command_exists "dnf"; then
            package_manager="dnf"
            package_manager_fetch="search"
            package_manager_update="update"
            package_manager_install="install"
        elif check_command_exists "yum"; then
            package_manager="yum"
            package_manager_fetch="search"
            package_manager_update="update"
            package_manager_install="install"
        fi
        ;;
    opensuse)
        if check_command_exists "zypper"; then
            package_manager="zypper"
            package_manager_fetch="search"
            package_manager_update="refresh"
            package_manager_install="install"
        elif check_command_exists "rpm"; then
            package_manager="rpm"
            package_manager_fetch="-q"
            package_manager_update="--rebuilddb"
            package_manager_install="-i"
        fi
        ;;
    arch|manjaro)
        if check_command_exists "pacman"; then
            package_manager="pacman"
            package_manager_fetch="-Ss"
            package_manager_update="-Syu"
            package_manager_install="-S"
        fi
        ;;
    alpine)
        if check_command_exists "apk"; then
            package_manager="apk"
            package_manager_fetch="search"
            package_manager_update="update"
            package_manager_install="add"
        fi
        ;;
    gentoo)
        if check_command_exists "emerge"; then
            package_manager="emerge"
            package_manager_fetch="--search"
            package_manager_update="--sync"
            package_manager_install=""
        fi
        ;;
    nixos)
        if check_command_exists "nix-env"; then
            package_manager="nix-env"
            package_manager_fetch="-qaP"
            package_manager_update="--upgrade"
            package_manager_install="-iA"
        fi
        ;;
    *)
        echo "Operating System is not supported."
        exit_water_mark_author 3 1
        ;;
esac

if [ -z "$package_manager" ]; then
    show_message_error "Package manager not found... Aborting"
    exit_water_mark_author 3 1
else
    show_message_log "Chosen package manager: ${ANSI_FG_BLUE}$package_manager"
fi