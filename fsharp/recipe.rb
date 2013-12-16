class FSharp < FPM::Cookery::Recipe
  description 'Functional programming language for mono'
  homepage 'https://github.com/fsharp/fsharp'

  name 'fsharp'
  version '3.0.31'
  revision 1
  arch 'x86_64'
  section 'runtimes'

  # 3.0.31-4-gc8843c2:
  source 'https://github.com/fsharp/fsharp',
    with: :git,
    sha: 'c8843c230ae332841aeb7336ccb90dde53bd8a6e'

  depends 'mono'

  def build
    safesystem "./autogen.sh --prefix=#{prefix}"
    make

    `grep -R -l "#{destdir}" . --include "*.Targets"`.split(/\n/).each do |file|
      inline_replace file do |s|
        s.sub! destdir, ""
      end
    end
  end
  def install
    make :install, 'DESTDIR' => destdir
  end
end
