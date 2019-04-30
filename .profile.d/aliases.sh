alias shrinkpdf="gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook -dNOPAUSE -dQUIET -dBATCH -sOutputFile=shrunken.pdf"
alias ds9="ds9 -multiframe -mode region -zoom to fit"

function excpp() {
    exercism download --exercise=$1 --track=cpp
    exdir="$HOME/Exercism/cpp/$1"
    cd $exdir
    touch $1.{cpp,h}
    mkdir -p build
    cd build
    cmake -G "Unix Makefiles" ..
    make
    code ..
}