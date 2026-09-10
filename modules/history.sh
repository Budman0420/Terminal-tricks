#!/usr/bin/env bash

# ============================================================
# Terminal Tricks
# History Tools
# ============================================================


# ------------------------------------------------------------
# History Configuration
# ------------------------------------------------------------

export HISTSIZE=10000
export HISTFILESIZE=20000

export HISTCONTROL="ignoreboth:erasedups"

export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S  "


# ------------------------------------------------------------
# History Search
# ------------------------------------------------------------

hsearch() {

    if [[ $# -eq 0 ]]; then

        echo
        echo "Usage:"
        echo "  hsearch <text>"
        echo

        return 1

    fi

    history \
        | grep -i -- "$*" \
        | tail -50
}


# ------------------------------------------------------------
# Last Commands
# ------------------------------------------------------------

hlast() {

    local COUNT="${1:-20}"

    if ! [[ "$COUNT" =~ ^[0-9]+$ ]]; then

        echo "Usage: hlast [number]"
        return 1

    fi

    history | tail -n "$COUNT"
}


# ------------------------------------------------------------
# Clear Current History
# ------------------------------------------------------------

hclear() {

    echo
    echo "WARNING: This clears the current shell history."
    echo

    read -rp "Continue? [y/N]: " ANSWER

    if [[ "$ANSWER" =~ ^[Yy]$ ]]; then

        history -c

        echo
        echo "Current shell history cleared."

    else

        echo
        echo "History clear cancelled."

    fi
}


# ------------------------------------------------------------
# Save History
# ------------------------------------------------------------

hsave() {

    if [[ -n "${HISTFILE:-}" ]]; then

        history -a "$HISTFILE"

        echo
        echo "History written to:"
        echo "$HISTFILE"
        echo

    else

        echo
        echo "HISTFILE is not configured."
        echo

        return 1

    fi
}


# ------------------------------------------------------------
# Reload History
# ------------------------------------------------------------

hload() {

    if [[ -n "${HISTFILE:-}" && -f "$HISTFILE" ]]; then

        history -r "$HISTFILE"

        echo
        echo "History reloaded from:"
        echo "$HISTFILE"
        echo

    else

        echo
        echo "History file not found."
        echo

        return 1

    fi
}


# ------------------------------------------------------------
# History Help
# ------------------------------------------------------------

hhelp() {

    echo
    echo "=============================================="
    echo "             TERMINAL TRICKS HISTORY"
    echo "=============================================="
    echo

    echo "  hsearch <text>   Search command history"
    echo "  hlast [number]   Show recent commands"
    echo "  hsave            Save history immediately"
    echo "  hload            Reload history"
    echo "  hclear           Clear current shell history"
    echo "  hhelp            Show history help"

    echo
}
