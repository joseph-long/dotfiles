if [[ ! -z $MAGAOX_ROLE ]]; then
    if [[ $MAGAOX_ROLE == AOC ]]; then
        bgcolor=5
    elif [[ $MAGAOX_ROLE == ICC ]]; then
        bgcolor=6
    elif [[ $MAGAOX_ROLE == RTC ]]; then
        bgcolor=2
    else
        bgcolor=7
    fi
    export PS1="$(tput setab $bgcolor)$(tput setaf 0) [$MAGAOX_ROLE] $(tput sgr0) $PS1"
fi
