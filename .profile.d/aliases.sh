alias shrinkpdf="gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook -dNOPAUSE -dQUIET -dBATCH -sOutputFile=shrunken.pdf"
alias ds9="ds9 -multiframe -mode region -zoom to fit"
alias rustdoc="rustup docs --toolchain=stable-x86_64-apple-darwin"
alias grep='grep --color'
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
