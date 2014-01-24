class FSharp < FPM::Cookery::Recipe
  description 'Functional programming language for mono'
  homepage 'https://github.com/fsharp/fsharp'

  name 'fsharp'
  version '3.0.31'
  revision 2
  arch 'x86_64'
  section 'runtimes'

  # 3.0.31-4-gc8843c2:
  source 'https://github.com/fsharp/fsharp',
    :with => :git,
    :sha => 'c8843c230ae332841aeb7336ccb90dde53bd8a6e'

  depends 'mono'

  def build
    safesystem "./autogen.sh --prefix=#{prefix}"
    make
  end
  def install
    make :install, 'DESTDIR' => destdir
    # see https://github.com/fsharp/fsharp/issues/204
    safesystem "(cd #{destdir} && find . -type f -exec sed -i 's|#{destdir}||g' {} \\;)"
  end
end

