class Mono < FPM::Cookery::Recipe
  # note: this takes about an hour to build
  description 'Mono is a portablle and open source implementation of the .NET framework for Unix, Windows, MacOS and other operating systems'
  homepage   'http://www.mono-project.com'

  name       'mono'
  version    '3.2.8'
  revision   2
  arch       'x86_64'
  section    'runtimes'

  source     "https://github.com/mono/mono.git",
    :with => 'git',
    :tag  => 'mono-3.2.8'
  
  maintainer 'Henrik Feldt <henrik@haf.se>'

  depends    'libgdiplus'

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

  post_install 'post-install'

  def build
    File.open('wrapper.sh', 'w+') do |io|
      io.write %Q{
#!/bin/sh
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
