alias shrinkpdf="gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook -dNOPAUSE -dQUIET -dBATCH -sOutputFile=shrunken.pdf"
alias ds9="ds9 -multiframe -mode region -zoom to fit"
alias osg="ssh osg"
alias kitsune="ssh kitsune"
function proxydask() {
  ssh -L8787:${1}:8787 -L8786:${1}:8786 puma
}
