if [[ $(hostname -f) != *cluster && $(hostname -f) != *hpc.arizona.edu ]]; then
    alias ocelote="ssh -J josephlong@hpc.arizona.edu josephlong@login.ocelote.hpc.arizona.edu"
    alias elgato="ssh -J josephlong@hpc.arizona.edu josephlong@login.elgato.hpc.arizona.edu"
    alias puma="ssh -J josephlong@hpc.arizona.edu josephlong@shell.hpc.arizona.edu"
fi
