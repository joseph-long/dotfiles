
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/josephlong/mambaforge/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/josephlong/mambaforge/etc/profile.d/conda.sh" ]; then
        . "/Users/josephlong/mambaforge/etc/profile.d/conda.sh"
    else
        export PATH="/Users/josephlong/mambaforge/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
conda activate py310
bindkey '\e[H'    beginning-of-line
bindkey '\e[F'    end-of-line

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

# Autoload zsh add-zsh-hook and vcs_info functions (-U autoload w/o substition, -z use zsh style)
autoload -Uz add-zsh-hook vcs_info
# Enable substitution in the prompt.
setopt prompt_subst
# Run vcs_info just before a prompt is displayed (precmd)
add-zsh-hook precmd vcs_info

# Enable checking for (un)staged changes, enabling use of %u and %c
zstyle ':vcs_info:*' check-for-changes true
# Set custom strings for an unstaged vcs repo changes (*) and staged changes (+)
zstyle ':vcs_info:*' unstagedstr ' !'
zstyle ':vcs_info:*' stagedstr ' +'
# Set the format of the Git information for vcs_info
zstyle ':vcs_info:git:*' formats       '(%b%u%c) '
zstyle ':vcs_info:git:*' actionformats '(%b|%a%u%c) '
NEWLINE=$'\n'
RPROMPT='%F{yellow}$vcs_info_msg_0_%f'
PROMPT="%F{blue}%*%f %F{green}%m%f:%~ %F{magenta}%n%f$NEWLINE%B%%%b "

PATH="$PATH:$HOME/.local/bin"

alias ds9="ds9 -view layout vertical -multiframe -zoom to fit"
alias rustdoc="rustup docs --toolchain=stable-x86_64-apple-darwin"
alias goodnoise="afplay /System/Library/Sounds/Blow.aiff"
alias badnoise="afplay /System/Library/Sounds/Hero.aiff"
alias puma="ssh puma"

function makenoise () {
  local last="$?"
  if [[ "$last" == '0' ]]; then
    goodnoise
  else
    badnoise
  fi
  $(exit "$last")
}

export  TUNE_RESULT_DELIM='/'
