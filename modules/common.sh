#!/usr/bin/env bash

# ============================================================
# Terminal Tricks
# Common Functions
# ============================================================

# Main install location

TERMINAL_TRICKS_DIR="$HOME/.terminal_tricks"

BACKUP_DIR="$TERMINAL_TRICKS_DIR/backups"


# ------------------------------------------------------------
# Logging
# ------------------------------------------------------------

log() {
    echo
    echo "[Terminal Tricks] $1"
}


# ------------------------------------------------------------
# Backup system
# ------------------------------------------------------------

backup_file() {

    local FILE="$1"

    if [ -f "$FILE" ]; then

        mkdir -p "$BACKUP_DIR"

        DATE=$(date +"%Y%m%d_%H%M%S")

        cp "$FILE" "$BACKUP_DIR/$(basename "$FILE")_$DATE"

        echo "Backup created:"
        echo "$BACKUP_DIR/$(basename "$FILE")_$DATE"

    fi
}


# ------------------------------------------------------------
# Detect shell
# ------------------------------------------------------------

detect_shell() {

    CURRENT_SHELL=$(basename "${SHELL:-bash}")

    case "$CURRENT_SHELL" in

        bash)
            SHELL_TYPE="bash"
            ;;

        zsh)
            SHELL_TYPE="zsh"
            ;;

        *)
            SHELL_TYPE="unknown"
            ;;

    esac


    echo
    echo "Detected shell:"
    echo "$SHELL_TYPE"
    echo

}


# ------------------------------------------------------------
# Add managed block to config files
# ------------------------------------------------------------

add_config_block() {

    local FILE="$1"
    local BLOCK="$2"

    START="# >>> TERMINAL TRICKS >>>"
    END="# <<< TERMINAL TRICKS <<<"


    touch "$FILE"


    if grep -q "$START" "$FILE"; then

        echo "Terminal Tricks block already exists:"
        echo "$FILE"

    else

        {
            echo
            echo "$START"
            cat "$BLOCK"
            echo "$END"

        } >> "$FILE"


        echo "Added Terminal Tricks block:"
        echo "$FILE"

    fi

}


# ------------------------------------------------------------
# Command existence check
# ------------------------------------------------------------

check_command() {

    if command -v "$1" >/dev/null 2>&1; then

        echo "OK   $1"

    else

        echo "MISS $1"

    fi

}


# ------------------------------------------------------------
# Banner
# ------------------------------------------------------------

banner() {

echo
echo "=============================================="
echo "              TERMINAL TRICKS"
echo "       Terminal Automation Toolkit"
echo "=============================================="
echo

}
