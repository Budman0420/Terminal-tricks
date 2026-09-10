#!/usr/bin/env bash

# ============================================================
# Terminal Tricks
# Cleanup Tools
# ============================================================


# ------------------------------------------------------------
# Clean Package Cache
# ------------------------------------------------------------

clean_packages() {

    echo
    echo "Package cache cleanup"
    echo

    if command -v apt >/dev/null 2>&1; then

        echo "APT package cache detected."
        echo

        sudo apt clean

    elif command -v pacman >/dev/null 2>&1; then

        echo "Pacman detected."
        echo "Automatic cache removal is disabled for safety."
        echo
        echo "Use pacman -Sc manually if needed."

    elif command -v dnf >/dev/null 2>&1; then

        sudo dnf clean all

    elif command -v zypper >/dev/null 2>&1; then

        sudo zypper clean --all

    elif command -v apk >/dev/null 2>&1; then

        echo "APK detected."
        echo "No automatic cache cleanup configured."

    else

        echo "No supported package manager found."

    fi

    echo
}


# ------------------------------------------------------------
# Clean Temporary Files
# ------------------------------------------------------------

clean_temp() {

    echo
    echo "Temporary file cleanup"
    echo

    echo "User temporary directory:"
    echo "$TMPDIR"

    echo
    echo "System temporary directory:"
    echo "/tmp"

    echo
    echo "Terminal Tricks will NOT automatically delete /tmp."
    echo "System temporary files can belong to active programs."
    echo

}


# ------------------------------------------------------------
# Clean Old Terminal Tricks Backups
# ------------------------------------------------------------

clean_backups() {

    local BACKUP_DIR="$HOME/.terminal_tricks/backups"

    echo
    echo "Terminal Tricks backup cleanup"
    echo

    if [[ ! -d "$BACKUP_DIR" ]]; then

        echo "Backup directory does not exist."
        return 0

    fi

    echo "Backup directory:"
    echo "$BACKUP_DIR"
    echo

    echo "Current backups:"
    find "$BACKUP_DIR" \
        -maxdepth 1 \
        -type f \
        -printf '%TY-%Tm-%Td %TH:%TM  %f\n' \
        | sort -r

    echo
    echo "No backups were deleted."
    echo "Automatic deletion will require explicit confirmation."

}


# ------------------------------------------------------------
# Find Empty Directories
# ------------------------------------------------------------

emptydirs() {

    local SEARCH_DIR="${1:-.}"

    echo
    echo "Searching for empty directories:"
    echo "$SEARCH_DIR"
    echo

    find "$SEARCH_DIR" \
        -type d \
        -empty \
        2>/dev/null

    echo
}


# ------------------------------------------------------------
# Find Broken Symlinks
# ------------------------------------------------------------

brokenlinks() {

    local SEARCH_DIR="${1:-.}"

    echo
    echo "Searching for broken symbolic links:"
    echo "$SEARCH_DIR"
    echo

    find "$SEARCH_DIR" \
        -xtype l \
        2>/dev/null

    echo
}


# ------------------------------------------------------------
# Cleanup Help
# ------------------------------------------------------------

cleanhelp() {

    echo
    echo "=============================================="
    echo "              TERMINAL TRICKS CLEANUP"
    echo "=============================================="
    echo

    echo "  clean_packages    Clean package caches"
    echo "  clean_temp        Inspect temporary files"
    echo "  clean_backups     Inspect Terminal Tricks backups"
    echo "  emptydirs [dir]   Find empty directories"
    echo "  brokenlinks [dir] Find broken symlinks"
    echo "  cleanhelp         Show cleanup help"

    echo
}
