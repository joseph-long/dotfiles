if [[ ! -z $(which yarn) ]]; then
    export PATH="$PATH:`yarn global bin`"
fi
