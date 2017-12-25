with import <nixpkgs> {};

stdenv.mkDerivation rec {
  version = "5.1.9";
  name = "tiddlywiki-${version}";

  src = fetchurl {
    url = "http://registry.npmjs.org/tiddlywiki/-/${name}.tgz";
    sha256 = "09k9nfv8hxjz3l5fdsry77nm0swnqccz43bzmsbq09lxdd70vnz8";
  };

  # node is the interpreter used to run this script
  buildInputs = [ nodejs ];

  installPhase = ''
    mkdir -p $out/bin;
    cp -r * $out/bin/
    mv $out/bin/tiddlywiki.js $out/bin/tiddlywiki
  '';

  meta = with stdenv.lib; {
    description = "creates and serves TiddlyWiki sites";
    longDescription = ''
      TiddlyWiki a unique non-linear notebook for capturing, organising and
      sharing complex information.
    '';
    homepage = http://tiddlywiki.com;
    license = licenses.bsd2;
    platforms = platforms.linux;
  };
}

