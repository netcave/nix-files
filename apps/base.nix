{ stdenv, fetchurl, perl, cmake, vala, pkgconfig, glib, gtk3, granite, gnome3, libnotify, gettext, makeWrapper }:

stdenv.mkDerivation rec {
  majorVersion = "0.3";
  minorVersion = "1.3";
  name = "pantheon-files";
  src = fetchurl {
    url = "https://launchpad.net/pantheon-files/0.2.x/0.2.4/+download/pantheon-files-0.2.4.tar.xz";
    # url = "https://launchpad.net/pantheon-terminal/${majorVersion}.x/${majorVersion}.${minorVersion}/+download/${name}.tgz";
    sha256 = "7eaf1ecd076d46bc2e43373982dd02b62663c2d2f1d4430ff771314cf4366b81";
    # sha256 = "0bfrqxig26i9qhm15kk7h9lgmzgnqada5snbbwqkp0n0pnyyh4ss";
  };

  preConfigure = ''
    export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:${granite}/lib64/pkgconfig"
  '';

  preFixup = ''
    for f in $out/bin/*; do
      wrapProgram $f \
        --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH:$XDG_ICON_DIRS:$out/share"
    done
  '';

  buildInputs = with gnome3; [
    perl cmake vala pkgconfig glib gtk3 granite libnotify gettext makeWrapper
    libgee gsettings_desktop_schemas defaultIconTheme
  ];
  meta = {
    description = "elementary OS's terminal";
    longDescription = "A super lightweight, beautiful, and simple terminal. It's designed to be setup with sane defaults and little to no configuration. It's just a terminal, nothing more, nothing less. Designed for elementary OS.";
    homepage = https://launchpad.net/pantheon-terminal;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.vozz ];
  };
}
