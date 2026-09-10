#!/usr/bin/env bash

# ============================================================
# Terminal Tricks
# Shared Aliases
# ============================================================


# ------------------------------------------------------------
# Navigation
# ------------------------------------------------------------

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias home='cd "$HOME"'
alias projects='cd "$HOME/Projects" 2>/dev/null || echo "Projects directory not found."'


# ------------------------------------------------------------
# Listing files
# ------------------------------------------------------------

alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'

alias tree1='tree -L 1'
alias tree2='tree -L 2'
alias tree3='tree -L 3'


# ------------------------------------------------------------
# System
# ------------------------------------------------------------

alias ram='free -h'
alias disks='lsblk -f'
alias mounts='findmnt'
alias ports='ss -tulpn'


# ------------------------------------------------------------
# Network
# ------------------------------------------------------------

alias myip='hostname -I'
alias routes='ip route'
alias connections='nmcli connection show'


# ------------------------------------------------------------
# Package management
# ------------------------------------------------------------

if command -v apt >/dev/null 2>&1; then

    alias install='sudo apt install'
    alias remove='sudo apt remove'
    alias search='apt search'
    alias update='sudo apt update'
    alias upgrade='sudo apt upgrade'

fi


# ------------------------------------------------------------
# File operations
# ------------------------------------------------------------

alias cls='clear'
alias c='clear'

alias path='echo "$PATH" | tr ":" "\n"'

alias where='pwd'


# ------------------------------------------------------------
# Safety
# ------------------------------------------------------------

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'


# ------------------------------------------------------------
# Terminal Tricks
# ------------------------------------------------------------

alias tricks='help'
alias tricks-help='help'
