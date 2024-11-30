#!/bin/sh

# Chosee a package manager
if echo $OS | grep -iqE 'nux|linux|debian|ubuntu|fedora|arch|suse|manjaro|alpine|gentoo|centos|rhel|rocky|opensuse|mint|kali|pop' ; then
    for manager in apt-get apt yum pkg dnf zypper pacman yast apk; do
        if check_command_exists $manager; then
            package_manager="$manager"
            break
        fi
    done
fi

if [ -z "$package_manager" ]; then
    show_message_error "Package manager not found... Aborting"
    exit_water_mark_author 3 1
else
    show_message_log "Chosen package manager: ${ANSI_FG_BLUE}$package_manager"
fi
