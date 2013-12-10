class Libgdiplus < FPM::Cookery::Recipe
  description 'A library that implemented GDI+ on linux'
  homepage    'http://www.mono-project.com'

  name        'libgdiplus'
  version     '2.10.9'
  revision    1
  arch        'x86_64'
  section     'libraries'

  source      'http://download.mono-project.com/sources/libgdiplus/libgdiplus-2.10.9.tar.bz2'
  sha1        '5e127b818d9af032928c7f7cfba812c1231a8478'

  maintainer  'Henrik Feldt <henrik@haf.se>'

  build_depends %w[
    glib2-devel
    libpng-devel
    libjpeg-turbo-devel
    giflib-devel
    libtiff-devel
    libexif-devel
    libX11-devel
    fontconfig-devel
    gcc-c++
    make
    gettext
    autoconf
    automake
    libtool
]

  def build
    File.open('wrapper.sh', 'w+') do |io|
      io.write %Q{#!/bin/sh
export echo=echo
echo $*
exec $*
}
    end
    safesystem 'chmod +x ./wrapper.sh'

    configure :prefix => prefix
    safesystem './wrapper.sh', '/usr/bin/make'
  end

  def install
    make :install, 'DESTDIR' => destdir
  end
end
