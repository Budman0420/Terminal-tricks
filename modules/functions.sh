#!/usr/bin/env bash

# ============================================================
# Terminal Tricks
# Core Functions
# ============================================================


# ------------------------------------------------------------
# System Information
# ------------------------------------------------------------

sysinfo() {

    echo
    echo "=============================================="
    echo "                 SYSTEM INFO"
    echo "=============================================="
    echo

    echo "User:      $(whoami)"
    echo "Hostname:  $(hostname)"
    echo "Shell:     ${SHELL:-unknown}"
    echo "Kernel:    $(uname -r)"
    echo "OS:"
    grep PRETTY_NAME /etc/os-release 2>/dev/null \
        | cut -d= -f2- \
        | tr -d '"'

    echo
    echo "Uptime:"
    uptime -p

    echo
}


# ------------------------------------------------------------
# Hardware Information
# ------------------------------------------------------------

hardware() {

    echo
    echo "=============================================="
    echo "               HARDWARE INFO"
    echo "=============================================="
    echo

    echo "CPU:"
    lscpu 2>/dev/null \
        | grep -m1 "Model name" \
        | sed 's/^[[:space:]]*//'

    echo
    echo "CPU Cores:"
    nproc 2>/dev/null

    echo
    echo "Memory:"
    free -h

    echo
    echo "Graphics:"
    lspci 2>/dev/null \
        | grep -Ei "vga|3d|display" \
        || echo "Graphics information unavailable."

    echo
    echo "Network:"
    lspci 2>/dev/null \
        | grep -Ei "network|ethernet" \
        || echo "Network hardware information unavailable."

    echo
}


# ------------------------------------------------------------
# Network Information
# ------------------------------------------------------------

netinfo() {

    echo
    echo "=============================================="
    echo "                NETWORK INFO"
    echo "=============================================="
    echo

    echo "Hostname:"
    hostname

    echo
    echo "IP Addresses:"
    hostname -I 2>/dev/null \
        || echo "Unable to determine IP address."

    echo
    echo "Interfaces:"
    ip -brief address 2>/dev/null \
        || echo "ip command unavailable."

    echo
    echo "Routes:"
    ip route 2>/dev/null \
        || echo "Route information unavailable."

    echo
}


# ------------------------------------------------------------
# Disk Information
# ------------------------------------------------------------

diskinfo() {

    echo
    echo "=============================================="
    echo "                 DISK INFO"
    echo "=============================================="
    echo

    echo "Block Devices:"
    lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS 2>/dev/null \
        || echo "lsblk unavailable."

    echo
    echo "Filesystem Usage:"
    df -h

    echo
}


# ------------------------------------------------------------
# Process Information
# ------------------------------------------------------------

processes() {

    echo
    echo "=============================================="
    echo "               TOP PROCESSES"
    echo "=============================================="
    echo

    ps aux --sort=-%cpu 2>/dev/null \
        | head -11

    echo
}


# ------------------------------------------------------------
# Find Large Files
# ------------------------------------------------------------

bigfiles() {

    local SEARCH_DIR="${1:-.}"

    echo
    echo "Searching for large files in:"
    echo "$SEARCH_DIR"
    echo

    find "$SEARCH_DIR" \
        -type f \
        -printf '%s %p\n' 2>/dev/null \
        | sort -nr \
        | head -20 \
        | numfmt --field=1 --to=iec 2>/dev/null \
        || echo "Unable to complete large-file search."

    echo
}


# ------------------------------------------------------------
# Package Installer
# ------------------------------------------------------------

i() {

    if [[ $# -eq 0 ]]; then
        echo "Usage: i <package>"
        return 1
    fi

    if command -v apt >/dev/null 2>&1; then

        sudo apt install "$@"

    elif command -v pacman >/dev/null 2>&1; then

        sudo pacman -S "$@"

    elif command -v dnf >/dev/null 2>&1; then

        sudo dnf install "$@"

    elif command -v zypper >/dev/null 2>&1; then

        sudo zypper install "$@"

    elif command -v apk >/dev/null 2>&1; then

        sudo apk add "$@"

    else

        echo "No supported package manager found."
        return 1

    fi
}


# ------------------------------------------------------------
# Package Search
# ------------------------------------------------------------

f() {

    if [[ $# -eq 0 ]]; then
        echo "Usage: f <package>"
        return 1
    fi

    if command -v apt >/dev/null 2>&1; then

        apt search "$@"

    elif command -v pacman >/dev/null 2>&1; then

        pacman -Ss "$@"

    elif command -v dnf >/dev/null 2>&1; then

        dnf search "$@"

    elif command -v zypper >/dev/null 2>&1; then

        zypper search "$@"

    else

        echo "No supported package manager found."
        return 1

    fi
}


# ------------------------------------------------------------
# Explain a Command
# ------------------------------------------------------------

what() {

    if [[ $# -eq 0 ]]; then
        echo "Usage: what <command>"
        return 1
    fi

    echo
    echo "Command:"
    echo "$1"
    echo

    command -v "$1" 2>/dev/null \
        || echo "Command not found."

    echo

    if command -v man >/dev/null 2>&1; then
        man "$1" 2>/dev/null \
            | col -b 2>/dev/null \
            | head -40
    else
        echo "Manual pages are not installed."
    fi
}


# ------------------------------------------------------------
# Directory Jumping
# ------------------------------------------------------------

jump() {

    case "${1:-}" in

        projects)

            cd "$HOME/Projects" 2>/dev/null \
                || echo "Projects directory not found."

            ;;

        ai)

            cd "$HOME/AI_Tutor_Project" 2>/dev/null \
                || echo "AI project directory not found."

            ;;

        dp)

            cd "$HOME/DIGITAL_PURGATORY_VAULT" 2>/dev/null \
                || echo "Digital Purgatory directory not found."

            ;;

        tricks)

            cd "$HOME/Terminal-tricks" 2>/dev/null \
                || echo "Terminal Tricks directory not found."

            ;;

        home)

            cd "$HOME"

            ;;

        *)

            echo
            echo "Available jumps:"
            echo
            echo "  jump home"
            echo "  jump projects"
            echo "  jump ai"
            echo "  jump dp"
            echo "  jump tricks"
            echo

            ;;

    esac
}


