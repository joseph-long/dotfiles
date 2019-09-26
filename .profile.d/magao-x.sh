if [[ ! -z $MAGAOX_ROLE ]]; then
    export PS1="$(tput setab 5)$(tput setaf 0) [$MAGAOX_ROLE] $(tput sgr0) $PS1"
fi
