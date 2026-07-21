if [[ ! -z $MAGAOX_ROLE ]]; then
    fgcolor=30
    if [[ $MAGAOX_ROLE == AOC ]]; then
        bgcolor=45
    elif [[ $MAGAOX_ROLE == RTC ]]; then
        bgcolor=42
    elif [[ $MAGAOX_ROLE == ICC ]]; then
        bgcolor=46
    elif [[ $MAGAOX_ROLE == TIC ]]; then
        bgcolor=43
    elif [[ $MAGAOX_ROLE == TOC ]]; then
        bgcolor=44
    else
        bgcolor=47
    fi
    export PS1="\e[${bgcolor}m\e[${fgcolor}m [$MAGAOX_ROLE] \e[0m$PS1"
fi