# ------------------------------------------------------------
# Bash Configuration Backup
# ------------------------------------------------------------

backupbash() {

    local BACKUP_DIR="$HOME/.terminal_tricks/backups"

    mkdir -p "$BACKUP_DIR"

    local DATE
    DATE=$(date +"%Y%m%d_%H%M%S")

    echo
    echo "Creating Bash configuration backup..."
    echo

    for FILE in \
        "$HOME/.bashrc" \
        "$HOME/.bash_aliases" \
        "$HOME/.inputrc" \
        "$HOME/.bash_profile" \
        "$HOME/.profile" \
        "$HOME/.zshrc" \
        "$HOME/.zprofile"
    do

        if [[ -f "$FILE" ]]; then

            cp "$FILE" \
                "$BACKUP_DIR/$(basename "$FILE")_$DATE"

            echo "Backed up: $FILE"

        fi

    done

    echo
    echo "Backup complete:"
    echo "$BACKUP_DIR"
    echo
}


# ------------------------------------------------------------
# Terminal Tricks Doctor
# ------------------------------------------------------------

doctor() {

    echo
    echo "=============================================="
    echo "               TERMINAL TRICKS DOCTOR"
    echo "=============================================="
    echo

    echo "Shell:"
    echo "  ${SHELL:-unknown}"

    echo
    echo "Current shell:"
    echo "  $(basename "${SHELL:-unknown}")"

    echo
    echo "PATH:"
    echo "$PATH" | tr ':' '\n'

    echo
    echo "Required commands:"
    check_command bash
    check_command grep
    check_command sed
    check_command awk
    check_command find
    check_command ls
    check_command lsblk
    check_command lspci
    check_command systemctl

    echo
    echo "Terminal Tricks installation:"
    
    if [[ -d "$HOME/.terminal_tricks" ]]; then
        echo "  OK   ~/.terminal_tricks"
    else
        echo "  MISS ~/.terminal_tricks"
    fi

    echo
}


# ------------------------------------------------------------
# Command Center Menu
# ------------------------------------------------------------

menu() {

    while true; do

        clear

        echo
        echo "=============================================="
        echo "                 TERMINAL TRICKS"
        echo "=============================================="
        echo
        echo "  1) System information"
        echo "  2) Hardware information"
        echo "  3) Network information"
        echo "  4) Disk information"
        echo "  5) Top processes"
        echo "  6) Doctor"
        echo "  7) Reset / Recovery"
        echo "  8) Projects"
        echo "  9) Exit"
        echo

        read -rp "Select: " CHOICE

        case "$CHOICE" in

            1)
                sysinfo
                read -rp "Press Enter to continue..."
                ;;

            2)
                hardware
                read -rp "Press Enter to continue..."
                ;;

            3)
                netinfo
                read -rp "Press Enter to continue..."
                ;;

            4)
                diskinfo
                read -rp "Press Enter to continue..."
                ;;

            5)
                processes
                read -rp "Press Enter to continue..."
                ;;

            6)
                doctor
                read -rp "Press Enter to continue..."
                ;;

            7)
                echo
                echo "Recovery commands:"
                echo
                echo "  reset wifi"
                echo "  reset network"
                echo "  reset audio"
                echo "  reset bluetooth"
                echo "  reset usb"
                echo "  reset display"
                echo "  reset failed"
                echo "  reset all"
                echo
                read -rp "Press Enter to continue..."
                ;;

            8)
                projects
                read -rp "Press Enter to continue..."
                ;;

            9)
                clear
                return
                ;;

            *)
                echo
                echo "Invalid selection."
                sleep 1
                ;;

        esac

    done
}


# ------------------------------------------------------------
# Project Navigation
# ------------------------------------------------------------

projects() {

    echo
    echo "=============================================="
    echo "                 PROJECTS"
    echo "=============================================="
    echo

    echo "Projects directory:"
    echo "$HOME/Projects"

    echo

    if [[ -d "$HOME/Projects" ]]; then

        ls -lah "$HOME/Projects"

    else

        echo "Projects directory does not exist."

    fi

    echo
}


# ------------------------------------------------------------
# Rebuild Helper
# ------------------------------------------------------------

rebuild() {

    echo
    echo "Terminal Tricks rebuild helper"
    echo

    if [[ -f "$HOME/.bashrc" ]]; then
        echo "Bash configuration found."
    fi

    if [[ -f "$HOME/.zshrc" ]]; then
        echo "Zsh configuration found."
    fi

    echo
    echo "Run the Terminal Tricks installer to rebuild the toolkit."
    echo
}
