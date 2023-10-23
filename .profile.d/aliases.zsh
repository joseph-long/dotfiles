alias ds9="ds9 -view layout vertical -multiframe -zoom to fit"
alias rustdoc="rustup docs --toolchain=stable-x86_64-apple-darwin"
alias puma="ssh puma"

alias goodnoise="afplay /System/Library/Sounds/Blow.aiff"
alias badnoise="afplay /System/Library/Sounds/Hero.aiff"
function makenoise () {
  local last="$?"
  if [[ "$last" == '0' ]]; then
    goodnoise
  else
    badnoise
  fi
  $(exit "$last")
}

export CLICOLOR=1
